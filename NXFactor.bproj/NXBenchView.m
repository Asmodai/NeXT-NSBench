/* -*- ObjC -*-
 * NXBenchView.m --- Some title
 *
 * Copyright (c) 2023 Paul Ward <asmodai@gmail.com>
 *
 * Author:     Paul Ward <asmodai@gmail.com>
 * Maintainer: Paul Ward <asmodai@gmail.com>
 * Created:    Sun, 29 Jan 2023 14:50:42 +0000 (GMT)
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

#import "NXBenchView.h"
#import "../Malloc.h"
#import "../Utils.h"

#import <libc.h>
#import <stdlib.h>

#import <dpsclient/wraps.h>

#define COL_LINE        0
#define COL_CURVE       1
#define COL_FILL        2
#define COL_TRANS       3
#define COL_COMPOSITE   4
#define COL_PATH        5
#define COL_TEXT        6
#define COL_WINDOW      7

#define BASE_LINE       42.6094
#define BASE_CURVE      77.5494
#define BASE_FILL       107.1696
#define BASE_TRANS      75.9013
#define BASE_COMPOSITE  13.5212
#define BASE_PATH       26.4208
#define BASE_TEXT       68.0087
#define BASE_WINDOW     101.3171

typedef struct {
  char  *system;
  float  line;
  float  curve;
  float  fill;
  float  trans;
  float  composite;
  float  path;
  float  text;
  float  window;
  float  factor;
} results_t;

results_t baseline_results[] = {
  {
    "33MHz NeXTcube, 128MB RAM, mono",
    32.9359, 65.1763, 133.4223, 76.4584, 11.1941, 23.1906, 44.6249, 89.4294,
    2.007016
  }, {
    "33MHz NeXTcube, 128MB RAM, NeXTdimension, 64MB RAM, color",
    44.6269, 79.2581, 107.7586, 75.1541, 14.8810, 43.0756, 67.2495, 105.2853,
    2.611623
  },
};

@implementation NXBenchView

inline
NXPoint
NSMakePoint(float x, float y)
{
  NXPoint p;

  p.x = x;
  p.y = y;

  return p;
}

- (id)initFrame:(const NXRect *)rect
{
  if ((self = [super initFrame:rect]) == nil) {
    return nil;
  }

  meanResult = 0.0;

  return self;
}

- drawSelf:(const NXRect *)rect :(int)count
{
  [self clear];

  return self;
}

- (int)currentTimeInMs
{
    struct timeval curTime;
    
    gettimeofday (&curTime, NULL);
    return ((curTime.tv_sec) * 1000 + curTime.tv_usec / 1000);
}

- (void)clear
{
  [self lockFocus];
  {
    PSsetgray(NX_WHITE);
    NXRectFill(&bounds);
  }
  [self unlockFocus];
}

- (void)runBenchmark
{
  int start = 0;
  int end   = 0;

  // This is `1' in the original NXBench... ugh.
  srandom([self currentTimeInMs]);

  [self log:"---------------------------------------------------------\n"];
  [self log:"Starting tests.\n"];
  
  start = [self currentTimeInMs];

  [self line];
  sleep_for_time_interval(1.0);

  [self curve];
  sleep_for_time_interval(1.0);

  [self fill];
  sleep_for_time_interval(1.0);

  [self trans];
  sleep_for_time_interval(1.0);

  [self composite];
  sleep_for_time_interval(1.0);

  [self userPath];
  sleep_for_time_interval(1.0);

  [self text];
  sleep_for_time_interval(1.0);
  
  [self windowTest];
  end = [self currentTimeInMs];

  [self log:"Tests complete, run time = %d ms.\n", end - start];
  [self log:"---------------------------------------------------------\n"];

  [self clear];
  meanResult = (resLine +
                resCurve +
                resFill +
                resTrans +
                resComposite +
                resPath +
                resText +
                resWindowTest) / 8.0;
}

- (void)log:(const char *)fmt, ...;
{
  char    *buf = NULL;
  va_list  ap;
  size_t   len = 0;

  if (txtLog == nil) {
    return;
  }

  va_start(ap, fmt);
  vasprintf(&buf, fmt, ap);
  va_end(ap);

  len = [txtLog textLength];
  [txtLog setSel:len:len];
  [txtLog replaceSel:buf];

  xfree(buf);
}

- (void)setResult:(float)val
          forTest:(int)test
{
  char *buf = NULL;

  asprintf(&buf, "%0.4f", val);
  [[resMatrix setCol:0:test] setStringValue:buf];
  MAYBE_FREE(buf);
}

- (void)clearLog
{
  if (txtLog == nil) {
    return;
  }

  [txtLog setSel:0:[txtLog textLength]];
  [txtLog replaceSel:""];
 }

- (float)meanResult
{
  return meanResult;
}

- (id)setLogText:(id)anObject
{
  txtLog = anObject;

  return self;
}

- (void)line
{
  int i         = 0;
  int j         = 0;
  int k         = 0;
  int startTime = 0;
  int takenTime = 0;
  int w         = (int)bounds.size.width;
  int h         = (int)bounds.size.height;

  [[resMatrix cellAt:0:COL_LINE] setStringValue:"..."];

  [self lockFocus];
  {
    PSsetlinewidth(1.0);
    startTime = [self currentTimeInMs];

    for (j = 0; j < 100; j++) {
      for (k = 0; k < 100; k++) {
        i = k + 100 * j;
        
        PSsethsbcolor(((float)(i % 32)) / 32.0, 1.0, 1.0);
        PSmoveto((float)((i + 120) % w),
                 (float)(i % h));
        PSlineto((float)((i + 40) % w),
                 (float)((i + 240) % h));
        PSstroke();

        [[self window] flushWindow];
      }
    }

    takenTime = [self currentTimeInMs] - startTime;
  }
  [self unlockFocus];

  resLine = (1000000.0 / (float)takenTime / 25.5643);
  [self log:"Line: time taken: %d ms, raw: %0.4f, factor: %0.4f\n",
        takenTime,
        1000000.0 / (float)takenTime,
        resLine];
  [[resMatrix cellAt:0:COL_LINE] setFloatValue:resLine];
}

- (void)curve
{
  int i         = 0;
  int j         = 0;
  int k         = 0;
  int startTime = 0;
  int takenTime = 0;
  int w         = (int)bounds.size.width;
  int h         = (int)bounds.size.height;
  
  [[resMatrix cellAt:0:COL_CURVE] setStringValue:"..."];

  [self lockFocus];
  {
    PSmoveto(100.0, 100.0);
    startTime = [self currentTimeInMs];

    for(j=0; j < 100; j++) {
      for (k=0; k < 50; k++) {
        i = k + 100 * j;
        PSsethsbcolor(((float)(i % 32)) / 32.0, 1.0, 1.0);
        
        PSmoveto((float) ((i + 120) % w),
                 (float) ((i + 10)  % h));

        PSrcurveto((float) ((i)       % w),
                   (float) ((i + 20)  % h),
                   (float) ((i + 420) % w),
                   (float) ((i)       % h),
                   (float) ((i + 320) % w),
                   (float) ((i + 12)  % h));

        PSstroke();
        [[self window] flushWindow];
      }
    }

    takenTime = [self currentTimeInMs] - startTime;
  }
  [self unlockFocus];
  
  resCurve = (1000000.0/(float)takenTime/47.6054);
  [self log:"Curve: time taken: %d ms, raw: %0.4f, factor: %0.4f\n",
        takenTime,
        1000000.0 / (float)takenTime,
        resCurve];
  [[resMatrix cellAt:0:COL_CURVE] setFloatValue:resCurve];
}

- (void)fill
{
  int i         = 0;
  int j         = 0;
  int k         = 0;
  int startTime = 0;
  int takenTime = 0;
  int w         = (int)bounds.size.width;
  int h         = (int)bounds.size.height;
  
  [[resMatrix cellAt:0:COL_FILL] setStringValue:"..."];
  
  [self lockFocus];
  {
    PSmoveto(100.0, 100.0);
    startTime = [self currentTimeInMs];
    
    for(j=0; j < 100; j++) {
      for (k=0; k < 50; k++) {
        i = k + 100 * j;
        PSsethsbcolor(((float)(i % 32)) / 32.0, 1.0, 1.0);
        
        PSrectfill((float)(random() % w),
                   (float)(random() % h),
                   100.0,
                   100.0);

        [[self window] flushWindow];
      }
    }

    takenTime = [self currentTimeInMs] - startTime;
  }
  [self unlockFocus];
  
  resFill = (1000000.0/(float)takenTime/92.0640);

  [self log:"Fill: time taken: %d ms, raw: %0.4f, factor: %0.4f\n",
        takenTime,
        1000000.0 / (float)takenTime,
        resFill];
  [[resMatrix cellAt:0:COL_FILL] setFloatValue:resFill];
}

- (void)trans
{
  int i         = 0;
  int startTime = 0;
  int takenTime = 0;
  
  [[resMatrix cellAt:0:COL_TRANS] setStringValue:"..."];
  
  [self lockFocus];
  {
    PSmoveto(10.0 , 70.0);
    PSselectfont("Helvetica", 144);
    startTime = [self currentTimeInMs];
    
    for (i=0; i < 150; i++) {
      PSgsave();
      PSsethsbcolor(((float)(i % 32)) / 32.0, 1.0, 1.0);

      PSscale((float)(random() % 40) / 10.0 + 0.1,
              (float)(random() % 40) / 10.0 + 0.1);
      PSshow("NeXTSTEP");
    
      PSrotate((float)(random() % 360));
      PSshow("NeXTSTEP");

      PStranslate((float)(random() % 200) /10.0 - 10.0,
                  (float)(random() % 200) /10.0 - 10.0);
      PSshow("NeXTSTEP");
      
      [[self window] flushWindow];
      PSgrestore();
    }

    takenTime = [self currentTimeInMs] - startTime;    
  }
  [self unlockFocus];

  resTrans = (1000000.0 / (float)takenTime / 47.1965);
  [self log:"Transpose: time taken: %d ms, raw: %0.4f, factor: %0.4f\n",
        takenTime,
        1000000.0 / (float)takenTime,
        resTrans];
  [[resMatrix cellAt:0:COL_TRANS] setFloatValue:resTrans];
}

- (void)composite
{
  int i         = 0;
  int j         = 0;
  int k         = 0;
  int startTime = 0;
  int takenTime = 0;
  int w         = (int)bounds.size.width;
  int h         = (int)bounds.size.height;
  
  [[resMatrix cellAt:0:COL_COMPOSITE] setStringValue:"..."];
  
  [self lockFocus];
  {
    startTime = [self currentTimeInMs];

    for(j=0; j < 100; j++) {
      for (k=0; k < 100; k++) {
        i = k + 100 * j;

        PScomposite((float)(i % w),
                    (float)(random() % h),
                    100.0,
                    100.0,
                    [[self window] gState],
                    50.0,
                    50.0,
                    NX_COPY);

        PScomposite((float)(random() % w),
                    (float)(i % h),
                    100.0,
                    100.0,
                    [[self window] gState],
                    170.0,
                    50.0,
                    NX_COPY);

        PScomposite((float)(i % w),
                    (float)(random() % h),
                    100.0,
                    100.0,
                    [[self window] gState],
                    170.0,
                    170.0,
                    NX_COPY);

        PScomposite((float)(random() % w),
                    (float)(i % h),
                    100.0,
                    100.0,
                    [[self window] gState],
                    50.0,
                    170.0,
                    NX_COPY);

        [[self window] flushWindow];
      }
    }

    takenTime = [self currentTimeInMs] - startTime;
  }
  [self unlockFocus];
  
  resComposite = (1000000.0/(float)takenTime/8.81096);
  [self log:"Composite: time taken: %d ms, raw: %0.4f, factor: %0.4f\n",
        takenTime,
        1000000.0 / (float)takenTime,
        resComposite];
  [[resMatrix cellAt:0:COL_COMPOSITE] setFloatValue:resComposite];
}

- (void)userPath
{
  int    i         = 0;
  int    j         = 0;
  int    k         = 0;
  short  data[6]   = { 10, 10, 400, 10, 200, 300 };
  char   ops[4]    = { dps_moveto, dps_lineto, dps_lineto, dps_closepath };
  short  bbox[4]   = { 0 };
  NXRect vRect     = { 0 };
  int    w         = 0;
  int    h         = 0;
  int    startTime = 0;
  int    takenTime = 0;
  
  [[resMatrix cellAt:0:COL_PATH] setStringValue:"..."];
  [[self window] getFrame:&vRect];
  bbox[2] = w = (int)vRect.size.width;
  bbox[3] = h = (int)vRect.size.height;

  [self lockFocus];
  {
    PSsetlinewidth(1.0);
    PSmoveto(10, 10);
    startTime = [self currentTimeInMs];

    for (j = 0; j < 100; j++) {
      for (k = 0; k < 50; k++) {
        i = k + 100 * j;
        PSsethsbcolor(((float)(i % 32)) / 32.0, 1.0, 1.0);

        data[0] = (float)((i) % w);
        data[1] = (float)((i) % h);

        data[2] = (float)((i + 40) % w);
        data[3] = (float)((i + 40) % h);

        data[4] = (float)((i + i) % w);
        data[5] = (float)((i + i)  % h);

        DPSDoUserPath(data, 6, dps_short, ops, 4, bbox, dps_ustroke);
        [[self window] flushWindow];
      }
    }
    
    takenTime = [self currentTimeInMs] - startTime;
  }
  [self unlockFocus];

  resPath = (1000000.0 / (float)takenTime / 8.0);
  [self log:"Userpath: time taken: %d ms, raw: %0.4f, factor: %0.4f\n",
        takenTime,
        1000000.0 / (float)takenTime,
        resPath];
  [[resMatrix cellAt:0:COL_PATH] setFloatValue:resPath];
}

- (void)text
{
  int  i         = 0;
  int  j         = 0;
  int  k         = 0;
  int  startTime = 0;
  int  takenTime = 0;
  int  w         = (int)bounds.size.width;
  int  h         = (int)bounds.size.height;
  char s[9]      = { 0 };

  [[resMatrix cellAt:0:COL_TEXT] setStringValue:"..."];
  
  [self lockFocus];
  {
    PSselectfont("Times-Roman",72.0);
    startTime = [self currentTimeInMs];

    for(j=0; j < 100; j++) {
      for (k=0; k < 50; k++) {
        i = k + 100 * j;
        
        PSsethsbcolor(((float)(i % 32)) / 32.0, 1.0, 1.0);
        PSmoveto((float) (random() % w),
                 (float) (random() % h));

        s[0] = 'R' + random() % 10; s[1] = 'h' + random() % 22;
        s[2] = 'a' + random() % 3;  s[3] = 'p' + random() % 6;
        s[4] = 's' + random() % 7;  s[5] = 'o' + random() % 6;
        s[6] = 'd' + random() % 22; s[7] = 'y' + random() % 8;
        s[8] = '\0';
        PSshow(s);

        [[self window] flushWindow];
      }
    }

    takenTime = [self currentTimeInMs] - startTime;
  }
  [self unlockFocus];
  
  resText = (1000000.0/(float)takenTime/37.3552);
  [self log:"Text: time taken: %d ms, raw: %0.4f, factor: %0.4f\n",
        takenTime,
        1000000.0 / (float)takenTime,
        resText];
  [[resMatrix cellAt:0:COL_TEXT] setFloatValue:resText];
}

- (void)windowTest
{
  int    i         = 0;
  int    j         = 0;
  int    startTime = 0;
  int    takenTime = 0;
  float  x         = 0.0;
  float  y         = 0.0;
  NXRect theRect   = { 0 };
  
  [[resMatrix cellAt:0:COL_WINDOW] setStringValue:"..."];
  
  [[self window] getFrame:&theRect];
  x = theRect.origin.x;
  y = theRect.origin.y;

  {
    startTime = [self currentTimeInMs];
  
    for (j=0; j < 10; j++) {
      for (i=0; i < 25; i++) {
        [[self window] moveTo:++x :++y];
      }
      for (i=0; i < 25; i++) {
        [[self window] moveTo:++x :--y];
      }
      for (i=0; i < 25; i++) {
        [[self window] moveTo:--x :--y];
      }
      for (i=0; i < 25; i++) {
        [[self window] moveTo:--x :++y];
      }
      for (i=0; i < 10; i++) {
        [[self window] orderOut:self];
        [[self window] orderFront:self];
      }
    }

    takenTime = [self currentTimeInMs] - startTime;
  }
  [[self window] makeKeyAndOrderFront:self];
  
  resWindowTest = (1000000.0/(float)takenTime/18.01);
  [self log:"Window: time taken: %d ms, raw: %0.4f, factor: %0.4f\n",
        takenTime,
        1000000.0 / (float)takenTime,
        resWindowTest];
  [[resMatrix cellAt:0:COL_WINDOW] setFloatValue:resWindowTest];
}

@end /* NXBenchView */

/* NXBenchView.m ends here. */
