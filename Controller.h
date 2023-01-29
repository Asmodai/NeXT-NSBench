/* -*- ObjC -*-
 * Controller.h --- App controller interface.
 *
 * Copyright (c) 2023 Paul Ward <asmodai@gmail.com>
 * Copyright (c) 2001-2002 Philippe C.D. Robert
 * Copyright (c) 1992-1993 George Fankhauser
 *
 * Author:     Paul Ward <asmodai@gmail.com>
 * Maintainer: Paul Ward <asmodai@gmail.com>
 * Created:    Thu, 26 Jan 2023 05:29:42 +0000 (GMT)
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

#ifndef _Controller_h_
#define _Controller_h_

#import <objc/Object.h>
#import <objc/List.h>

@interface Controller : Object
{
  id pnlInspector;
  id popList;
  id btnRun;
  id btnClear;
  id boxContent;

  id    _lstViews;
  List *_views;
  List *_supervisors;
}

+ new;

- init;
- free;

- inspectorPanel;

- setTitle:(const char *)title;

- addView:aView withName:(char *)name withSupervisor:(id)aSupervisor;
- remove:(char *)name;
- show:(char *)name;

- updateDisplay;
- windowDidUpdate:sender;

- clearView:sender;
- runView:sender;

- toggleInspectorPanels:sender;

@end

#endif /* !_Controller_h_ */

/* Controller.h ends here. */
