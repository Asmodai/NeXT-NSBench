/* -*- ObjC -*-
 * Manager.h --- Bundle loader/manager interface.
 *
 * Copyright (c) 2023 Paul Ward <asmodai@gmail.com>
 *
 * Author:     Paul Ward <asmodai@gmail.com>
 * Maintainer: Paul Ward <asmodai@gmail.com>
 * Created:    Thu, 26 Jan 2023 10:41:05 +0000 (GMT)
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

#ifndef _Manager_h_
#define _Manager_h_

#import <objc/Object.h>
#import "MatrixManager.h"

@class List;
@class NSBModule;

@interface Manager : Object
{
  id wndInfo;
  id wndBenchmark;

  id viewInfo;                  // Module info panel view.
  id viewBenchmark;             // Module benchmark view.
  id viewButtonBar;             // Module button bar view.

  id viewCurrentInfo;
  id viewCurrentBenchmark;

  id btnsInfo;
  id btnsBenchmark;

  List          *_lstBundles;
  MatrixManager *_mgrInfo;
  MatrixManager *_mgrBenchmark;
}

- appDidInit:sender;

- free;

- createBundlesAndLoadModules:(BOOL)doLoad;
- createBundlesForDirectory:(const char *)path
                loadModules:(BOOL)doLoad;
- (void)createBundleLists;

- (void)benchmarkButtonPressed:(id)sender;
- (void)infoButtonPressed:(id)sender;

- showInfo:sender;

@end

#endif /* !_Manager_h_ */

/* Manager.h ends here. */
