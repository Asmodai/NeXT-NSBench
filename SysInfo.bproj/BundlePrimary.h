/* -*- ObjC -*-
 * SysInfo.h  --- Some title
 *
 * Copyright (c) 2023 Paul Ward <asmodai@gmail.com>
 *
 * Time-stamp: <23/01/29 17:58:10 asmodai>
 * Revision:   28
 *
 * Author:     Paul Ward <asmodai@gmail.com>
 * Maintainer: Paul Ward <asmodai@gmail.com>
 * Created:    Thu, 26 Jan 2023 20:08:53 +0000 (GMT)
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

#ifndef _SysInfo_h_
#define _SysInfo_h_

#import "../NSBModule.h"
#import "../Disk.h"

@interface SysInfo : NSBModule
{
  id hostOS;
  id hostCPU;
  id hostRAM;

  id diskUsageBar;

  id memPieChart;
  id memBrowser;

  id hostBrowser;
  id hostText;
}

- didLoadNib;

- (BOOL)loadFirst;

- (void)poll;
- (void)getOS;
- (void)getCPU;
- (void)setRAM;

- (id)action:(id)sender;
- (int)browser:sender
    fillMatrix:matrix
      inColumn:(int)column;
- (int)getIndex:sender
     fillMatrix:matrix;
- (int)getMemory:sender
      fillMatrix:matrix;

- (void)getDiskData:(BOOL)onlyBar;
- (void)getHostData;
- (void)getNetData;
- (void)getScreenData;

- refreshInfo:sender;

@end

#endif /* !_SysInfo_h_ */

/* SysInfo.h ends here. */


