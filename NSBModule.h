/* -*- ObjC -*-
 * NSBModule.h --- NSBench module object interface.
 *
 * Copyright (c) 2023 Paul Ward <asmodai@gmail.com>
 *
 * Author:     Paul Ward <asmodai@gmail.com>
 * Maintainer: Paul Ward <asmodai@gmail.com>
 * Created:    Thu, 26 Jan 2023 09:30:55 +0000 (GMT)
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

#ifndef _NSBModule_h_
#define _NSBModule_h_

#import <objc/Object.h>
#import <appkit/appkit.h>

@interface NSBModule : Object
{
  id viewInfo;                  // Info panel view.
  id viewBenchmark;             // Benchmark panel view.
  id viewButtonBar;             // Button bar view.

  // XXX make these into a struct or something.
  id mach;                      // Object for Mach calls.
  id platform;                  // Object for Platform info.
  id netInfo;                   // Object for NetInfo calls.
  id disk;                      // Object for Disk info.
}

- loadNib;
- didLoadNib;

- (BOOL)loadFirst;

- (id)infoView;
- (id)benchmarkView;
- (id)buttonBarView;

- (void)setMachProxy:(id)anObject;
- (void)setPlatformProxy:(id)anObject;
- (void)setNetInfoProxy:(id)anObject;

@end

#endif /* !_NSBModule_h_ */

/* NSBModule.h ends here. */
