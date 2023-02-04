/* -*- ObjC -*-
 * Runner.m --- Some title
 *
 * Copyright (c) 2023 Paul Ward <asmodai@gmail.com>
 *
 * Author:     Paul Ward <asmodai@gmail.com>
 * Maintainer: Paul Ward <asmodai@gmail.com>
 * Created:    Fri,  3 Feb 2023 23:41:21 +0000 (GMT)
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

#import "Runner.h"
#import "../Malloc.h"
#import "../Utils.h"

#import <appkit/appkit.h>

static const char   *status_ready   = "Ready.  Press `run' to start.";
static const char   *status_running = "Benchmark is running.  Please wait.";
static const double  baseline_score = 5.478599;

@implementation Runner

- (id)init
{
  if ((self = [super init]) == nil) {
    return nil;
  }

  return self;
}

- (id)free
{
  return [super free];
}

- (id)score:(double)val
{
  char *buf = NULL;

  asprintf(&buf, "%0.2f", val);
  [txtScore setStringValue:buf];
  xfree(buf);
}

- (id)status:(const char *)msg
{
  [txtStatus setStringValue:msg];
  [txtStatus display];
  NXPing();
}

- (id)log:(const char *)fmt, ...
{
  char    *buf = NULL;
  size_t   len = 0;
  va_list  ap;

  va_start(ap, fmt);
  vasprintf(&buf, fmt, ap);
  va_end(ap);

  len = [txtOutput textLength];
  [txtOutput setSel:len:len];
  [txtOutput replaceSel:buf];
  [txtOutput display];
  NXPing();

  xfree(buf);
}

- runBenchmark:sender
{
  size_t    iters   = 10;
  results_t results = { 0 };
  
  extern void do_coremark(results_t *, size_t);

  [self status:status_running];
  [self log:"Test starting\n"];

  do_coremark(&results, iters);
  while (results.total_secs < 1.0) {
    iters *= iters;
    do_coremark(&results, iters);
  }

  [self log:"Time for %d iterations: %fs\n"
            "Running benchmark for approx. 20 seconds.\n",
            iters,
            results.total_secs];
  iters *= (int)20.0 / results.total_secs;
  do_coremark(&results, iters);

  [self log:"Time for %d iterations: %fs\n"
            "Test complete, score is %f and the baseline is %f\n"
            "-----------------------------------------------------------\n\n",
            iters,
            results.total_secs,
            results.score,
            baseline_score];

  [self score:results.score];
  [self status:status_ready];

  return self;
}

- clearResults:sender
{
  size_t len = [txtOutput textLength];

  [txtOutput setSel:0:len];
  [txtOutput replaceSel:""];
  [txtOutput display];

  return self;
}


@end /* Runner */

/* Runner.m ends here. */
