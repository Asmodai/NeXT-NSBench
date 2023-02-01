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

typedef struct {
  float line;
  float curve;
  float fill;
  float trans;
  float composite;
  float path;
  float text;
  float window_move;
  float window_resize;
  float factor;
} results_t;

static results_t baseline_results = {
  8.0321,
  15.3466,
  31.5577,
  15.0092,
  2.8650,
  6.0385,
  10.1685,
  23.2099,
  40.3454,
  0.492283
};

@implementation NXBenchView

- (id)initFrame:(const NXRect *)rect
{
  if ((self = [super initFrame:rect]) == nil) {
    return nil;
  }

  meanResult = 0.0;

  return self;
}

- drawSelf:(const NXRect *)rect:(int)count
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
  
  [self windowMove];
  sleep_for_time_interval(1.0);

  [self windowResize];
  end = [self currentTimeInMs];

  [self clear];
  meanResult = (resLine       +
                resCurve      +
                resFill       +
                resTrans      +
                resComposite  +
                resPath       +
                resText       +
                resWindowMove +
                resWindowResize) / 9.0;

  [self log:"NXFactor = %0.6f\n", meanResult];
  [self log:"Tests complete, run time = %d ms.\n", end - start];
  [self log:"---------------------------------------------------------\n"];
  [self clearStatus];

  if (txtFactor != nil) {
    char *buf = NULL;

    asprintf(&buf, "%0.2f", meanResult);
    [(TextField *)txtFactor setStringValue:buf];
    MAYBE_FREE(buf);
  }
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

- (void)clearLog
{
  if (txtLog == nil) {
    return;
  }

  [txtLog setSel:0:[txtLog textLength]];
  [txtLog replaceSel:""];
 }

- (void)status:(const char *)msg
{
  char *buf = NULL;

  asprintf(&buf, "Running `%s' test.", msg);
  [txtStatus setStringValue:buf];
  MAYBE_FREE(buf);
}

- (void)clearStatus
{
  [txtStatus setStringValue:"Ready, please press `run' to start."];
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

- (id)setTestWindow:(id)anObject
{
  wndTest = anObject;

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

  [self status:"line drawing"];

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

  resLine = (1000000.0 / (float)takenTime / baseline_results.line);
  [self log:"Line: time taken: %d ms, raw: %0.4f, factor: %0.4f\n",
        takenTime,
        1000000.0 / (float)takenTime,
        resLine];
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
  
  [self status:"curve drawing"];

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
  
  resCurve = (1000000.0/(float)takenTime/baseline_results.curve);
  [self log:"Curve: time taken: %d ms, raw: %0.4f, factor: %0.4f\n",
        takenTime,
        1000000.0 / (float)takenTime,
        resCurve];
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
  
  [self status:"Fill"];
  
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
  
  resFill = (1000000.0/(float)takenTime/baseline_results.fill);

  [self log:"Fill: time taken: %d ms, raw: %0.4f, factor: %0.4f\n",
        takenTime,
        1000000.0 / (float)takenTime,
        resFill];
}

- (void)trans
{
  int i         = 0;
  int startTime = 0;
  int takenTime = 0;
  
  [self status:"transposition"];
  
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

  resTrans = (1000000.0 / (float)takenTime / baseline_results.trans);
  [self log:"Transpose: time taken: %d ms, raw: %0.4f, factor: %0.4f\n",
        takenTime,
        1000000.0 / (float)takenTime,
        resTrans];
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
  
  [self status:"composition"];
  
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
  
  resComposite = (1000000.0/(float)takenTime/baseline_results.composite);
  [self log:"Composite: time taken: %d ms, raw: %0.4f, factor: %0.4f\n",
        takenTime,
        1000000.0 / (float)takenTime,
        resComposite];
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
  
  [self status:"userpath"];

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

  resPath = (1000000.0 / (float)takenTime / baseline_results.path);
  [self log:"Userpath: time taken: %d ms, raw: %0.4f, factor: %0.4f\n",
        takenTime,
        1000000.0 / (float)takenTime,
        resPath];
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

  [self status:"text"];
  
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
  
  resText = (1000000.0/(float)takenTime/baseline_results.text);
  [self log:"Text: time taken: %d ms, raw: %0.4f, factor: %0.4f\n",
        takenTime,
        1000000.0 / (float)takenTime,
        resText];
}

- (void)windowMove
{
  int    i         = 0;
  int    j         = 0;
  int    startTime = 0;
  int    takenTime = 0;
  float  x         = 0.0;
  float  y         = 0.0;
  NXRect theRect   = { 0 };
  
  [self status:"window movement"];
  
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
  
  resWindowMove = (1000000.0/(float)takenTime/baseline_results.window_move);
  [self log:"Window move: time taken: %d ms, raw: %0.4f, factor: %0.4f\n",
        takenTime,
        1000000.0 / (float)takenTime,
        resWindowMove];
}

- (void)windowResize
{
  int    i         = 0;
  int    j         = 0;
  int    startTime = 0;
  int    takenTime = 0;
  float  w         = 0.0;
  float  h         = 0.0;
  NXRect theRect   = { 0 };
  
  if (wndTest == nil) {
    return;
  }

  [self status:"window movement"];
  [wndTest makeKeyAndOrderFront:self];
  
  [wndTest getFrame:&theRect];
  w = theRect.size.width;
  h = theRect.size.height;

  {
    startTime = [self currentTimeInMs];
  
    for (j = 50; j < h; j = j + 50) {
      for (i = 90; i < w; i = i + 50) {
        [wndTest sizeWindow:i:j];
        [wndTest display];
      }
    }

    takenTime = [self currentTimeInMs] - startTime;
  }
  [[self window] makeKeyAndOrderFront:self];
  [wndTest orderOut:self];
  
  resWindowResize = (1000000.0/(float)takenTime/baseline_results.window_resize);
  [self log:"Window resize: time taken: %d ms, raw: %0.4f, factor: %0.4f\n",
        takenTime,
        1000000.0 / (float)takenTime,
        resWindowResize];
}

@end /* NXBenchView */

/* NXBenchView.m ends here. */
