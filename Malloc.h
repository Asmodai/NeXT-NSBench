/*
 * memory.h --- NeXT memory interface.
 *
 * Copyright (c) 2015-2023 Paul Ward <asmodai@gmail.com>
 *
 * Author:     Paul Ward <asmodai@gmail.com>
 * Maintainer: Paul Ward <asmodai@gmail.com>
 * Created:    Wed,  4 Nov 2015 02:55:58 +0000 (GMT)
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

#ifndef _Malloc_h_
#define _Malloc_h_

#ifndef HAVE_INCLUDED_OBJC_ZONE
# define HAVE_INCLUDED_OBJC_ZONE
# import <objc/zone.h>
#endif

#import <streams/streams.h>

void *xzonemalloc(NXZone *, size_t);
void *xzonerealloc(NXZone *, void *, size_t);
void *xzonecalloc(NXZone *, size_t, size_t);
void  xzonefree(NXZone *, void *);

/*
 * Set up `xmalloc' as a wrapper around `xzonemalloc'.
 */
#if defined(xmalloc)
#  undef  xmalloc
#endif
#define xmalloc(__n) \
  xzonemalloc(NXDefaultMallocZone(), __n)

/*
 * Set up `xrealloc' as a wrapper around `xzonerealloc'.
 */
#if defined(xrealloc)
# undef xrealloc
#endif
#define xrealloc(__p, __n) \
  xzonerealloc(NXDefaultMallocZone(), __p, __n)

/*
 * Set up `xcalloc' as a wrapper around `xzonecalloc'.
 */
#if defined(xcalloc)
# undef xcalloc
#endif
#define xcalloc(__n, __e) \
  xzonecalloc(NXDefaultMallocZone(), __n, __e)

/*
 * Set up `xfree' as a wrapper around `xzonefree'.
 */
#if defined(xfree)
# undef xfree
#endif
#define xfree(__p) \
  xzonefree(NXDefaultMallocZone(), __p)


/*
 * Free a thing if it is not NULL.
 */
#if defined(MAYBE_FREE)
# undef MAYBE_FREE
#endif
#define MAYBE_FREE(__p) \
  if ((__p) != NULL) {  \
    xfree(__p);         \
    __p = NULL;         \
  }

#ifndef DESTROY
# undef DESTROY
#endif
#define DESTROY(__t)  \
  if ((__t) != nil) { \
    [__t free];       \
    __t = nil;        \
  }

#endif /* !_Malloc_h_ */

/* memory.h ends here */
