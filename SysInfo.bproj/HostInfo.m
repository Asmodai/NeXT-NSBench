/* -*- ObjC -*-
 * HostInfo.m  --- Some title
 *
 * Copyright (c) 2023 Paul Ward <asmodai@gmail.com>
 *
 * Time-stamp: <23/01/29 22:04:37 asmodai>
 *
 * Author:     Paul Ward <asmodai@gmail.com>
 * Maintainer: Paul Ward <asmodai@gmail.com>
 * Created:    Sat, 28 Jan 2023 07:17:45 +0000 (GMT)
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

#import <libc.h>
#import <stdio.h>
#import <stdlib.h>

#import <sys/types.h>

#import <netdb.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>

#import <objc/List.h>
#import <objc/HashTable.h>

#import "HostInfo.h"
#import "../Utils.h"
#import "../NetInfo.h"
#import "../Malloc.h"
#import "../String.h"

#define MAX_CALLBUFLEN   256
#define MAX_DOMAINS      35
#define MAX_ADDRS        35
#define MAX_SERVERS      10

static const char   *pathResolvConf = "/etc/resolv.conf\0";
static const char   *keyDomain      = "domain";
static const char   *keySearch      = "search";
static const char   *keyServer      = "nameserver";

int
get_hostname(char **buf)
{
  char result[MAX_CALLBUFLEN] = { 0 };

  if (gethostname(result, MAX_CALLBUFLEN) == -1) {
    perror("gethostname()");
    return 0;
  }
  result[MAX_CALLBUFLEN - 1] = '\0';

  if (result[0] == '\0') {
    *buf = NULL;
    return 0;
  }

  return asprintf(buf, "Name: %s", result);
}

int
get_domainname(char **buf)
{
  char result[MAX_CALLBUFLEN] = { 0 };

  if (getdomainname(result, MAX_CALLBUFLEN) == -1) {
    perror("getdomainname()");
    return 0;
  }
  result[MAX_CALLBUFLEN - 1] = '\0';

  if (result[0] == '\0') {
    *buf = NULL;
    return 0;
  }

  return asprintf(buf, "Domain: %s", result);
}

BOOL
get_resolv_conf(String *domain, String *search, List *servers)
{
  register FILE  *fp              = NULL;
  register char  *cp              = NULL;
  char            buf[BUFSIZ]     = { 0 };
  char            tmp[BUFSIZ + 1] = { 0 };

  if ((fp = fopen(pathResolvConf, "r")) == NULL) {
    perror("fopen()");
    return NO;
  }

  while (fgets(buf, sizeof(buf), fp) != NULL) {
    if (!strncmp(buf, "domain", sizeof("domain") - 1)) {
      cp = buf + sizeof("domain") - 1;
      
      while (*cp == ' ' || *cp == '\t') {
        cp++;
      }

      if (*cp == '\0') {
        continue;
      }

      strncpy(tmp, cp, sizeof(tmp));
      tmp[sizeof(tmp) - 1] = '\0';
      if ((cp = index(tmp, '\n')) != NULL) {
        *cp = '\0';
      }
      [domain setStringValue:(char *)tmp];

      continue;
    }

    if (!strncmp(buf, "search", sizeof("search") - 1)) {
      cp = buf + sizeof("search") - 1;
      
      while (*cp == ' ' || *cp == '\t') {
        cp++;
      }

      if (*cp == '\0') {
        continue;
      }

      strncpy(tmp, cp, sizeof(tmp));
      tmp[sizeof(tmp) - 1] = '\0';
      if ((cp = index(tmp, '\n')) != NULL) {
        *cp = '\0';
      }
      [search setStringValue:(char *)tmp];

      continue;
    }
    
    if (!strncmp(buf, "nameserver", sizeof("nameserver") - 1)) {
      cp = buf + sizeof("nameserver") - 1;
      
      while (*cp == ' ' || *cp == '\t') {
        cp++;
      }

      if (*cp == '\0') {
        continue;
      }

      strncpy(tmp, cp, sizeof(tmp));
      tmp[sizeof(tmp) - 1] = '\0';
      if ((cp = index(tmp, '\n')) != NULL) {
        *cp = '\0';
      }
      [servers addObject:[[String alloc] initWithString:(char *)tmp]];

      continue;
    }
  }
  fclose(fp);

  return YES;
}

BOOL
get_dns_config(NetInfo *ni, String *domain, String *search, List *servers)
{
  HashTable   *result  = NULL;
  BOOL         ok      = NO;
  size_t       count   = 0;
  const void  *key     = NULL;
  const void  *value   = NULL;
  NXHashState  state;

  result = [[HashTable allocFromZone:NXDefaultMallocZone()]
             initKeyDesc:"@"
               valueDesc:"@"
                capacity:0];
  
  ok = [ni connect];
  if (ok == NO) {
    return get_resolv_conf(domain, search, servers);
  }

  ok = [ni getDirectory:"/locations/resolver"
                toTable:result];
  if (ok == NO) {
    return get_resolv_conf(domain, search, servers);
  }

  state = [result initState];
  while ([result nextState:&state
                       key:&key
                     value:&value])
  {
    String *kval = (String *)key;
    List   *vlst = (List *)value;
    size_t  i    = 0;

    count = [vlst count];

    if (count > 0) {
      if        ([kval isEqualToCString: keyDomain]) {
        [domain takeCopyFrom:[vlst objectAt:0]];
      } else if ([kval isEqualToCString:keySearch]) {
        [search takeCopyFrom:[vlst objectAt:0]];
      } else if ([kval isEqualToCString:keyServer]) {
        for (i = 0; i < count; ++i) {
          [servers addObject:[[String alloc] initWithCopy:[vlst objectAt:i]]];
        }
      }
    }
  }

  [result freeObjects];
  [result free];

  return YES;
}

int
get_host_ip(char **buf)
{
  char            result[MAX_CALLBUFLEN] = { 0 };
  struct hostent *ent                    = NULL;
  struct in_addr  addr;

  if (gethostname(result, MAX_CALLBUFLEN) == -1) {
    perror("gethostname()");
    return 0;
  }

  ent = gethostbyname(result);
  if (ent == NULL) {
    fprintf(stderr, "Could not get address for host `%s'\n", result);
    return 0;
  }

  bcopy(ent->h_addr_list[0], (char *)&addr, sizeof(struct in_addr));

  return asprintf(buf, "IP: %s", inet_ntoa(addr));
}

/* HostInfo.m ends here. */
