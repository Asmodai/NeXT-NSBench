/* -*- ObjC -*-
 * Mach.m --- Mach message proxy implementation.
 *
 * Copyright (c) 2023 Paul Ward <asmodai@gmail.com>
 *
 * Author:     Paul Ward <asmodai@gmail.com>
 * Maintainer: Paul Ward <asmodai@gmail.com>
 * Created:    Fri, 27 Jan 2023 20:32:15 +0000 (GMT)
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

#import "Mach.h"

#import <libc.h>

#import <sys/types.h>
#import <sys/vfs.h>

#import <mach/mach.h>
#import <mach/vm_statistics.h>
#import <mach/host_info.h>
#import <mach/mach_host.h>
#import <mach/mach_error.h>

static Mach *sharedMach = nil;

@implementation Mach

+ (id)sharedInstance
{
  if (sharedMach == nil) {
    [Mach initialize];
  }

  return sharedMach;
}

+ (void)initialize
{
  if (self == [Mach class]) {
    sharedMach = [[self alloc] init];
  }
}

- (id)init
{
  return [super init];
}

/* This isn't really a Mach call... but, meh. */
- (int)host_id
{
  return gethostid();
}

/* Nor is this, but, meh. */
- (double)get_disk_usage:(char *)path
{
  struct statfs   fs;
  register double total    = 0;
  register double usage    = 0;
  register double reserved = 0;

  if (statfs(path, &fs) < 0) {
    perror("statfs()");
    return -1.0;
  }

  if (fs.f_blocks == 0) {
    fprintf(stderr, "NSBench: No blocks on `%s', how?\n", path);
    return -1.0;
  }

  total    = fs.f_blocks;
  usage    = total - fs.f_bfree;
  reserved = fs.f_bfree  - fs.f_bavail;

  total -= reserved;

  return usage / total * 100.0;
}

- (int)statfs:(char *)path
     toStruct:(struct statfs *)buf
{
  int ret = 0;

  if ((ret = statfs(path, buf)) < 0) {
    perror("statfs()");
    return 0;
  }

  return ret;
}

- (void)kernel_version:(kernel_version_t *)data
{
  kern_return_t kret = 0;

  kret = host_kernel_version(host_self(), data);
  if (kret != KERN_SUCCESS) {
    mach_error("host_kernel_version() failed", kret);
    exit(EXIT_FAILURE);
  }
}

- (void)cpu_type:(char *)cpuType
         subtype:(char *)cpuSubtype
{
  struct host_basic_info kbi   = { 0 };
  kern_return_t          kret  = 0;
  unsigned int           count = HOST_BASIC_INFO_COUNT;

  kret = host_info(host_self(), HOST_BASIC_INFO, (host_info_t)&kbi, &count);
  if (kret != KERN_SUCCESS) {
    mach_error("host_info() failed", kret);
    exit(EXIT_FAILURE);
  }

  slot_name(kbi.cpu_type,
            kbi.cpu_subtype,
            (char **)cpuType,
            (char **)cpuSubtype);
}

- (void)vm_statistics:(vm_statistics_data_t *)data
{
  kern_return_t kret = 0;

  kret = vm_statistics(task_self(), data);
  if (kret != KERN_SUCCESS) {
    mach_error("vm_statistics() failed", kret);
    exit(EXIT_FAILURE);
  }
}

- (void)machine_info:(machine_info_data_t *)data
{
  kern_return_t kret = 0;

  kret = xxx_host_info(task_self(), data);
  if (kret != KERN_SUCCESS) {
    mach_error("xxx_host_info() failed", kret);
    exit(EXIT_FAILURE);
  }
}

@end /* Mach */

/* Mach.m ends here. */
