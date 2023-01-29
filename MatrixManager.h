/* -*- ObjC -*-
 * MatrixManager.h --- Button matrix manager implementation.
 *
 * Copyright (c) 2023 Paul Ward <asmodai@gmail.com>
 *
 * Author:     Paul Ward <asmodai@gmail.com>
 * Maintainer: Paul Ward <asmodai@gmail.com>
 * Created:    Thu, 26 Jan 2023 12:31:28 +0000 (GMT)
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

#ifndef _MatrixManager_h_
#define _MatrixManager_h_

#import <objc/Object.h>
#import <appkit/NXImage.h>
#import <appkit/Matrix.h>

#import <sys/types.h>

typedef signed long ssize_t;

@interface MatrixManager : Object
{
  Matrix* matrix;
  id      view;

  size_t  count;
  ssize_t selected;
}

- init;
- free;

- setMatrix:(id)aMatrix;
- setView:(id)aView;

- reset;
- addButton:(const char *)img
     module:(id)module
     action:(SEL)action
     target:(id)aTarget;

- selectFirst;

@end

#endif /* !_MatrixManager_h_ */

/* MatrixManager.h ends here. */
