/* -*- ObjC -*-
 * Utils.m --- Utility implementation.
 *
 * Copyright (c) 2023 Paul Ward <asmodai@gmail.com>
 *
 * Author:     Paul Ward <asmodai@gmail.com>
 * Maintainer: Paul Ward <asmodai@gmail.com>
 * Created:    Fri, 27 Jan 2023 12:43:44 +0000 (GMT)
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
#import <stdarg.h>
#import <math.h>

#import <sys/types.h>

#import <appkit/nextstd.h>
#import <appkit/Panel.h>

#import "Malloc.h"
#import "Utils.h"

#if !defined(HAVE_INCLUDED_OBJC_ZONE)
# define HAVE_INCLUDED_OBJC_ZONE
# import <objc/zone.h>
#endif

const TimeInterval TimeIntervalSince1970 = 978307200.0;

void
pretty_bytes(char **buf, double bytes)
{
  static const char *suffixes[] = {
    "B", "KB", "MB", "GB", "TB", "PB", "EB"
  };

  size_t sfx   = 0;
  double count = bytes;

  while (count >= 1024 && sfx < 7) {
    sfx++;
    count /= 1024;
  }

  if (count - floor(count) == 0.0) {
    asprintf(buf, "%d%s", (int)count, suffixes[sfx]);
    return;
  }

  asprintf(buf, "%0.2f%s", count, suffixes[sfx]);
}

int
vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
{
  NXStream *stream = NULL;
  int length = 0;

  stream = NXOpenMemory(NULL, 0, NX_READWRITE);
  NXVPrintf(stream, fmt, args);
  NXFlush(stream);

  NXSeek(stream, 0, NX_FROMEND);
  length = NXTell(stream);

  if (length == 0) {
    NXCloseMemory(stream, NX_FREEBUFFER);
    return 0;
  }

  if (length > size) {
    length = size;
  }

  NXSeek(stream, 0, NX_FROMSTART);
  NXRead(stream, buf, length);
  NXCloseMemory(stream, NX_FREEBUFFER);

  buf[length] = '\0';

  return length;
}

int
vasprintf(char **buf, const char *fmt, va_list args)
{
  NXStream *stream = NULL;
  int       length = 0;

  stream = NXOpenMemory(NULL, 0, NX_READWRITE);
  NXVPrintf(stream, fmt, args);
  NXFlush(stream);

  NXSeek(stream, 0, NX_FROMEND);
  length = NXTell(stream);

  if (length == 0) {
    NXCloseMemory(stream, NX_FREEBUFFER);
    return 0;
  }

  NXSeek(stream, 0, NX_FROMSTART);
  // Prefer xmalloc over NX_MALLOC due to error handling.
  *buf = xmalloc((length + 1) * sizeof(char));

  NXRead(stream, *buf, length);
  NXCloseMemory(stream, NX_FREEBUFFER);

  return length;
}

int
snprintf(char *buf, size_t size, const char *fmt, ...)
{
  va_list ap;
  size_t  res = 0;

  va_start(ap, fmt);
  res = vsnprintf(buf, size, fmt, ap);
  va_end(ap);

  return (int)res;
}

int
asprintf(char **strp, const char *fmt, ...)
{
  va_list ap;
  size_t  res = 0;

  va_start(ap, fmt);
  res = vasprintf(strp, fmt, ap);
  va_end(ap);

  return (int)res;
}

int
alertf(const char *title,
       const char *optD,
       const char *opt1,
       const char *opt2,
       const char *fmt,
       ...)
{
  va_list  ap;
  char    *buf = NULL;

  va_start(ap, fmt);
  vasprintf(&buf, fmt, ap);
  va_end(ap);
  
  return NXRunAlertPanel(title, buf, optD, opt1, opt2);
}

char *
strdup(const char *str)
{
  size_t  len  = 0;
  char   *copy = NULL;

  len  = strlen(str) + 1;
  copy = (char *)xmalloc(len);

  return memcpy(copy, str, len);
}

char *
safe_strdup(const char *str)
{
  char *t = 0;

  if (str != 0) {
    t = NXCopyStringBufferFromZone(str, NXDefaultMallocZone());
  }

  return t;
}

void
debug_print(size_t indent, const char *fmt, ...)
{
  va_list ap;
  size_t  i  = 0;

  for (i = 0; i < indent; ++i) {
    fputc(' ', stdout);
  }

  va_start(ap, fmt);
  vfprintf(stdout, fmt, ap);
  va_end(ap);
}

/*
 * Support function for sleep_for_time_interval
 */
TimeInterval
internalTimeNow(void)
{
  TimeInterval   t  = 0.0;
  struct timeval tp = { 0 };

  gettimeofday(&tp, NULL);

  t  = (TimeInterval)tp.tv_sec - TimeIntervalSince1970;
  t += (TimeInterval)tp.tv_usec / (TimeInterval)1000000.0;

  return t;
}

/*
 * Support function for sleep_for_time_interval
 */
void
internalSleepUntilInterval(TimeInterval when)
{
  TimeInterval delay = 0.0;

  delay = when - internalTimeNow();
  if (delay <= 0.0) {
    sleep(0);
    return;
  }

  while (delay > 1800.0) {
    sleep(1800);
    delay = when - internalTimeNow();
  }

  while (delay > 0) {
    usleep((int)(delay * 1000000));
    delay = when - internalTimeNow();
  }
}

TimeInterval
current_time_in_ms(void)
{
  struct timeval cur = { 0 };

  gettimeofday(&cur, NULL);

  return ((cur.tv_sec) * 1000 + cur.tv_usec / 1000);
}

void
sleep_for_time_interval(TimeInterval ti)
{
  internalSleepUntilInterval(internalTimeNow() + ti);
}

/* Utils.m ends here. */
