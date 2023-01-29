/* -*- ObjC -*-
 * NXBenchView.h --- Some title
 *
 * Copyright (c) 2023 Paul Ward <asmodai@gmail.com>
 * Copyright (c) 2001-2002 by Philippe C.D. Robert
 *
 * Time-stamp: <23/01/29 18:29:50 asmodai>
 *
 * Author:     Paul Ward <asmodai@gmail.com>
 * Maintainer: Paul Ward <asmodai@gmail.com>
 * Created:    Sun, 29 Jan 2023 14:41:12 +0000 (GMT)
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

#ifndef _NXBenchView_h_
#define _NXBenchView_h_

#import <appkit/appkit.h>

@interface NXBenchView : View
{
  float meanResult;

  float resLine;
  float resCurve;
  float resFill;
  float resTrans;
  float resText;
  float resComposite;
  float resWindowTest;

  id resMatrix;
}

- (id)initFrame:(const NXRect *)frame;

- (void)runBenchmark;
- (float)meanResult;
- (int)currentTimeInMs;

- (void)line;
- (void)curve;
- (void)fill;
- (void)trans;
- (void)text;
- (void)composite;
- (void)windowTest;

@end

#endif /* !_NXBenchView_h_ */

/* NXBenchView.h ends here. */
