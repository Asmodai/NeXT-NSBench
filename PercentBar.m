/* -*- ObjC -*-
 * PercentBar.m --- Percent bar view implementation.
 *
 * Copyright (c) 2023 Paul Ward <asmodai@gmail.com>
 *
 * Author:     Paul Ward <asmodai@gmail.com>
 * Maintainer: Paul Ward <asmodai@gmail.com>
 * Created:    Fri, 27 Jan 2023 14:07:58 +0000 (GMT)
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

#import "PercentBar.h"

#import <appkit/Control.h>
#import <dpsclient/wraps.h>

#define LEFT_MARGIN    10.0
#define RIGHT_MARGIN   10.0

@implementation PercentBar

- initFrame:(const NXRect *)tf
{
  if ((self = [super initFrame:tf]) == nil) {
    return nil;
  }

  value = 0.0;
  
  return self;
}

- setValue:(float)aValue
{
  value = aValue;
  [self display];

  return self;
}

- drawSelf:(const NXRect *)rect :(int)count
{
  char  str[10] = { 0 };
  int   i       = 0;
  float width   = 0;
  float vert    = 0;
  float scale   = 0;

  width = bounds.size.width - RIGHT_MARGIN - LEFT_MARGIN;
  vert  = (bounds.size.height / 2.0) + 4.0;
  scale = (bounds.size.width - RIGHT_MARGIN - LEFT_MARGIN) / 100.0;

  [self lockFocus];
  {
    PSsetgray(NX_LTGRAY);
    NXRectFill(rect);

    PSsetgray(NX_BLACK);
    PSsetlinewidth(1.0);
    PSnewpath();
    {
      PSmoveto(LEFT_MARGIN, vert);
      PSlineto(width,       vert);
    }
    PSstroke();

    PSsetgray(NX_DKGRAY);
    PSsetlinewidth(8.0);
    PSnewpath();
    {
      PSmoveto(LEFT_MARGIN + (0.0) * scale, vert);
      PSlineto(LEFT_MARGIN + value * scale, vert);
    }
    PSstroke();

    PSsetgray(NX_BLACK);
    PSselectfont("Helvetica", 8.0);
    for (i = 0; i < 10; ++i) {
      sprintf(str, "%d", i * 10);
      PSmoveto(10.0 * scale * i + LEFT_MARGIN, 2.0);
      PSshow(str);
    }
  }
  [self unlockFocus];
  
  return self;
}

@end /* PercentBar */

/* PercentBar.m ends here. */
