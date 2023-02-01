/* -*- ObjC -*-
 * Platform.m --- Platform detection.
 *
 * Copyright (c) 2023 Paul Ward <asmodai@gmail.com>
 *
 * Time-stamp: <23/02/01 11:31:15 asmodai>
 *
 * Author:     Paul Ward <asmodai@gmail.com>
 * Maintainer: Paul Ward <asmodai@gmail.com>
 * Created:    Wed,  1 Feb 2023 10:18:02 +0000 (GMT)
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

#import "Platform.h"
#import "Malloc.h"
#import "Utils.h"
#import "Mach.h"

#import <libc.h>
#import <ctype.h>
#import <mach/mach.h>
#import <mach/host_info.h>

static Platform *sharedPlatform = nil;

@implementation Platform

+ (id)sharedInstance
{
  if (sharedPlatform == nil) {
    [Platform initialize];
  }

  return sharedPlatform;
}

+ (void)initialize
{
  if (self == [Platform class]) {
    sharedPlatform = [[self alloc] init];
  }
}

- (id)init
{
  if ((self = [super init]) == nil) {
    return nil;
  }

  _major    = 0;
  _minor    = 0;
  _openstep = NO;

  [self _getKernelVersion];

  return self;
}

- (id)free
{
  DESTROY(_name);
  DESTROY(_platform);
  DESTROY(_codename);
  DESTROY(_kernel);

  return [super free];
}

- (String *)system        { return _name;     }
- (String *)platform      { return _platform; }
- (String *)codeName      { return _codename; }
- (int)majorVersion       { return _major;    }
- (int)minorVersion       { return _minor;    }
- (String *)kernelVersion { return _kernel;   }
- (BOOL)isOpenStep        { return _openstep; }

- (void)_getKernelVersion
{
  char             *name = NULL;
  char             *buf  = NULL;
  kernel_version_t  ver  = "";
  size_t            idx  = 0;
  size_t            len  = 0;

  // Call to Mach will exit(EXIT_FAILURE) upon failure, so we can
  // assume we get a valid return here.
  [[Mach sharedInstance] kernel_version:&ver];
  len = strlen(ver);

  asprintf(&buf, "%s", ver);
  if (buf[strlen(buf) - 1] == '\n') {
    // We have a newline, get rid of it.
    buf[strlen(buf) - 1] = '\0';
  }
  _kernel = [[String alloc] initWithString:buf];
  MAYBE_FREE(buf);

  for (idx = 0; idx < len; ++idx) {
    /* Version: [0-9].[0-9]: */
    if (isdigit(ver[idx])     && ver[idx + 1] == '.' &&
        isdigit(ver[idx + 2]) && ver[idx + 3] == ':')
    {
      asprintf(&buf, "%c.%c",
               ver[idx],
               ver[idx + 2]);
      break;
    }
      
    /* Version: [0-9].[0-9].[0-9]: */
    if (isdigit(ver[idx])     && ver[idx + 1] == '.' &&
        isdigit(ver[idx + 2]) && ver[idx + 3] == '.' &&
        isdigit(ver[idx + 4]) && ver[idx + 5] == ':')
    {
      asprintf(&buf, "%c.%c.%c",
               ver[idx],
               ver[idx + 2],
               ver[idx + 4]);
      break;
    }
      
    /* Version: [0-9][0-9].[0-9].[0-9]: */
    if (isdigit(ver[idx])   && isdigit(ver[idx + 1]) &&
        ver[idx + 2] == '.' && isdigit(ver[idx + 3]) &&
        ver[idx + 4] == '.' && isdigit(ver[idx + 5]) &&
        ver[idx + 6] == ':')
    {
      asprintf(&buf, "%c%c.%c.%c",
               ver[idx],
               ver[idx + 1],
               ver[idx + 3],
               ver[idx + 5]);
      break;
    }
  } /* for (idx ... ) */

  if (buf[1] == '.') {
    switch (buf[0]) {
      case '0':
      case '1':
      case '2':
      case '3':
        asprintf(&name, "NEXTSTEP %s", buf);
        _openstep = NO;
        break;

      case '4':
        asprintf(&name, "OPENSTEP %s", buf);
        _openstep = YES;
        break;

      case '5':
        len = strlen(buf);
        for (idx = 0; idx < len; ++idx) {
          if (buf[idx] == '\n') {
            buf[idx] = ' ';
          }
        }
        asprintf(&name, "Rhapsody %s", buf);
        _openstep = YES;
        break;
        
      default:
        asprintf(&name, "Darwin %s", buf);
        _openstep = YES;
    }
  } else {
    asprintf(&name, "OpenStep %s");
    _openstep = YES;
  }

  _name = [[String alloc] initWithString:name];
  MAYBE_FREE(name);
  MAYBE_FREE(buf);
}

@end /* Platform */

/* Platform.m ends here. */
