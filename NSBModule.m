/* -*- ObjC -*-
 * NSBModule.m --- NSBundle module object implementation.
 *
 * Copyright (c) 2023 Paul Ward <asmodai@gmail.com>
 *
 * Author:     Paul Ward <asmodai@gmail.com>
 * Maintainer: Paul Ward <asmodai@gmail.com>
 * Created:    Thu, 26 Jan 2023 10:33:00 +0000 (GMT)
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

#import "NSBModule.h"
#import <appkit/appkit.h>

@implementation NSBModule

- loadNib
{
  NXBundle *bndl = NULL;
  char      nibPath[MAXPATHLEN + 1];

  bndl = [NXBundle bundleForClass:[self class]];

  [bndl getPath:nibPath
    forResource:[[self class] name]
         ofType:"nib"];

  if ([NXApp loadNibFile:nibPath
                   owner:self
               withNames:NO
                fromZone:[self zone]] != nil)
  {
    [self didLoadNib];

    return self;
  }

  return nil;
}

- didLoadNib
{
  return self;
}

- (BOOL)loadFirst
{
  return NO;
}

- (id)infoView
{
  return viewInfo;
}

- (id)benchmarkView
{
  return viewBenchmark;
}

- (id)buttonBarView
{
  return viewButtonBar;
}

- (void)setMachProxy:(id)anObject
{
  mach = anObject;
}

- (void)setNetInfoProxy:(id)anObject
{
  netInfo = anObject;
}

@end /* NSBModule */

/* NSBModule.m ends here. */
