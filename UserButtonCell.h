/* -*- ObjC -*-
 * UserButtonCell.h --- ButtonCell w/user data interface.
 *
 * Copyright (c) 2023 Paul Ward <asmodai@gmail.com>
 *
 * Author:     Paul Ward <asmodai@gmail.com>
 * Maintainer: Paul Ward <asmodai@gmail.com>
 * Created:    Thu, 26 Jan 2023 22:12:47 +0000 (GMT)
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

#ifndef _UserButtonCell_h_
#define _UserButtonCell_h_

#import <appkit/ButtonCell.h>

@interface UserButtonCell : ButtonCell
{
  id _user;
}

- (id)init;
- (id)free;

- (id)setUser:(id)value;
- (id)user;

@end

#endif /* !_UserButtonCell_h_ */

/* UserButtonCell.h ends here. */
