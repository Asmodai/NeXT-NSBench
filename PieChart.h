/* -*- ObjC -*-
 * PieChart.h --- Pie chart view interface.
 *
 * Copyright (c) 2023 Paul Ward <asmodai@gmail.com>
 *
 * Author:     Paul Ward <asmodai@gmail.com>
 * Maintainer: Paul Ward <asmodai@gmail.com>
 * Created:    Fri, 27 Jan 2023 17:39:47 +0000 (GMT)
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

#ifndef _PieChart_h_
#define _PieChart_h_

#import <appkit/View.h>

#define MAX_WEDGES                  10
#define MAX_CHARS_PER_WEDGE_LABEL   100

@interface PieChart : View
{
  id fontId;

  float pieSize;
  int   numWedges;
  float wedgeValue[MAX_WEDGES];
  float grays[MAX_WEDGES];
  float normData[MAX_WEDGES];
  char  labels[MAX_WEDGES][MAX_CHARS_PER_WEDGE_LABEL];
}

- initFrame:(const NXRect *)frame;

- setPieSize:(float)size;

- addPieWedge:(float)value
        label:(const char *)label
        shade:(float)gray;
- removeWedgeAt:(int)index;
- setWedgeAt:(int)index
       value:(float)value
       label:(const char *)label
       shade:(float)gray;

- normalize;

@end

#endif /* !_PieChart_h_ */

/* PieChart.h ends here. */
