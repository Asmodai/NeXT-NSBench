/* -*- ObjC -*-
 * HostInfo.h  --- Some title
 *
 * Copyright (c) 2023 Paul Ward <asmodai@gmail.com>
 *
 * Time-stamp: <23/01/28 20:17:56 asmodai>
 *
 * Author:     Paul Ward <asmodai@gmail.com>
 * Maintainer: Paul Ward <asmodai@gmail.com>
 * Created:    Sat, 28 Jan 2023 07:17:31 +0000 (GMT)
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

#ifndef _HostInfo_h_
#define _HostInfo_h_

#import <objc/Object.h>
#import <objc/List.h>

#import "../NetInfo.h"
#import "../String.h"

int   get_hostname(char **);
int   get_domainname(char **);
BOOL  get_resolv_conf(String *, String *, List *);
BOOL  get_dns_config(NetInfo *, String *, String *, List *);
int   get_host_ip(char **);

#endif /* !_HostInfo_h_ */

/* HostInfo.h ends here. */
