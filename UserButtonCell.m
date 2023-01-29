/* -*- ObjC -*-
 * UserButtonCell.m --- ButtonCell w/user data implementation.
 *
 * Copyright (c) 2023 Paul Ward <asmodai@gmail.com>
 *
 * Author:     Paul Ward <asmodai@gmail.com>
 * Maintainer: Paul Ward <asmodai@gmail.com>
 * Created:    Thu, 26 Jan 2023 22:14:12 +0000 (GMT)
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

#import "UserButtonCell.h"

@implementation UserButtonCell

- (id)init
{
  if ((self = [super init]) == nil) {
    return nil;
  }

  _user = nil;

  return self;
}

- (id)free
{
  _user = nil;

  return [super free];
}

- (id)setUser:(id)value
{
  _user = value;

  return self;
}

- (id)user
{
  return _user;
}

@end /* UserButtonCell */

/* UserButtonCell.m ends here. */
