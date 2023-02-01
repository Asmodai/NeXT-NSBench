/* -*- ObjC -*-
 * NXFactor.h  --- Some title
 *
 * Copyright (c) 2023 Paul Ward <asmodai@gmail.com>
 * Copyright (c) 2001-2002 by Philippe C.D. Robert
 *
 * Author:     Paul Ward <asmodai@gmail.com>
 * Maintainer: Paul Ward <asmodai@gmail.com>
 * Created:    Fri, 27 Jan 2023 04:21:24 +0000 (GMT)
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

#ifndef _NXFactor_h_
#define _NXFactor_h_

#import "../NSBModule.h"

@interface NXFactor : NSBModule
{
  id btnFactor;
  id wndFactor;
  id mtxFactor;
  id fldFactor;
  id vvwFactor;

  id wndLog;
  id txtLog;
}

- didLoadNib;

- showLog:sender;
- clear:sender;
- run:sender;

@end

#endif /* !_NXFactor_h_ */

/* NXFactor.h ends here. */
