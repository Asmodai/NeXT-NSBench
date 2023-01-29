/*
 * next_malloc.c --- NeXT memory management implementation.
 *
 * Copyright (c) 2015-2023 Paul Ward <asmodai@gmail.com>
 *
 * Author:     Paul Ward <asmodai@gmail.com>
 * Maintainer: Paul Ward <asmodai@gmail.com>
 * Created:    Sat,  7 Nov 2015 22:47:55 +0000 (GMT)
 * Keywords:   
 * URL:        Not distributed yet.
 */

/* {{{ License: */
/*
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 *   * The above copyright notice and this permission notice shall be included
 *     in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
 */
/* }}} */

/* {{{ Commentary: */
/*
 *
 */
/* }}} */

#import <stdio.h>
#import <stdlib.h>
#import <unistd.h>
#import <strings.h>

#import <sys/types.h>

#if !defined(HAVE_INCLUDED_OBJC_ZONE)
# define HAVE_INCLUDED_OBJC_ZONE
# import <objc/zone.h>
#endif

inline
void *
xzonemalloc(NXZone *zone, size_t size)
{
  register void *p = NULL;

  if ((p = NXZoneMalloc(zone, size)) == NULL) {
    perror("xzonemalloc");
    exit(EXIT_FAILURE);
  }

  bzero(p, size);

  return p;
}

inline
void *
xzonerealloc(NXZone *zone, void *ptr, size_t n)
{
  if ((ptr = NXZoneRealloc(zone, ptr, n)) == NULL) {
    perror("xzonerealloc");
    exit(EXIT_FAILURE);
  }

  return ptr;
}

inline
void *
xzonecalloc(NXZone *zone, size_t nelems, size_t elemsize)
{
  register void *newmem = NULL;

  newmem = NXZoneCalloc(zone,
                        nelems   ? nelems   : 1,
                        elemsize ? elemsize : 1);
  if (newmem == NULL) {
    perror("xzonecalloc");
    exit(EXIT_FAILURE);
  }

  return newmem;
}

inline
void
xzonefree(NXZone *zone, void *ptr)
{
  if (ptr == NULL) {
    return;
  }

  NXZoneFree(zone, ptr);
}

/* next_malloc.c ends here */
