/* -*- ObjC -*-
 * MemInfo.h  --- Some title
 *
 * Copyright (c) 2023 Paul Ward <asmodai@gmail.com>
 *
 * Time-stamp: <23/01/27 20:51:25 asmodai>
 *
 * Author:     Paul Ward <asmodai@gmail.com>
 * Maintainer: Paul Ward <asmodai@gmail.com>
 * Created:    Fri, 27 Jan 2023 19:43:03 +0000 (GMT)
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

#ifndef _MemInfo_h_
#define _MemInfo_h_

#import <objc/Object.h>
#import "../Mach.h"

@interface MemInfo : Object
{
  id     mach;
  size_t physical;
  float  freeCount;
  float  activeCount;
  float  inactiveCount;
  float  wiredCount;
}

+ (id)sharedInstance;
+ (void)initialize;

- (id)init;

- (void)setMachProxy:(id)anObject;
- (void)poll;

- (int)physical;

- (float)freeCount;
- (float)activeCount;
- (float)inactiveCount;
- (float)wiredCount;

@end

#endif /* !_MemInfo_h_ */

/* MemInfo.h ends here. */
