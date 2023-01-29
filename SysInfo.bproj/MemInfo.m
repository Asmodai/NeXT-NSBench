/* -*- ObjC -*-
 * MemInfo.m  --- Some title
 *
 * Copyright (c) 2023 Paul Ward <asmodai@gmail.com>
 *
 * Time-stamp: <23/01/27 21:59:25 asmodai>
 *
 * Author:     Paul Ward <asmodai@gmail.com>
 * Maintainer: Paul Ward <asmodai@gmail.com>
 * Created:    Fri, 27 Jan 2023 19:45:44 +0000 (GMT)
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

#import "MemInfo.h"

#include <libc.h>
#include <mach/mach.h>
#include <mach/vm_statistics.h>
#include <mach/mach_host.h>

static MemInfo *sharedMemInfo = nil;

@implementation MemInfo

+ (id)sharedInstance
{
  if (sharedMemInfo == nil) {
    [MemInfo initialize];
  }

  return sharedMemInfo;
}

+ (void)initialize
{
  if (self == [MemInfo class]) {
    sharedMemInfo = [[self alloc] init];
  }
}

- (id)init
{
  if ((self = [super init]) == nil) {
    return nil;
  }

  physical      = 0;
  freeCount     = 0.0;
  activeCount   = 0.0;
  inactiveCount = 0.0;
  wiredCount    = 0.0;

  return self;
}

- (void)setMachProxy:(id)anObject
{
  mach = anObject;
}

- (void)poll
{
  size_t               pgsz   = 0;
  vm_statistics_data_t vmstat;
  machine_info_data_t  machinfo;

  if (mach == nil) {
    return;
  }

  [mach vm_statistics:&vmstat];

  if (physical == 0) {
    [mach machine_info:&machinfo];

    physical = machinfo.memory_size / (1024 * 1024);
  }

  pgsz          = vmstat.pagesize;
  freeCount     = vmstat.free_count * pgsz;
  activeCount   = vmstat.active_count * pgsz;
  inactiveCount = vmstat.inactive_count * pgsz;
  wiredCount    = vmstat.wire_count * pgsz;
}

- (int)physical
{
  return physical;
}

- (float)freeCount
{
  return freeCount;
}

- (float)activeCount
{
  return activeCount;
}

- (float)inactiveCount
{
  return inactiveCount;
}

- (float)wiredCount
{
  return wiredCount;
}

@end /* MemInfo */

/* MemInfo.m ends here. */
