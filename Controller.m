/* -*- ObjC -*-
 * Controller.m --- App controller implementation.
 *
 * Copyright (c) 2023 Paul Ward <asmodai@gmail.com>
 * Copyright (c) 2001-2002 by Philippe C.D. Robert
 * Copyright (c) 1992-1993 George Fankhauser
 *
 * Author:     Paul Ward <asmodai@gmail.com>
 * Maintainer: Paul Ward <asmodai@gmail.com>
 * Created:    Thu, 26 Jan 2023 05:39:28 +0000 (GMT)
 */

/* {{{ License: */
/*
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
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

#import "Controller.h"

#import <appkit/appkit.h>

@implementation Controller

static id _singleton_instance = nil;

#define DESTROY(__t)  \
  if ((__t) != nil) { \
    [__t free];       \
    __t = nil;        \
  }

+ new
{
  if (!_singleton_instance) {
    if ((_singleton_instance = [super new]) == nil) {
      return nil;
    }

    return [_singleton_instance init];
  }

  return _singleton_instance;
}

- init
{
  if (self == nil) {
    return nil;
  }

  _views       = [[List alloc] init];
  _supervisors = [[List alloc] init];

  _lstViews = [popList target];
  [_lstViews setTarget:self];
  [_lstViews setAction:@selector(toggleInspectorPanels:)];
  [_lstViews removeItemAt:0];

  [pnlInspector setMiniwindowIcon:"NSBench.tiff"];
  [pnlInspector center];

  return self;
}

- free
{
  DESTROY(_views);
  DESTROY(_supervisors);

  return [super free];
}

- inspectorPanel
{
  return pnlInspector;
}

- setTitle:(const char *)title
{
  [pnlInspector setTitle:title];

  return self;
}

-      addView:(id)aView
      withName:(char *)name
withSupervisor:(id)aSupervisor
{
  [_views addObject:aView];
  [_supervisors addObject:aSupervisor];

  [_lstViews addItem:name];

  [boxContent setContentView:aView];
  [boxContent display];

  [popList setTitle:name];

  return self;
}

- remove:(char *)name
{
  int i = [popList indexOfItem:name];

  [_lstViews removeItemAt:i];
  [_views removeObjectAt:i];

  return self;
}

- show:(char *)name
{
  int i = [popList indexOfItem:name];

  [_lstViews setTitle:name];
  [boxContent setContentView:[_views objectAt:i]];
  [boxContent display];

  return self;
}

- updateDisplay
{
  [boxContent display];

  return self;
}

- windowDidUpdate:sender
{
  [_supervisors makeObjectsPerform:@selector(windowDidUpdate:)
                              with:sender];

  return self;
}

- clearView:sender
{
  return self;
}

- runView:sender
{
  return self;
}

- toggleInspectorPanels:sender
{
  int i = [sender selectedRow];
  
  [boxContent setContentView:[_views objectAt:i]];
  [boxContent display];

  return self;
}

@end /* Controller */

/* Controller.m ends here. */
