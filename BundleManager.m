/* -*- ObjC -*-
 * BundleManager.m --- Bundle manager implemenmtation.
 *
 * Copyright (c) 2023 Paul Ward <asmodai@gmail.com>
 *
 * Author:     Paul Ward <asmodai@gmail.com>
 * Maintainer: Paul Ward <asmodai@gmail.com>
 * Created:    Thu, 26 Jan 2023 10:20:24 +0000 (GMT)
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

#import "Malloc.h"
#import "BundleManager.h"
#import "NSBModule.h"

#import <appkit/appkit.h>
#import <string.h>

@implementation BundleManager

- initForDirectory:(const char *)path
{
  if ((self = [super initForDirectory:path]) == nil) {
    return nil;
  }

  moduleName        = NULL;
  moduleDescription = NULL;
  moduleImage       = NULL;
  module            = nil;

  return self;
}

- free
{
  DESTROY(module);

  moduleName        = NULL;
  moduleDescription = NULL;

  MAYBE_FREE((char *)moduleImage);

  return [super free];
}

- (const char *)moduleName
{
  if (!moduleName) {
    moduleName =
      NXLocalizedStringFromTableInBundle("NSBModule.strings",
                                         self,
                                         "Name",
                                         "Unknown module",
                                         "Name of module");
  }

  return moduleName;
}

- (const char *)moduleDescription
{
  if (!moduleDescription) {
    moduleDescription =
      NXLocalizedStringFromTableInBundle("NSBModule.strings",
                                         self,
                                         "Description",
                                         "Unknown module",
                                         "Description of module");
  }

  return moduleDescription;
}

- (NSBModule *)module
{
  Class moduleClass;

  if (!module) {
    moduleClass = [self principalClass];
    module      = [[moduleClass allocFromZone:[self zone]] init];

    if (![module isKindOf:[NSBModule class]]) {
      printf("SHit, %s != %s\n", [[module class] name], [[NSBModule class] name]);
      DESTROY(module);
    }
  }

  return module;
}

- (const char *)moduleImage
{
  BOOL ok = NO;

  if (moduleImage == NULL) {
    moduleImage = xmalloc(sizeof(char) * (MAXPATHLEN + 1));

    ok = [self getPath:(char *)moduleImage
           forResource:"NSBModule"
                ofType:"tiff"];

    if (!ok) {
      moduleImage = NULL;
    }
  }

  return moduleImage;
}

- (BOOL)loadFirst
{
  return [[self module] loadFirst];
}

- (id)infoView
{
  return [[self module] infoView];
}

- (id)benchmarkView
{
  return [[self module] benchmarkView];
}

- (id)buttonBarView
{
  return [[self module] buttonBarView];
}

- (void)setMachProxy:(id)anObject
{
  [[self module] setMachProxy:anObject];
}

- (void)setNetInfoProxy:(id)anObject
{
  [[self module] setNetInfoProxy:anObject];
}

@end /* BundleManager */

/* BundleManager.m ends here. */
