/* -*- ObjC -*-
 * Platform.h --- Platform detection.
 *
 * Copyright (c) 2023 Paul Ward <asmodai@gmail.com>
 *
 * Author:     Paul Ward <asmodai@gmail.com>
 * Maintainer: Paul Ward <asmodai@gmail.com>
 * Created:    Wed,  1 Feb 2023 10:13:32 +0000 (GMT)
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

#ifndef _Platform_h_
#define _Platform_h_

#import <objc/Object.h>

#import "String.h"

@interface Platform : Object
{
  String *_name;
  String *_platform;
  String *_codename;
  int     _major;
  int     _minor;
  String *_kernel;
  BOOL    _openstep;
}

+ (id)sharedInstance;
+ (void)initialize;

- (String *)system;             // "NEXTSTEP 3.7"
- (String *)platform;           // "NEXTSTEP"
- (String *)codeName;           // "PhotonV84"
- (int)majorVersion;            // 3
- (int)minorVersion;            // 7
- (String *)kernelVersion;      // "NeXT Mach ..."
- (BOOL)isOpenStep;             // NO

- (void)_getKernelVersion;

@end

#endif /* !_Platform_h_ */

/* Platform.h ends here. */
