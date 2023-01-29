/* -*- ObjC -*-
 * NetInfo.m --- NetInfo proxy implementation.
 *
 * Copyright (c) 2023 Paul Ward <asmodai@gmail.com>
 *
 * Author:     Paul Ward <asmodai@gmail.com>
 * Maintainer: Paul Ward <asmodai@gmail.com>
 * Created:    Sat, 28 Jan 2023 08:52:16 +0000 (GMT)
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

#import "NetInfo.h"

#import <libc.h>
#import <string.h>
#import <nikit/NIDomain.h>
#import <objc/HashTable.h>
#import <objc/List.h>

#import "Malloc.h"
#import "Utils.h"
#import "String.h"

static NetInfo *sharedNetInfo = nil;

@implementation NetInfo

+ (id)sharedInstance
{
  if (sharedNetInfo == nil) {
    [NetInfo initialize];
  }

  return sharedNetInfo;
}

+ (void)initialize
{
  if (self == [NetInfo class]) {
    sharedNetInfo = [[self allocFromZone:NXDefaultMallocZone()] init];
  }
}

- (id)init
{
  if ((self = [super init]) == nil) {
    return nil;
  }

  /* Just to be safe */
  [self disconnect];

  return self;
}

- (id)free
{
  [self disconnect];

  return [super free];
}

- (BOOL)connect
{
  ni_status res = ni_open(NULL, "/", &_ni);

  switch (res) {
    case NI_ALREADYCONNECTED:
    case NI_OK:
      return YES;

    case NI_NOTCONNECTED:
      fprintf(stderr, "NSBench: Could not connect to NetInfo domain.\n");
      return NO;

    default:
      fprintf(stderr,
              "NSBench: Could not connect to NetInfo domain.  Code %d.\n",
              res);
  }

  /* Fallthrough. */
  return NO;
}

- (void)disconnect
{
  if (_ni != NULL) {
    ni_free(&_ni);
  }

  _ni = NULL;
}

- (BOOL)getDirectory:(const char *)path
             toTable:(HashTable *)table;
{
  ni_status    res;
  ni_proplist  pl;
  ni_namelist  vl;
  ni_id        dir;
  ni_property  prop;
  size_t       pn   = 0;
  size_t       i    = 0;


  NI_INIT(&pl);

  if (path == NULL) {
    /* Just don't even bother. */
    return NO;
  }

  /* Ensure we have a NI connection. */
  if (_ni == NULL) {
    fprintf(stderr,
            "NSBench: Attempt made to get NetInfo domain without a "
            "connection!\n");
    return NO;
  }

  /* Find the directory. */
  res = ni_pathsearch(_ni, &dir, path);
  if (res != NI_OK) {
    fprintf(stderr,
            "NSBench: Could not get `%s' from NetInfo domain.\n",
            path);
    return NO;
  }

  /* Read directory. */
  res = ni_read(_ni, &dir, &pl);
  if (res != NI_OK) {
    fprintf(stderr,
            "NSBench: Could not read directory `%s' from NetInfo.\n",
            path);
    return NO;
  }

  /*
   * NOTE: Ensure we copy from the NI structures... 
   *
   * We can't point to stuff, nor can we directly free stuff.
   */
  for (pn = 0; pn < pl.ni_proplist_len; ++pn) {
    List *lst = [[List allocFromZone:NXDefaultMallocZone()] init];

    prop = pl.ni_proplist_val[pn];
    vl   = prop.nip_val;
    
    for (i = 0; i < vl.ni_namelist_len; ++i) {
      [lst addObject:[[String alloc] initWithString:vl.ni_namelist_val[i]]];
    }
        
    [table insertKey:[[String alloc] initWithString:prop.nip_name]
               value:lst];
  }
  ni_proplist_free(&pl);

  return YES;
}


@end /* NetInfo */

/* NetInfo.m ends here. */
