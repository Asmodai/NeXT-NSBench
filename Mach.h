/* -*- ObjC -*-
 * Mach.h --- Mach message proxy interface.
 *
 * Copyright (c) 2023 Paul Ward <asmodai@gmail.com>
 *
 * Author:     Paul Ward <asmodai@gmail.com>
 * Maintainer: Paul Ward <asmodai@gmail.com>
 * Created:    Fri, 27 Jan 2023 20:31:59 +0000 (GMT)
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
 * This exists here because bundles cannot link against
 * libsys_s at runtime.
 */
/* }}} */

#ifndef _Mach_h_
#define _Mach_h_

#import <objc/Object.h>

#import <sys/types.h>
#import <sys/vfs.h>

#import <mach/mach.h>
#import <mach/vm_statistics.h>
#import <mach/host_info.h>
#import <mach/mach_host.h>

@interface Mach : Object
{
  id mach;
}

+ (id)sharedInstance;
+ (void)initialize;

- (id)init;

- (int)host_id;
- (void)kernel_version:(kernel_version_t *)data;
- (void)cpu_type:(char **)data
         subtype:(char **)data;
- (void)vm_statistics:(vm_statistics_data_t *)data;
- (void)machine_info:(machine_info_data_t *)data;

@end

#endif /* !_Mach_h_ */

/* Mach.h ends here. */
