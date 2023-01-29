/* -*- ObjC -*-
 * NXFactor.m  --- Some title
 *
 * Copyright (c) 2023 Paul Ward <asmodai@gmail.com>
 * Copyright (c) 2001-2002 by Philippe C.D. Robert
 *
 * Author:     Paul Ward <asmodai@gmail.com>
 * Maintainer: Paul Ward <asmodai@gmail.com>
 * Created:    Fri, 27 Jan 2023 04:22:02 +0000 (GMT)
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
#import "NXBenchView.h"

@implementation NXFactor

- didLoadNib
{
  return self;
}

- clear:sender
{
  [vvwFactor clear];
}

- run:sender
{
  NXRunAlertPanel("`NXFactor' Benchmark",
                  "To get reliable results with this benchmark, "
                  "please quit all other applications and ensure "
                  "that NSBench is on top -- Command double-click "
                  "NSBench's miniwindow.",
                  "OK",
                  NULL,
                  NULL);

  [vvwFactor runBenchmark];
  
  [fldFactor setFloatValue:[vvwFactor meanResult]];

  return self;
}

@end /* NXFactor */

/* NXFactor.m ends here. */
