/* -*- ObjC -*-
 * MatrixManager.m --- Button matrix manager implementation.
 *
 * Copyright (c) 2023 Paul Ward <asmodai@gmail.com>
 *
 * Author:     Paul Ward <asmodai@gmail.com>
 * Maintainer: Paul Ward <asmodai@gmail.com>
 * Created:    Thu, 26 Jan 2023 12:33:48 +0000 (GMT)
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

#import "MatrixManager.h"
#import "UserButtonCell.h"
#import "BundleManager.h"


@implementation MatrixManager

- init
{
  if ((self = [super init]) == nil) {
    return nil;
  }

  matrix   = nil;
  count    = 0;
  selected = -1;

  return self;
}

- free
{
  matrix = nil;

  return [super free];
}

- setMatrix:(id)aMatrix
{
  ButtonCell *proto = nil;

  matrix = aMatrix;
  [self reset];

  proto = [[UserButtonCell alloc] init];
  [proto setIconPosition:NX_ICONONLY];
  [proto setType:NX_MOMENTARYPUSH];


  [matrix setPrototype:proto];
  
  
  return self;
}

- setView:(id)aView
{
  view = aView;

  return self;
}

- reset
{
  size_t rows = 0;
  size_t cols = 0;
  size_t i    = 0;

  count    = 0;
  selected = -1;

  if (matrix) {
    [matrix getNumRows:(int *)&rows numCols:(int *)&cols];
  }

  for (i = 0; i < cols ; ++i) {
    [matrix removeColAt:i andFree:YES];
  }
  [matrix sizeToCells];

  return self;
}

- addButton:(const char *)path
     module:(id)module
     action:(SEL)action
     target:(id)aTarget
{
  NXImage        *img = nil;
  UserButtonCell *btn = nil;

  img = [[NXImage alloc] init];
  [img loadFromFile:path];

  [matrix addCol];
  [matrix sizeToCells];

  btn = [matrix cellAt:0 :count];
  [btn setImage:img];
  [btn setIconPosition:NX_ICONONLY];
  [btn setType:NX_PUSHONPUSHOFF];
  [btn setAction:action];
  [btn setTarget:aTarget];
  [btn setUser:module];
  count++;
  [matrix display];

  if ([module loadFirst]) {
    [btn performClick:self];
    [btn setParameter:NX_CELLSTATE to:1];
  }

  return self;
}

- selectFirst
{
  UserButtonCell *b = nil;

  b = [matrix cellAt:0 :0];
  if (b) {
    [b performClick:self];
    [b setParameter:NX_CELLSTATE to:1];
  }

  return self;
}

@end /* MatrixManager */

/* MatrixManager.m ends here. */
