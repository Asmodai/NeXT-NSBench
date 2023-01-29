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
#import "../Utils.h"

#import <libc.h>
#import <stdlib.h>

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
  srandom(1);

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

  [self text];
  sleep_for_time_interval(1.0);
  
  [self windowTest];

  meanResult = (resLine + 
                resCurve + 
                resFill + 
                resTrans + 
                resText + 
                resComposite + 
                resWindowTest) / 7.0;
}

- (float)meanResult
{
  return meanResult;
}

- (void)line
{
  int i        = 0;
  int j        = 0;
  int k        = 0;
  int stopTime = 0;
  int w        = (int)bounds.size.width;
  int h        = (int)bounds.size.height;

  [self lockFocus];
  {
    PSsetlinewidth(1.0);
    stopTime = [self currentTimeInMs];

    for (j = 0; j < 100; j++) {
      for (k = 0; k < 100; k++) {
        i = k + 100 * j;
        
        PSsethsbcolor(((float)(i % 32)) / 32.0, 1.0, 1.0);
        PSmoveto((float) ((i + 120) % w),
                 (float) (i % h));
        PSlineto((float) ((i + 40) % w),
                 (float) ((i + 240) % h));
        PSstroke();

        [[self window] flushWindow];
      }
    }
  }
  [self unlockFocus];

  stopTime = [self currentTimeInMs] - stopTime;
  resLine = (1000000.0 / (float)stopTime / 25.5643);
  [[resMatrix cellAt:0 :0] setFloatValue:resLine];
}

- (void)curve
{
  int i,j,k, stopTime;
  int w = (int)bounds.size.width;
  int h = (int)bounds.size.height;
  
  stopTime = [self currentTimeInMs];
  
  [self lockFocus];
  {
    PSmoveto(100.0, 100.0);

    for(j=0; j < 100; j++) {
      for (k=0; k < 50; k++) {
        i = k + 100 * j;
        PSsethsbcolor(((float)(i%32)) / 32.0, 1.0, 1.0);
        
        PSmoveto((float) ((i+120) % w),
                 (float) ((i+10) % h));
        PSrcurveto((float) ((i) % w),
                   (float) ((i+20) % h),
                   (float) ((i+420) % w),
                   (float) ((i) % h),
                   (float) ((i+320) % w),
                   (float) ((i+12) % h));
        PSstroke();
        [[self window] flushWindow];
      }
    }
  }
  [self unlockFocus];
  
  stopTime = [self currentTimeInMs] - stopTime;
  resCurve = (1000000.0/(float)stopTime/47.6054);
  [[resMatrix cellAt:0 :1] setFloatValue:resCurve];
}

- (void)fill
{
  int i,j,k, stopTime;
  int w = (int)bounds.size.width;
  int h = (int)bounds.size.height;
  
  stopTime = [self currentTimeInMs];
  
  [self lockFocus];
  {
    PSmoveto(100.0, 100.0);
    
    for(j=0; j < 100; j++) {
      for (k=0; k < 50; k++) {
        i = k + 100 * j;
        PSsethsbcolor(((float)(i%32)) / 32.0, 1.0, 1.0);
        
        PSrectfill((float)(random() % w), (float)(random() % h), 100.0, 100.0);
        [[self window] flushWindow];
      }
    }
  }
  [self unlockFocus];
  
  stopTime = [self currentTimeInMs] - stopTime;
  resFill = (1000000.0/(float)stopTime/92.0640);
  [[resMatrix cellAt:0 :2] setFloatValue:resFill];
}

- (void)trans
{
  int i, stopTime;
  
  stopTime = [self currentTimeInMs];
  
  [self lockFocus];
  {
    PSmoveto(10.0 , 70.0);
    PSselectfont("Helvetica", 144);
    for (i=0; i < 150; i++) {
      PSgsave();
      PSsethsbcolor(((float)(i%32)) / 32.0, 1.0, 1.0);

      PSscale((float)(random()%40)/10.0+0.1, (float)(random()%40)/10.0+0.1);
      PSshow("Nitro");
      PSrotate((float)(random()%360));
      PSshow("Rob Blessin");
      PStranslate((float)(random()%200)/10.0-10.0,
                  (float)(random()%200)/10.0-10.0);
      PSshow("nextcomputers.org");
      [[self window] flushWindow];
      PSgrestore();
    }
  }
  [self unlockFocus];
  
  stopTime = [self currentTimeInMs] - stopTime;
  resTrans = (1000000.0/(float)stopTime/47.1965);
  [[resMatrix cellAt:0 :3] setFloatValue:resTrans];
}

- (void)text
{
  int i,j,k, stopTime;
  int w = (int)bounds.size.width;
  int h = (int)bounds.size.height;
  char s[9];
  
  stopTime = [self currentTimeInMs];
  
  [self lockFocus];
  PSselectfont("Times-Roman",72.0);
  for(j=0; j < 100; j++) {
    for (k=0; k < 50; k++) {
      i = k + 100 * j;
      PSsethsbcolor(((float)(i%32)) / 32.0, 1.0, 1.0);

      PSmoveto((float) (random() % w),
               (float) (random() % h));
      s[0] = 'R' + random()%10; s[1] = 'h' + random()%22;
      s[2] = 'a' + random()%3;  s[3] = 'p' + random()%6;
      s[4] = 's' + random()%7; s[5] = 'o' + random()%6;
      s[6] = 'd' + random()%22; s[7] = 'y' + random()%8;
      s[8] = '\0';
      PSshow(s);
      [[self window] flushWindow];
    }
  }
  [self unlockFocus];
  
  stopTime = [self currentTimeInMs] - stopTime;
  resText = (1000000.0/(float)stopTime/37.3552);
  [[resMatrix cellAt:0 :6] setFloatValue:resText];
}

- (void)composite
{
  int i,j,k, stopTime;
  int w = (int)bounds.size.width;
  int h = (int)bounds.size.height;
  
  stopTime = [self currentTimeInMs];
  
  [self lockFocus];
  {
    for(j=0; j < 100; j++) {
      for (k=0; k < 100; k++) {
        i = k + 100 * j;
        PScomposite((float) (i % w), (float) (random() % h), 100.0, 100.0,
                    [[self window] gState], 50.0, 50.0, NX_COPY);
        PScomposite((float) (random() % w), (float) (i % h), 100.0, 100.0,
                    [[self window] gState], 170.0, 50.0, NX_COPY);
        PScomposite((float) (i % w), (float) (random() % h), 100.0, 100.0,
                    [[self window] gState], 170.0, 170.0, NX_COPY);
        PScomposite((float) (random() % w), (float) (i % h), 100.0, 100.0,
                    [[self window] gState], 50.0, 170.0, NX_COPY);
        [[self window] flushWindow];
      }
    }
  }
  [self unlockFocus];
  
  stopTime = [self currentTimeInMs] - stopTime;
  resComposite = (1000000.0/(float)stopTime/8.81096);
  [[resMatrix cellAt:0 :4] setFloatValue:resComposite];
}

- (void)windowTest
{
  int i, j, stopTime;
  float x,y;
  NXRect theRect;
  
  stopTime = [self currentTimeInMs];
  
  [[self window] getFrame:&theRect];
  x = theRect.origin.x;
  y = theRect.origin.y;
  
  for (j=0; j < 10; j++) {
    for (i=0; i < 25; i++) {
      [[self window] moveTo:++x :++y]; //setFrameOrigin:NSMakePoint(++x, ++y)];
    }
    for (i=0; i < 25; i++) {
      [[self window] moveTo:++x :--y]; //setFrameOrigin:NSMakePoint(++x, --y)];
    }
    for (i=0; i < 25; i++) {
      [[self window] moveTo:--x :--y]; //setFrameOrigin:NSMakePoint(--x, --y)];
    }
    for (i=0; i < 25; i++) {
      [[self window] moveTo:--x :++y]; //setFrameOrigin:NSMakePoint(--x, ++y)];
    }
    for (i=0; i < 10; i++) {
      [[self window] orderOut:self];
      [[self window] orderFront:self];
    }
  }
  [[self window] makeKeyAndOrderFront:self];
  
  stopTime = [self currentTimeInMs] - stopTime;
  resWindowTest = (1000000.0/(float)stopTime/18.01);
  [[resMatrix cellAt:0 :7] setFloatValue:resWindowTest];
}

@end /* NXBenchView */

/* NXBenchView.m ends here. */
