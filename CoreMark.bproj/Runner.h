/* -*- ObjC -*-
 * Runner.h --- Some title
 *
 * Copyright (c) 2023 Paul Ward <asmodai@gmail.com>
 *
 * Author:     Paul Ward <asmodai@gmail.com>
 * Maintainer: Paul Ward <asmodai@gmail.com>
 * Created:    Fri,  3 Feb 2023 23:38:31 +0000 (GMT)
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

#ifndef _Runner_h_
#define _Runner_h_

#import "core_portme.h"
#import "result.h"

#import <sys/types.h>

#import <objc/Object.h>

@interface Runner : Object
{
  id txtOutput;
  id txtScore;
  id txtStatus;

  id btnClear;
  id btnRun;
}

- (id)init;
- (id)free;

- (id)score:(double)val;
- (id)status:(const char *)msg;
- (id)log:(const char *)fmt, ...;

- runBenchmark:sender;
- clearResults:sender;

@end /* Runner */

#endif /* !_Runner_h_ */

/* Runner.h ends here. */
