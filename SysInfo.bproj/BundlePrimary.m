/* -*- ObjC -*-
 * SysInfo.m  --- Sytem Information main object.
 *
 * Copyright (c) 2023 Paul Ward <asmodai@gmail.com>
 *
 * Time-stamp: <23/02/01 20:01:22 asmodai>
 * Revision:   376
 *
 * Author:     Paul Ward <asmodai@gmail.com>
 * Maintainer: Paul Ward <asmodai@gmail.com>
 * Created:    Thu, 26 Jan 2023 20:10:04 +0000 (GMT)
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
 * PAY CLOSE ATTENTION TO THE NAME OF THIS FILE
 *
 * LEAVE THE NAME OF THIS FILE ALONE!
 *
 * A bundle's principal class is the *first* class that the linker
 * comes across.
 */
/* }}} */

#import "BundlePrimary.h"
#import "../PercentBar.h"
#import "../PieChart.h"
#import "../Utils.h"
#import "../Malloc.h"
#import "../String.h"
#import "../Platform.h"
#import "MemInfo.h"
#import "HostInfo.h"

#import <libc.h>
#import <ctype.h>

#import <mach/mach.h>
#import <mach/host_info.h>

#import <appkit/Application.h>
#import <appkit/screens.h>
#import <appkit/Matrix.h>
#import <appkit/Cell.h>

#import <objc/List.h>

static const char *wiredLabel    = "Wired";
static const char *inactiveLabel = "Inactive";
static const char *activeLabel   = "Active";
static const char *freeLabel     = "Free";

static MemInfo *mi    = nil;

static char *sections[] = {
  "Host",
  "Display",
  "Network",
  "Storage",
};


static
int
depth_to_int(int depth)
{
  switch (depth) {
    case NX_TwentyFourBitRGBDepth:
      return 24;
    case NX_TwelveBitRGBDepth:
      return 12;

    case NX_EightBitRGBDepth:
    case NX_EightBitGrayDepth:
      return 8;

    case NX_TwoBitGrayDepth:
    case NX_DefaultDepth:
    default:
      return 2;
  }
}

static
BOOL
is_colour(int depth)
{
  switch (depth) {
    case NX_TwentyFourBitRGBDepth:
    case NX_TwelveBitRGBDepth:
    case NX_EightBitRGBDepth:
      return YES;

    default:
      return NO;
  }
}

@implementation SysInfo

- didLoadNib
{
  if (mi == nil) {
    mi = [MemInfo sharedInstance];
  }

  [mi setMachProxy:mach];

  [memPieChart addPieWedge:[mi wiredCount]
                     label:wiredLabel
                     shade:0.1];
  [memPieChart addPieWedge:[mi inactiveCount]
                     label:inactiveLabel
                     shade:0.3];
  [memPieChart addPieWedge:[mi activeCount]
                     label:activeLabel
                     shade:0.6];
  [memPieChart addPieWedge:[mi freeCount]
                     label:freeLabel
                     shade:0.80];

  [self poll];

  return self;
}

- (BOOL)loadFirst
{
  return YES;
}

- (void)poll
{
  [mi poll];
  
  [memPieChart setWedgeAt:0
                    value:[mi wiredCount]
                    label:NULL
                    shade:-1.0];
  [memPieChart setWedgeAt:1
                    value:[mi inactiveCount]
                    label:NULL
                    shade:-1.0];
  [memPieChart setWedgeAt:2
                    value:[mi activeCount]
                    label:NULL
                    shade:-1.0];
  [memPieChart setWedgeAt:3
                    value:[mi freeCount]
                    label:NULL
                    shade:-1.0];
  [memPieChart normalize];
  
  [self getDiskData:YES];
  [self getOS];
  [self setRAM];
  [self getCPU];
  
  [memBrowser  loadColumnZero];
  [hostBrowser loadColumnZero];
  [hostBrowser setTarget:self];
  [hostBrowser setAction:@selector(action:)];
}

- (void)getOS
{
  [(TextField *)hostOS setStringValue:[[platform system] stringValue]];
}

- (void)getCPU
{
  static char *cpu = NULL;

  if (cpu == NULL) {
    char *cpuType    = NULL;
    char *cpuSubtype = NULL;

    [mach cpu_type:&cpuType
           subtype:&cpuSubtype];
    asprintf(&cpu, "%s", cpuSubtype);

    MAYBE_FREE(cpuType);
    MAYBE_FREE(cpuSubtype);
  }

  [(TextField *)hostCPU setStringValue:cpu];
}

- (void)setRAM
{
  static char *ram = NULL;

  if (ram == NULL) {
    asprintf(&ram, "%dMB RAM", [mi physical]);
  }

  [(TextField *)hostRAM setStringValue:ram];
}

- (id)action:(id)sender
{
  NXBrowserCell *cell = sender;
  const char    *buf  = NULL;

  if (cell == NULL) {
    return self;
  }

  buf = [cell stringValue];
  if (buf == NULL || buf == "" || buf == '\0') {
    return self;
  }

  if        (strncmp(sections[0], buf, strlen(sections[0])) == 0) {
    [self getHostData];
  } else if (strncmp(sections[1], buf, strlen(sections[1])) == 0) {
    [self getScreenData];
  } else if (strncmp(sections[2], buf, strlen(sections[2])) == 0) {
    [self getNetData];
  } else if (strncmp(sections[3], buf, strlen(sections[3])) == 0) {
    [self getDiskData:NO];
  }

  return self;
}

- (int)browser:sender
    fillMatrix:matrix
      inColumn:(int)column
{
  if (sender == hostBrowser) {
    return [self getIndex:sender
               fillMatrix:matrix];
  } else if (sender == memBrowser) {
    return [self getMemory:sender
                fillMatrix:matrix];
  }

  return 0;
}

- (int)getIndex:sender
     fillMatrix:matrix
{
  size_t         i    = 0;
  NXBrowserCell *cell = NULL;

  for (i = 0; i < 4; ++i) {
    [matrix addRow];

    cell = [matrix cellAt:i :0];
    [cell setStringValueNoCopy:sections[i] shouldFree:NO];
    [cell setLeaf:YES];
    [cell setTag:i];
  }

  return 4;
}

- (int)getMemory:sender
      fillMatrix:matrix
{
  NXBrowserCell *cell = NULL;
  char          *buf  = NULL;

  [matrix addRow];
  cell = [matrix cellAt:0 :0];
  pretty_bytes(&buf, [mi freeCount]);
  [cell setStringValue:[[[String alloc]
                          initFromFormat:"Free: %s", buf]
                         stringValue]];
  MAYBE_FREE(buf);
  [cell setLeaf:YES];

  [matrix addRow];
  cell = [matrix cellAt:1 :0];
  pretty_bytes(&buf, [mi activeCount]);
  [cell setStringValue:[[[String alloc]
                          initFromFormat:"Active: %s", buf]
                         stringValue]];
  MAYBE_FREE(buf);
  [cell setLeaf:YES];

  [matrix addRow];
  cell = [matrix cellAt:2 :0];
  pretty_bytes(&buf, [mi inactiveCount]);
  [cell setStringValue:[[[String alloc]
                          initFromFormat:"Inactive: %s", buf]
                         stringValue]];
  MAYBE_FREE(buf);
  [cell setLeaf:YES];

  [matrix addRow];
  cell = [matrix cellAt:3 :0];
  pretty_bytes(&buf, [mi wiredCount]);
  [cell setStringValue:[[[String alloc]
                          initFromFormat:"Wired: %s", buf]
                         stringValue]];
  MAYBE_FREE(buf);
  [cell setLeaf:YES];

  return 4;
}

- (void)getHostData
{
  List *hostinfo = NULL;
  char *buf      = NULL;
  int   num      = 0;
  int   len      = 0;
  int   i        = 0;

  hostinfo = [[List allocFromZone:NXDefaultMallocZone()] init];
  
  len = get_hostname(&buf);
  if (len > 0) {
    [hostinfo addObject:[[String alloc] initWithString:buf]];
  }
  MAYBE_FREE(buf);

  len = get_domainname(&buf);
  if (len > 0) {
    [hostinfo addObject:[[String alloc] initWithString:buf]];
  }
  MAYBE_FREE(buf);

  len = [mach host_id];
  if (len > 0) {
    [hostinfo addObject:[[String alloc] initFromFormat:"Host ID: %d", len]];
  }

  len = get_host_ip(&buf);
  if (len > 0) {
    [hostinfo addObject:[[String alloc] initWithString:buf]];
  }
  MAYBE_FREE(buf);

  [hostinfo addObject:[[String alloc] initFromFormat:"\nKernel:\n%s",
                                      [[platform kernelVersion] stringValue]]];

  [hostText setSel:0 :[hostText textLength]];
  [hostText replaceSel:""];

  num = [hostinfo count];
  for (i = 0; i < num; ++i) {
    String *s = [hostinfo objectAt:i];

    len = [hostText textLength];
    
    [s cat:"\n"];

    [hostText setSel:len :len];
    [hostText replaceSel:[s stringValue]];
  }

  // Remember to free on the way out!
  [[hostinfo freeObjects] free];
}

- (void)getDiskData:(BOOL)onlyBar
{
  HashTable   *mounts = nil;
  String      *key    = NULL;
  Disk        *value  = NULL;
  size_t       len    = 0;
  NXHashState  state;
  BOOL         first  = YES;

  mounts = [[HashTable alloc]
             initKeyDesc:"@"
               valueDesc:"@"
                capacity:0];

  [DiskInfo disksFromMounted:mounts];

  if (!onlyBar) {
    [hostText setSel:0 :[hostText textLength]];
    [hostText replaceSel:""];
  }

  state = [mounts initState];
  while ([mounts nextState:&state
                       key:(void *)&key
                     value:(void *)&value])
  {
    if ([value stat] == NO) {
      continue;
    }

    if ([value isSystemDisk]) {
      [diskUsageBar setValue:[value usageFloat]];
    }

    if (!onlyBar) {
      char   *tbytes = NULL;
      char   *fbytes = NULL;
      String *buf    = nil;

      pretty_bytes(&tbytes, [value blockCount] * [value blockSize]);
      pretty_bytes(&fbytes, [value blocksFree] * [value blockSize]);

      buf = [[String alloc]
              /*
               * /dev/blah
               *     5TB CD-ROM
               *     CDFS filesystem
               *     1B free (99%)
               *     Mounted at /path
               *
               * Pay attention to actual tab chars!
               */
              initFromFormat:"%s\n"
                             "    %s %s%s%s\n"
                             "    %s filesystem\n"
                             "    %s free (%0.2f%% usage)\n"
                             "    Mounted on %s\n",
              [[value filesystemName] stringValue],
              tbytes,
              [value isReadOnly]   ? "Read-Only " : "",
              [value isSystemDisk] ? "System "    : "",
              [value diskTypeString],
              [value filesystemTypeString],
              fbytes,
              [value usageFloat],
              [[value mountPoint] stringValue]];

      if (!first) {
        len = [hostText textLength];
        [hostText setSel:len :len];
        [hostText replaceSel:"\n"];
      }
      first = NO;

      len = [hostText textLength];
      [hostText setSel:len :len];
      [hostText replaceSel:[buf stringValue]];

      MAYBE_FREE(fbytes);
      MAYBE_FREE(tbytes);
      DESTROY(buf);
    }
  }

  [mounts freeObjects];
  [mounts free];
}

- (void)getNetData
{
  List   *netinfo     = NULL;
  List   *dns_servers = NULL;
  String *dns_domain  = NULL;
  String *dns_search  = NULL;
  BOOL    ok          = NO;
  int     num         = 0;
  int     len         = 0;
  int     i           = 0;

  netinfo     = [[List   allocFromZone:NXDefaultMallocZone()] init];
  dns_servers = [[List   allocFromZone:NXDefaultMallocZone()] init];
  dns_domain  = [[String allocFromZone:NXDefaultMallocZone()] init];
  dns_search  = [[String allocFromZone:NXDefaultMallocZone()] init];

  ok = get_dns_config(netInfo, dns_domain, dns_search, dns_servers);
  if (ok == YES) {
    if ([dns_domain length] > 0) {
      [netinfo addObject:[[String alloc]
                           initFromFormat:"DNS Domain: %s",
                           [dns_domain stringValue]]];
    }

    if ([dns_search length] > 0) {
      [netinfo addObject:[[String alloc]
                           initFromFormat:"DNS Search: %s",
                           [dns_search stringValue]]];
    }

    for (i = 0; i < [dns_servers count]; ++i) {
      [netinfo addObject:[[String alloc]
                           initFromFormat:"DNS Server: %s",
                           [[dns_servers objectAt:i] stringValue]]];
    }

    [dns_servers freeObjects];
    [dns_servers free];
  }

  [hostText setSel:0 :[hostText textLength]];
  [hostText replaceSel:""];

  num = [netinfo count];
  for (i = 0; i < num; ++i) {
    String *s = [netinfo objectAt:i];

    len = [hostText textLength];
    
    [s cat:"\n"];

    [hostText setSel:len :len];
    [hostText replaceSel:[s stringValue]];
  }

  // Remember to free on the way out!
  [[netinfo freeObjects] free];
}

- (void)getScreenData
{
  static HashTable *screens = NULL;
  NXHashState       state;
  NXScreen         *lst     = NULL;
  const NXScreen   *main    = NULL;
  const void       *key     = NULL;
  const void       *value   = NULL;
  size_t            len     = 0;
  int               num     = 0;
  int               i       = 0;

  if (screens == NULL) {
    screens = [[HashTable allocFromZone:[self zone]]
                initKeyDesc:"!"
                  valueDesc:"@"
                   capacity:0];

    [NXApp getScreens:&lst count:&num];
    main = [NXApp mainScreen];

    for (i = 0; i < num; ++i) {
      BOOL  isMain = NO;

      if (lst[i].screenNumber == main->screenNumber) {
        isMain = YES;
      }
      
      [screens insertKey:(int)lst[i].screenNumber
                   value:[[String alloc]
                           initFromFormat:"%d: %d x %d @ %d %s%s\n",
                           lst[i].screenNumber,
                           (int)lst[i].screenBounds.size.width,
                           (int)lst[i].screenBounds.size.height,
                           depth_to_int(lst[i].depth),
                           is_colour(lst[i].depth) ? " [color]" : "",
                           isMain                  ? " [main]"  : ""]];
    }
  }

  [hostText setSel:0 :[hostText textLength]];
  [hostText replaceSel:""];


  state = [screens initState];
  while ([screens nextState:&state
                        key:&key
                      value:&value])
  {
    String *sval = (String *)value;

    len = [hostText textLength];

    [hostText setSel:0 :0];
    [hostText replaceSel:(char *)[sval stringValue]];
  }
}

- refreshInfo:sender
{
  [self poll];

  return self;
}

@end /* SysInfo */

/* SysInfo.m ends here. */
