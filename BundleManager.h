/* -*- ObjC -*-
 * BundleManager.h --- Bundle manager interface.
 *
 * Copyright (c) 2023 Paul Ward <asmodai@gmail.com>
 *
 * Author:     Paul Ward <asmodai@gmail.com>
 * Maintainer: Paul Ward <asmodai@gmail.com>
 * Created:    Thu, 26 Jan 2023 10:16:46 +0000 (GMT)
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

#ifndef _BundleManager_h_
#define _BundleManager_h_

#import <objc/NXBundle.h>

@class NSBModule;

@interface BundleManager : NXBundle
{
  const char *moduleName;
  const char *moduleDescription;
  const char *moduleImage;
  NSBModule  *module;
  BOOL        loadFirst;
}

- initForDirectory:(const char *)path;
- free;

- (const char *)moduleName;
- (const char *)moduleDescription;
- (const char *)moduleImage;
- (NSBModule *)module;

- (BOOL)loadFirst;

- (id)infoView;
- (id)benchmarkView;
- (id)buttonBarView;

- (void)setMachProxy:(id)anObject;
- (void)setNetInfoProxy:(id)anObject;
- (void)setPlatformProxy:(id)anObject;

@end

#endif /* !_BundleManager_h_ */

/* BundleManager.h ends here. */
