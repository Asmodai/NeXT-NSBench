/* -*- ObjC -*-
 * Disk.h --- Disks and /etc/mtab interface.
 *
 * Copyright (c) 2023 Paul Ward <asmodai@gmail.com>
 *
 * Time-stamp: <23/01/29 09:54:56 asmodai>
 *
 * Author:     Paul Ward <asmodai@gmail.com>
 * Maintainer: Paul Ward <asmodai@gmail.com>
 * Created:    Sun, 29 Jan 2023 06:25:27 +0000 (GMT)
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

#ifndef _Disk_h_
#define _Disk_h_

#import <objc/Object.h>
#import <objc/HashTable.h>

#import "String.h"

typedef enum {
  FSUnknown = 0,
  FS42BSD,
  FS43BSD,
  FSDOS,
  FSCDFS,
  FSMacintosh,
  FSIgnore,
} fs_type_t;

typedef enum {
  DiskUnknown = 0,
  DiskHard,
  DiskFloppy,
  DiskCDROM,
  DiskOptical,
  DiskBad,
} disk_type_t;

@interface DiskInfo : Object
{
}

+ (void)disksFromMounted:(HashTable *)mounts;
+ (id)diskFromPath:(const char *)path;

@end /* DiskInfo */

@interface Disk : Object
{
  /* Filesystem and disk. */
  String      *fsName;
  String      *mntPoint;
  fs_type_t    fsType;
  disk_type_t  dskType;

  /* Flags. */
  BOOL readOnly;
  BOOL noAuto;
  BOOL removable;
  BOOL systemDisk;

  /* Statistics */
  size_t blkSize;               // Block size.
  size_t blkCount;              // Total blocks.
  size_t blkFree;               // Free blocks.
  size_t blkAvail;              // Free blocks available to non-root.
  size_t indTotal;              // Total i-nodes (file nodes).
  size_t indFree;               // Free i-nodes.
}

- (id)init;
- (id)free;

- (const String *)filesystemName;
- (const fs_type_t)filesystemType;
- (const String *)mountPoint;
- (const disk_type_t)diskType;

- (const char *)filesystemTypeString;
- (const char *)diskTypeString;

- (BOOL)isSystemDisk;
- (BOOL)isReadOnly;
- (BOOL)isAutomounted;
- (BOOL)isRemovable;

- (BOOL)stat;

- (size_t)blockSize;
- (size_t)blockCount;
- (size_t)blocksFree;
- (size_t)blocksAvailable;
- (size_t)filesTotal;
- (size_t)filesFree;
- (float)usageFloat;
- (int)usageInt;

/* Private methods. */
- (void)_setFSName:(const char *)name;
- (void)_setMntPoint:(const char *)name;
- (void)_setFSType:(fs_type_t)val;
- (void)_setDskType:(disk_type_t)val;
- (void)_setReadOnly:(BOOL)val;
- (void)_setNoAuto:(BOOL)val;
- (void)_setRemovable:(BOOL)val;
- (void)_setSystemDisk:(BOOL)val;

@end /* Disk */

#endif /* !_Disk_h_ */

/* Disk.h ends here. */
