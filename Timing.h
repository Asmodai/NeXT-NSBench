/* -*- ObjC -*-
 * Timing.h --- Some title
 *
 * Copyright (c) 2023 Paul Ward <asmodai@gmail.com>
 *
 * Time-stamp: <23/02/01 22:39:45 asmodai>
 *
 * Author:     Paul Ward <asmodai@gmail.com>
 * Maintainer: Paul Ward <asmodai@gmail.com>
 * Created:    Wed,  1 Feb 2023 22:05:56 +0000 (GMT)
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
 * This class implements a simple interval timer to aid in measuring
 * drawing performance.  It'll measure either wall or CPU time spent
 * within an interval delineated by a pair of messages to the Timing
 * object.  It's most useful in situations where you need to measure not
 * only the time spent within the process, but also the time spent in
 * other processes, most notably the Window Server.  CPU time includes
 * process time, system time on behalf of the process, and Window Server
 * time on behalf of the process.  The results are most accurate if
 * averaged over a number of passes through the interval, and the Timing
 * object will keep track of:
 *
 *    * number of times entered,
 *    * cumulative elapsed time,
 *    * and average elapsed time.
 *
 * Use the `+newWithTag:' method to create a Timing object.
 *
 * Use the `-reset' message to reset the Timing object before entering
 * the timing interval for the first time.
 *
 * A timing interval is delineated by an `-enter:' message and a
 * `-leave' message.  `enter:' takes a single argument that specifies
 * either `WALLTIME' or `PSTIME'.
 *
 * Here's an example of its use.  
 *
 *   - action4:sender
 *   {
 *       int i=100;
 *       id t4 = [Timing newWithTag:4];
 *
 *       [t4 reset];
 *       [self lockFocus];
 *       while(i--){
 *           [t4 enter:PSTIME];
 *           [self drawCachedLines];
 *           [[self window] flushWindow];
 *           [t4 leave];
 *       }
 *       [self unlockFocus];
 *       [t4 summary:stream];
 *       [self addSummary];
 *       return self;
 *   }
 */
/* }}} */

#ifndef _Timing_h_
#define _Timing_h_

#import <objc/Object.h>
#import <sys/time.h>
#import <sys/resource.h>

#define PSTIME 0
#define WALLTIME 1

@interface Timing : Object
{
  struct timezone tzone;
  struct timeval  realtime;
  struct rusage   rtime;
  double          synctime;
  int             s_time;
  double          cWallTime;
  double          cAppTime;
  double          cPSTime;
  double          aWallTime;
  double          aAppTime;
  double          aPSTime;
  double          tare;
  size_t          cTimesEntered;
  int             tag;
  int             wallTime;
}

- (id)initWithTag:(int)aTag;

- (id)summary:(char **)buf;

- (id)enter:(int)wt;
- (id)leave;
- (id)reset;

- (id)wallEnter;
- (id)wallLeave;

- (id)psEnter;
- (id)psLeave;

- (id)avgElapsedTime;

- (double)cumWallTime;
- (double)cumAppTime;
- (double)cumPSTime;

- (id)tare;


@end

#endif /* !_Timing_h_ */

/* Timing.h ends here. */
