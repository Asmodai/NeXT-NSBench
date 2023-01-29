/* -*- ObjC -*-
 * NetInfo.h --- NetInfo proxy interface.
 *
 * Copyright (c) 2023 Paul Ward <asmodai@gmail.com>
 *
 * Author:     Paul Ward <asmodai@gmail.com>
 * Maintainer: Paul Ward <asmodai@gmail.com>
 * Created:    Sat, 28 Jan 2023 08:01:22 +0000 (GMT)
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
 * This exists to act as a proxy so modules can make calls to
 * NetInfo servers.
 */
/* }}} */

#ifndef _NetInfo_h_
#define _NetInfo_h_

#import <netinfo/ni.h>
#import <sys/types.h>
#import <objc/Object.h>
#import <objc/HashTable.h>

@interface NetInfo : Object
{
  void      *_ni;
}

+ (id)sharedInstance;
+ (void)initialize;

- (id)init;
- (id)free;

- (BOOL)connect;
- (void)disconnect;

- (BOOL)getDirectory:(const char *)path
             toTable:(HashTable *)table;
  

@end

#endif /* !_NetInfo_h_ */

/* NetInfo.h ends here. */
