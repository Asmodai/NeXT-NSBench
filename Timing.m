/* -*- ObjC -*-
 * Timing.m --- Some title
 *
 * Copyright (c) 2023 Paul Ward <asmodai@gmail.com>
 *
 * Time-stamp: <23/02/02 08:12:48 asmodai>
 *
 * Author:     Paul Ward <asmodai@gmail.com>
 * Maintainer: Paul Ward <asmodai@gmail.com>
 * Created:    Wed,  1 Feb 2023 22:12:43 +0000 (GMT)
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

#import "Timing.h"
#import "Malloc.h"
#import "Utils.h"

#import <stdio.h>
#import <streams/streams.h>
#import <dpsclient/wraps.h>
#import <appkit/graphics.h>

@implementation Timing

- (id)initWithTag:(int)aTag
{
  if ((self = [super init]) == nil) {
    return nil;
  }

  tag = aTag;
  [self reset];

  return self;
}

- (id)enter:(int)wt
{
  if (wallTime = (wt == WALLTIME)) {
    return [self wallEnter];
  }

  return [self psEnter];
}

- (id)leave
{
  if (wallTime) {
    return [self wallLeave];
  }

  return [self psLeave];
}

- (id)reset
{
  cAppTime      = 0.0;
  cPSTime       = 0.0;
  cWallTime     = 0.0;
  cTimesEntered = 0;
  
  return self;
}

- (id)wallEnter
{
  cTimesEntered++;
  NXPing();
  gettimeofday(&realtime, &tzone);
  synctime = realtime.tv_sec + realtime.tv_usec / 1000000.0;

  return self;
}

- (id)wallLeave
{
  double etime = 0.0;

  NXPing();
  gettimeofday(&realtime, &tzone);
  etime = (- synctime + realtime.tv_sec + realtime.tv_usec / 1000000.0) - tare;
  cWallTime += etime;

  return self;
}

- (id)psEnter
{
  cTimesEntered++;
  PSusertime(&s_time);
  getrusage(RUSAGE_SELF, &rtime);
  synctime = ((rtime.ru_utime.tv_sec + rtime.ru_stime.tv_sec) +
              (rtime.ru_utime.tv_usec + rtime.ru_stime.tv_usec) / 1000000.0);

  return self;
}

- (id)psLeave
{
  int    et    = 0;
  double atime = 0.0;
  double ptime = 0.0;

  getrusage(RUSAGE_SELF, &rtime);

  PSusertime(&et);
  ptime = ((et - s_time) / 1000.0);
  cPSTime += ptime;

  atime = ((rtime.ru_utime.tv_sec + rtime.ru_stime.tv_sec) +
           (rtime.ru_utime.tv_usec + 
            rtime.ru_stime.tv_usec)/1000000.0) - synctime;
  cAppTime += atime;

  return self;
}

- (id)avgElapsedTime
{
  if(wallTime) {
    aWallTime = (cWallTime / (double)cTimesEntered);
    return self;
  }

  aAppTime = (cAppTime / (double)cTimesEntered) ;
  aPSTime  = (cPSTime / (double)cTimesEntered);

  return self;
}

- (double)cumWallTime
{
  if(wallTime == WALLTIME) {
    return cWallTime;
  }

  return -1.0;
}

- (double)cumAppTime
{
  if(wallTime == PSTIME) {
    return cAppTime;
  }
  
  return -1.0;
}

- (double)cumPSTime
{
  if(wallTime == PSTIME) {
    return cPSTime;
  }

  return -1.0;
}

- (id)tare
{
  struct timezone tzone1;
  struct timeval  realtime1;
  struct timeval  realtime2;

  NXPing();
  gettimeofday(&realtime1,&tzone1);

  NXPing();
  gettimeofday(&realtime2,&tzone1);

  tare = ((-realtime1.tv_sec + realtime2.tv_sec) + 
          (-realtime1.tv_usec + realtime2.tv_usec) / 1000000.0);
  
  return self;
}

- (id)summary:(char **)buf
{
  if (wallTime) {
    asprintf(buf,
             "Timer %d: Trials: %d  TotalWall: %lf",
             tag,
             cTimesEntered,
             cWallTime);

    return self;
  }

  asprintf(buf,
           "Timer %d: Trials: %d  App: %0.4lfs  Server: %0.4lfs  "
           "ServerPct: %0.2lf  Total: %0.4lfs",
           tag,
           cTimesEntered,
           cAppTime,
           cPSTime,
           (cPSTime / (cAppTime + cPSTime)) * 100,
           cAppTime + cPSTime);

  return self;
}

@end /* Timing */

/* Timing.m ends here. */
