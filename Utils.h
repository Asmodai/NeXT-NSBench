/* -*- ObjC -*-
 * Utils.h --- Utilities interface.
 *
 * Copyright (c) 2023 Paul Ward <asmodai@gmail.com>
 *
 * Author:     Paul Ward <asmodai@gmail.com>
 * Maintainer: Paul Ward <asmodai@gmail.com>
 * Created:    Thu, 26 Jan 2023 10:25:38 +0000 (GMT)
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

#ifndef _Utils_h_
#define _Utils_h_

#import <stdio.h>
#import <stdarg.h>

#import <sys/types.h>

typedef double TimeInterval;

extern const TimeInterval TimeIntervalSince1970;

int vsnprintf(char *, size_t, const char *, va_list);
int vasprintf(char **, const char *, va_list);
int snprintf(char *, size_t, const char *, ...);
int asprintf(char **, const char *, ...);

char *strdup(const char *);
char *safe_strdup(const char *);

void pretty_bytes(char **, double);
void debug_print(size_t, const char *, ...);

int alertf(const char *,
           const char *,
           const char *,
           const char *,
           const char *,
           ...);

TimeInterval current_time_in_ms(void);
void         sleep_for_time_interval(TimeInterval);

#endif /* !_Utils_h_ */

/* Utils.h ends here. */
