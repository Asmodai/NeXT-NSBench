/*
 * Object+Debug.m --- Debugging category implementation.
 *
 * Copyright (c) 2015-2023 Paul Ward <asmodai@gmail.com>
 *
 * Author:     Paul Ward <asmodai@gmail.com>
 * Maintainer: Paul Ward <asmodai@gmail.com>
 * Created:    Sat,  7 Nov 2015 07:20:18 +0000 (GMT)
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

#import "Object+Debug.h"
#import "Utils.h"

#import <stdio.h>

/* Default indentation level. */
#define INDENT_LEVEL    2

@implementation Object (Debug)

+ (int)debugIndentLevel
{
  return INDENT_LEVEL;
}

- (void)_printDebugInfo:(int)indent
{
  [self notImplemented:_cmd];
}

- (void)printDebug:(const char *)label
{
  [self printDebug:label
        withIndent:0];
}

- (void)printDebug:(const char *)label
        withIndent:(int)indent
{
  debug_print(indent,
              "%s <%s:%#x>\n",
              label,
              [[self class] name],
              (unsigned int)self);

  if ([self respondsTo:@selector(_printDebugInfo:)]) {
    [self _printDebugInfo:(indent + INDENT_LEVEL)];
  }
}

@end                            // Object (Debug)

/* Object+Debug.m ends here */
/*
 * Local Variables: ***
 * indent-tabs-mode: nil ***
 * End: ***
 */
