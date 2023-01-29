/* -*- ObjC -*-
 * Disk.m --- Disks and /etc/mtab implementation.
 *
 * Copyright (c) 2023 Paul Ward <asmodai@gmail.com>
 *
 * Time-stamp: <23/01/29 13:15:06 asmodai>
 *
 * Author:     Paul Ward <asmodai@gmail.com>
 * Maintainer: Paul Ward <asmodai@gmail.com>
 * Created:    Sun, 29 Jan 2023 06:37:33 +0000 (GMT)
 */

/* {{{ License: */
/*
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 3
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
/* }}} */

/* {{{ Commentary: */
/*
 *
 */
/* }}} */

#import "Disk.h"
#import "Mach.h"
#import "Malloc.h"
#import "Utils.h"

#import <libc.h>
#import <stdio.h>
#import <string.h>
#import <math.h>

#define __STRICT_BSD__
#import <mntent.h>
#undef  __STRICT_BSD__

#import <sys/types.h>
#import <sys/vfs.h>

static const char *fs_type_names[] = {
  "Unknown",
  "4.2 BSD",
  "4.3 BSD",
  "DOS",
  "CDFS",
  "Macintosh",
  "IGNORE"
};

static const char *disk_type_names[] = {
  "Unknown",
  "Hard Disk",
  "Floppy Disk",
  "CD-ROM",
  "Optical Disk",
  "BAD",
};

struct mount_opts_s {
  char rw;
  char ro;
  char noauto;
  char removable;
  
  char iscdrom;
  char isoptical;
};

static
disk_type_t
parse_disk_type(struct mntent *mnt)
{
  register char *cp = NULL;

  if (mnt->mnt_fsname[0] == '\0') {
    return DiskUnknown;
  }

  cp = mnt->mnt_fsname;
  while (cp != NULL) {
    if (*cp == '\0') {
      break;
    }

    /*
     * [r]hd == IDE hard disk.
     * [r]sd == SCSI disk of some kind.
     * [r]fd == floppy disk.
     * [r]od == optical disk.
     */
    if      (strncmp(cp, "/hd",  3) == 0) return DiskHard;
    else if (strncmp(cp, "/rhd", 4) == 0) return DiskHard;
    else if (strncmp(cp, "/sd",  3) == 0) return DiskHard;
    else if (strncmp(cp, "/rsd", 4) == 0) return DiskHard;
    else if (strncmp(cp, "/fd",  3) == 0) return DiskFloppy;
    else if (strncmp(cp, "/rfd", 4) == 0) return DiskFloppy;
    else if (strncmp(cp, "/od",  3) == 0) return DiskOptical;
    else if (strncmp(cp, "/rod", 4) == 0) return DiskOptical;

    cp++;
  }

  return DiskUnknown;
}

static
struct mount_opts_s
parse_opts(struct mntent *mnt)
{
  register char       *cp   = NULL;
  struct mount_opts_s  mopt = { 0 };

  if (mnt->mnt_opts[0] == '\0') {
    return mopt;
  }

  cp = mnt->mnt_opts;
  while (cp != NULL) {
    if (*cp == '\0') {
      break;
    }

    if (strncmp(cp, "rw", 2) == 0) {
      mopt.rw = 1;
      cp += 3;
    } else if (strncmp(cp, "ro", 2) == 0) {
      mopt.ro = 1;
      cp += 3;
    } else if (strncmp(cp, "noauto", 6) == 0) {
      mopt.noauto = 1;
      cp += 7;
    } else if (strncmp(cp, "removable", 9) == 0) {
      mopt.removable = 1;
      cp += 10;
    } else if (strncmp(cp, "filesystem=", 11) == 0) {
      cp += 11;

      if (strncmp(cp, "CDROM", 5) == 0 ||
          strncmp(cp, "cdrom", 5) == 0)
      {
        mopt.iscdrom = 1;
        cp += 6;
      }
    } else {
      cp++;
    }
  }

  return mopt;
}

static
fs_type_t
parse_fs_type(const char *type)
{
  if      (strcmp(type, MNTTYPE_42)  == 0) return FS42BSD;
  else if (strcmp(type, MNTTYPE_43)  == 0) return FS43BSD;
  else if (strcmp(type, MNTTYPE_PC)  == 0) return FSDOS;
  else if (strcmp(type, MNTTYPE_CFS) == 0) return FSCDFS;
  else if (strcmp(type, MNTTYPE_MAC) == 0) return FSMacintosh;

  /*
   * We don't care for any other types of file system here.
   */
  return FSIgnore;
}

static
int
do_statfs(const char *path, struct statfs *stats)
{
  int ret = 0;

  if ((ret = statfs(path, stats)) < 0) {
    perror("statfs()");
  }

  return ret;
}

@implementation DiskInfo

+ (void)disksFromMounted:(HashTable *)mounts
{
  struct mntent       *mntp    = NULL;
  struct mount_opts_s  mopts   = { 0 };
  FILE                *mnttab  = NULL;
  fs_type_t            fstype  = FSUnknown;
  disk_type_t          dsktype = DiskUnknown;

  if (mounts == nil) {
    mounts = [[HashTable alloc] initKeyDesc:"@"
                                  valueDesc:"@"
                                   capacity:0];
  }

  mnttab = setmntent(MOUNTED, "r");
  while ((mntp = getmntent(mnttab)) != NULL) {
    fstype = parse_fs_type(mntp->mnt_type);
    if (fstype == FSIgnore) {
      continue;
    }

    dsktype = parse_disk_type(mntp);
    mopts   = parse_opts(mntp);

    {
      Disk *dsk = [[Disk alloc] init];
      
      [dsk _setFSName:mntp->mnt_fsname];
      [dsk _setMntPoint:mntp->mnt_dir];
      [dsk _setFSType:fstype];
      [dsk _setReadOnly:(BOOL)mopts.ro];
      [dsk _setNoAuto:(BOOL)mopts.noauto];
      [dsk _setRemovable:(BOOL)mopts.removable];

      if (mntp->mnt_dir[0] == '/' && mntp->mnt_dir[1] == '\0') {
        [dsk _setSystemDisk:YES];
      }

      if (mopts.iscdrom == 1) {
        [dsk _setDskType:DiskCDROM];
      } else {
        [dsk _setDskType:dsktype];
      }

      [mounts insertKey:[[String alloc] initWithString:mntp->mnt_dir]
                  value:dsk];
    }
  }
  endmntent(mnttab);
}

+ (id)diskFromPath:(const char *)path
{
  return nil;
}

@end /* DiskInfo */

@implementation Disk

- (id)init
{
  if ((self = [super init]) == nil) {
    return nil;
  }

  fsName   = [[String alloc] init];
  mntPoint = [[String alloc] init];

  fsType     = FSUnknown;
  dskType    = DiskUnknown;
  readOnly   = NO;
  noAuto     = NO;
  removable  = NO;
  systemDisk = NO;

  return self;
}

- (id)free
{
  DESTROY(fsName);
  DESTROY(mntPoint);

  return [super free];
}

- (const String *)filesystemName
{
  return (const String *)fsName;
}

- (const String *)mountPoint
{
  return (const String *)mntPoint;
}

- (const fs_type_t)filesystemType
{
  return (const fs_type_t)fsType;
}

- (const disk_type_t)diskType
{
  return (const disk_type_t)dskType;
}

- (const char *)filesystemTypeString
{
  if (fsType == FSUnknown || fsType >= FSIgnore) {
    fprintf(stderr, "NSBench: Invalid filesystem '%d' in Disk object?\n",
            fsType);
    return NULL;
  }

  return fs_type_names[fsType];
}

- (const char *)diskTypeString
{
  if (dskType == DiskUnknown || dskType >= DiskBad) {
    fprintf(stderr, "NSBench: Invalid disk type `%d' in Disk object?\n",
            dskType);
    return NULL;
  }

  return disk_type_names[dskType];
}


- (BOOL)isReadOnly
{
  return readOnly;
}

- (BOOL)isAutomounted
{
  return !noAuto;
}

- (BOOL)isRemovable
{
  return removable;
}

- (BOOL)isSystemDisk
{
  return systemDisk;
}

- (size_t)blockSize
{
  return blkSize;
}

- (size_t)blockCount
{
  return blkCount;
}

- (size_t)blocksFree
{
  return blkFree;
}

- (size_t)blocksAvailable
{
  return blkAvail;
}

- (size_t)filesTotal
{
  return indTotal;
}

- (size_t)filesFree
{
  return indFree;
}

- (float)usageFloat
{
  register double total = 0;
  register double used  = 0;
  register double rsvd  = 0;

  total  = blkCount;
  used   = total   - blkFree;
  rsvd   = blkFree - blkAvail;
  total -= rsvd;

  return (float)(used / total * 100.0);
}

- (int)usageInt
{
  return (int)ceil((double)[self usageFloat]);
}

- (BOOL)stat
{
  struct statfs fs;

  if (do_statfs([mntPoint stringValue], &fs) < 0) {
    return NO;
  }

  blkSize  = fs.f_bsize;
  blkCount = fs.f_blocks;
  blkFree  = fs.f_bfree;
  blkAvail = fs.f_bavail;

  indTotal = fs.f_files;
  indFree  = fs.f_ffree;

  return YES;
}

/* -------------------------------------------------------------------
 * Private methods
 */

- (void)_setFSName:(const char *)name
{
  [fsName setStringValue:name];
}

- (void)_setMntPoint:(const char *)mnt
{
  [mntPoint setStringValue:mnt];
}

- (void)_setFSType:(fs_type_t)val
{
  fsType = val;
}

- (void)_setDskType:(disk_type_t)val
{
  dskType = val;
}

- (void)_setReadOnly:(BOOL)val
{
  readOnly = val;
}

- (void)_setNoAuto:(BOOL)val
{
  noAuto = val;
}

- (void)_setRemovable:(BOOL)val
{
  removable = val;
}

- (void)_setSystemDisk:(BOOL)val
{
  systemDisk = val;
}

@end /* Disk */

/* Disk.m ends here. */
