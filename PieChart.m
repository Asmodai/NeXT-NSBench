/* -*- ObjC -*-
 * PieChart.m --- Pie chart view implementation.
 *
 * Copyright (c) 2023 Paul Ward <asmodai@gmail.com>
 *
 * Author:     Paul Ward <asmodai@gmail.com>
 * Maintainer: Paul Ward <asmodai@gmail.com>
 * Created:    Fri, 27 Jan 2023 17:43:46 +0000 (GMT)
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

#include "PieChart.h"

#import <strings.h>
#import <appkit/Font.h>
#import "slice.h"
#import <appkit/Control.h>
#import <appkit/Application.h>
#import <appkit/Pasteboard.h>
#import <appkit/Matrix.h>
#import <dpsclient/wraps.h>

@implementation PieChart : View

- initFrame:(const NXRect *)fr
{
  size_t i = 0;

  if ((self = [super initFrame:fr]) == nil) {
    return nil;
  }

  fontId = [Font newFont:"Helvetica"
                    size:12
                   style:0
                  matrix:NX_IDENTITYMATRIX];

  pieSize   = 20.0;
  numWedges = 0;
  
  for (i = 0; i < MAX_WEDGES; ++i) {
    //grays[i] = ((float)i) / 10.0;
    grays[i] = 0.9;
  }

  [self normalize];

  return self;
}

- setPieSize:(float)size
{
  pieSize = size;
  [self display];

  return self;
}

- addPieWedge:(float)value
        label:(const char *)label
        shade:(float)gray
{
  wedgeValue[numWedges] = value;
  strcpy(labels[numWedges], label);
  grays[numWedges] = gray;

  numWedges++;

  return [self normalize];
}

- removeWedgeAt:(int)index
{
  size_t i = 0;

  for (i = index; i <= numWedges - 1; ++i) {
    wedgeValue[i - 1] = wedgeValue[i];
    grays[i - 1]      = grays[i];

    strcpy(labels[i - 1], labels[i]);
  }

  wedgeValue[i] = 0.0;
  numWedges--;

  return [self normalize];
}

- setWedgeAt:(int)index
       value:(float)value
       label:(const char *)label
       shade:(float)gray
{
  wedgeValue[index] = value;

  if (label != NULL) {
    strcpy(labels[index], label);
  }

  if (gray >= 0.0) {
    grays[index] = gray;
  }
  
  [self display];

  return [self normalize];
}

- normalize
{
  size_t i     = 0;
  float  total = 0.0;

  for (i = 0; i < numWedges; ++i) {
    total += wedgeValue[i];
  }

  for (i = 0; i < numWedges; ++i) {
    normData[i] = wedgeValue[i] * 360.0 / total;
  }

  [self display];

  return self;
}

- drawSelf:(const NXRect *)rect :(int)count
{
  int   i     = 0;
  int   cX    = 0;
  int   cY    = 0;
  float r     = 0;
  float total = 0.0;

  cX = bounds.size.width / 2.0 + bounds.origin.x;
  cY = bounds.size.height / 2.0 + bounds.origin.y;
  r  = (bounds.size.height / 2.0) - 24;
  [self translate:cX :cY];

  [fontId set];
  [self lockFocus];
  {
    PSsetgray(NX_LTGRAY);
    NXRectFill(&bounds);

    PSsetgray(NX_BLACK);
    for (i = 0; i < numWedges; i++) {
      drawSlice(grays[i], r, total, total + normData[i], 12.0, labels[i]);
      total = total + normData[i];
    }
  }
  [self unlockFocus];

  return self;
}

@end /* PieChart */

/* PieChart.m ends here. */
