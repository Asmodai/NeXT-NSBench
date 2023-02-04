/* -*- ObjC -*-
 * BundlePrimary.m --- Some title
 *
 * Copyright (c) 2023 Paul Ward <asmodai@gmail.com>
 *
 * Time-stamp: <23/02/04 00:04:51 asmodai>
 *
 * Author:     Paul Ward <asmodai@gmail.com>
 * Maintainer: Paul Ward <asmodai@gmail.com>
 * Created:    Fri,  3 Feb 2023 14:51:16 +0000 (GMT)
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

#import "BundlePrimary.h"

#import "../Mach.h"

Mach *mach_instance = nil;

@implementation CoreMark

- didLoadNib
{
  if (mach_instance == nil) {
    mach_instance = mach;
  }

  return self;
}

- (BOOL)loadFirst
{
  return NO;
}

@end /* CoreMark */

/* BundlePrimary.m ends here. */
