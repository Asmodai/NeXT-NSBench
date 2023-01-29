/*
 * String.m --- String implementation.
 *
 * Copyright (c) 2015-2023 Paul Ward <asmodai@gmail.com>
 *
 * Author:     Paul Ward <asmodai@gmail.com>
 * Maintainer: Paul Ward <asmodai@gmail.com>
 * Created:    Tue,  3 Nov 2015 01:52:25 +0000 (GMT)
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

#import <stdio.h>
#import <stdlib.h>
#import <unistd.h>
#import <libc.h>
#import <string.h>

#import <objc/objc-runtime.h>
#import <appkit/NXCType.h>

#import "String.h"
#import "Malloc.h"
#import "Utils.h"
#import "Object+Debug.h"

#define MIN_STRING_BUFFER_SIZE    15

@implementation String


- (id)init
{
  if ((self = [super init]) != nil) {
    _length   = 0;
    _capacity = 0;
    _buffer   = NULL;

    [self allocateBuffer:MIN_STRING_BUFFER_SIZE
                fromZone:[self zone]];
  }

  return self;
}

- (id)initWithCapacity:(size_t)capacity
{
  return [self initWithCapacity:capacity
                       fromZone:[self zone]];
}

- (id)initWithCapacity:(size_t)capacity
              fromZone:(NXZone *)zone
{
  [self init];

  if (self) {
    [self allocateBuffer:capacity
                fromZone:zone];
  }

  return self;
}

- (id)initWithString:(const char *)string
{
  [self init];

  if (self) {
    [self setStringValue:string];
  }

  return self;
}

- (id)initWithCopy:(String *)other
{
  [self init];

  if (self) {
    [self setStringValue:[other stringValue]];
  }

  return self;
}

- (id)initFromFormat:(const char *)fmt, ...
{
  va_list  ap;
  char    *buf = NULL;

  va_start(ap, fmt);
  vasprintf(&buf, fmt, ap);
  va_end(ap);

  [self initWithString:buf];
  xfree(buf);

  return self;
}

- (id)allocateBuffer:(size_t)size
{
  return [self allocateBuffer:size
                     fromZone:[self zone]];
}

- (id)allocateBuffer:(size_t)size
            fromZone:(NXZone *)zone
{
  if (size <= _capacity) {
    return self;
  }

  [self freeString];

  if (!size) {
    return self;
  }

  _capacity     = size + 1;
  _buffer       = (char *)xzonemalloc(zone, _capacity);
  bzero(_buffer, _capacity);

  return self;
}

- (char *)getCopyInto:(char *)buf
{
  if (!buf) {
    buf = xzonemalloc([self zone], (_length + 1) * sizeof *buf);
  }

  strncpy(buf, _buffer, _length);

  return buf;
}

- (void)takeCopyFrom:(String *)other
{
  [self setStringValue:[other stringValue]];
}

- (id)freeString
{
  if (_buffer) {
    xzonefree([self zone], _buffer);
  }

  _buffer   = NULL;
  _length   = 0;
  _capacity = 0;

  return self;
}

- (id)free
{
  [self freeString];

  return [super free];
}

- (BOOL)isEmpty
{
  return _length > 0 ? NO : YES;
}

- (char)charAt:(size_t)index
{
  if (index > _length - 1) {
    return '\0';
  }

  return (char)_buffer[index];
}

- (size_t)numOfChar:(char)aChar
{
  return [self numOfChar:aChar
           caseSensitive:YES];
}

- (size_t)numOfChar:(char)aChar
      caseSensitive:(BOOL)sense
{
  register size_t idx = 0;
  register size_t cnt = 0;

  if (sense) {
    for (idx = 0; idx < _length; idx++) {
      if (_buffer[idx] == aChar) {
        cnt++;
      }
    }
  } else {
    for (idx = 0; idx < _length; idx++) {
      if (NXToUpper(_buffer[idx]) == NXToUpper(aChar)) {
        cnt++;
      }
    }
  }

  return cnt;
}

- (size_t)numOfChars:(const char *)aString
{
  return [self numOfChars:aString
            caseSensitive:YES];
}

- (size_t)numOfChars:(const char *)aString
       caseSensitive:(BOOL)sense
{
  register size_t idx    = 0;
  register size_t cnt    = 0;
  id              tmpStr = nil;

  if (!aString) {
    return 0;
  }

  tmpStr = [[String alloc] initWithString:aString];

  for (idx = 0; idx < _length; idx++) {
    if ([tmpStr spotOf:_buffer[idx] caseSensitive:sense] != -1) {
      cnt++;
    }
  }
  [tmpStr free];

  return cnt;
}

- (size_t)length
{
  return _length;
}

- (size_t)recalcLength
{
  if (_buffer) {
    _length = strlen(_buffer);
  } else {
    _length = 0;
  }

  return _length;
}

- (id)fixStringLength
{
  char *tmp = NULL;

  tmp = NXCopyStringBufferFromZone(_buffer, [self zone]);
  if (!tmp) {
    return nil;
  }

  [self freeString];

  _buffer   = tmp;
  _length   = strlen(_buffer);
  _capacity = _length + 1;

  return self;
}

- (id)fixStringLengthAt:(size_t)index
{
  if (!_buffer) {
    return self;
  }

  if (_length <= index) {
    return self;
  }

  _buffer[index] = '\0';
  _length        = index;

  [self fixStringLength];

  return self;
}

- (id)setCapacity:(size_t)capacity
{
  char *tmp = NULL;

  tmp = NXCopyStringBufferFromZone(_buffer, [self zone]);
  if (!tmp) {
    return nil;
  }

  [self allocateBuffer:capacity
              fromZone:[self zone]];

  [self setStringValue:tmp
              fromZone:[self zone]];

  free(tmp);

  return self;
}

- (size_t)capacity
{
  return _capacity;
}

- (void)setStringValue:(const char *)string
{
  [self setStringValue:string
              fromZone:[self zone]];
}

- (void)setStringValue:(const char *)string
              fromZone:(NXZone *)zone
{
  int len;

  if (!string) {
    return;
  }

  len = strlen(string);
  [self allocateBuffer:(len + 1)
              fromZone:zone];

  strcpy(_buffer, string);
  _length = len;
}

- (const char *)stringValue
{
  return _buffer;
}

- (NXAtom)uniqueStringValue
{
  return NXUniqueString(_buffer);
}

- (unsigned long)intValue
{
  if (!_buffer) {
    return 0;
  }

  return (unsigned long)atoi(_buffer);
}

- (float)floatValue
{
  if (!_buffer) {
    return 0.0;
  }

  return (float)atof(_buffer);
}

- (BOOL)isEqual:(id)anObject
{
  if (anObject == self) {
    return YES;
  }

  if ([anObject respondsTo:@selector(stringValue)]) {
    if (strcmp(_buffer, [anObject stringValue]) == 0) {
      return YES;
    }
  }

  return NO;
}

- (BOOL)isEqualToCString:(const char *)string
{
  if (strncmp(_buffer, string, strlen(string)) == 0) {
    return YES;
  }

  return NO;
}

- (BOOL)isEqualToCString:(const char *)string
                  length:(size_t)len
{
  if (strncmp(_buffer, string, len) == 0) {
    return YES;
  }

  return NO;
}

- (unsigned int)hash
{
  return NXStrHash(NULL, _buffer);
}

/*
 * This method is case sensitive.
 */
- (int)spotOf:(char)aChar
{
  return [self spotOf:aChar
           occurrence:0
        caseSensitive:YES];
}

- (int)spotOf:(char)aChar
caseSensitive:(BOOL)sense
{
  return [self spotOf:aChar
           occurrence:0
        caseSensitive:YES];
}

- (int)spotOf:(char)aChar
   occurrence:(int)occurrence
caseSensitive:(BOOL)sense
{
  register int cur = -1;
  register int cnt = 0;

  if (occurrence < 0) {
    return -1;
  }

  while ((cur < occurrence) && (cnt < _length)) {
    if (!sense) {
      if (NXToUpper(_buffer[cnt]) == NXToUpper(aChar)) {
        cur++;
      }
    } else {
      if (_buffer[cur] == aChar) {
        cur++;
      }
    }

    cnt++;
  }

  if (cur != occurrence) {
    return -1;
  }

  return cnt - 1;
}

- (id)toLower
{
  if (_buffer) {
    register size_t i = 0;

    for (i = 0; i < _length; i++) {
      _buffer[i] = NXToLower(_buffer[i]);
    }
  }

  return self;
}

- (id)toUpper
{
  if (_buffer) {
    register size_t i = 0;

    for (i = 0; i < _length; i++) {
      _buffer[i] = NXToUpper(_buffer[i]);
    }
  }

  return self;
}

- (id)left:(size_t)count
  fromZone:(NXZone *)zone
{
  char smash = 0;
  id   nstr  = nil;

  if (!_buffer) {
    return nil;
  }

  if (count == 0) {
    return [String new];
  }

  if (count >= _length) {
    return [self copyFromZone:zone];
  }

  nstr           = [[[self class] allocFromZone:zone] init];
  smash          = _buffer[count];
  _buffer[count] = '\0';
  [nstr setStringValue:_buffer fromZone:zone];
  _buffer[count] = smash;

  return nstr;
}

- (id)right:(size_t)count
   fromZone:(NXZone *)zone
{
  id nstr = nil;

  if (!_buffer) {
    return nil;
  }

  if (count == 0) {
    return [String new];
  }

  if (count >= _length) {
    return [self copyFromZone:zone];
  }

  nstr = [[[self class] allocFromZone:zone] init];
  [nstr setStringValue:&_buffer[_length - count] fromZone:zone];

  return nstr;
}

- (id)left:(size_t)count
{
  return [self left:count fromZone:[self zone]];
}

- (id)right:(size_t)count
{
  return [self right:count fromZone:[self zone]];
}

- (id)cat:(const char *)aString
{
  if (!aString) {
    return nil;
  }

  return [self cat:aString
            length:strlen(aString)
          fromZone:[self zone]];
}

- (id)cat:(const char *)aString
   length:(size_t)n
{
  return [self cat:aString
            length:n
          fromZone:[self zone]];
}

- (id)cat:(const char *)aString
   length:(size_t)n
 fromZone:(NXZone *)zone
{
  char   *nBuf  = NULL;
  size_t  nSize = 0;

  if (!(aString || _buffer)) {
    return nil;
  }

  if (!_buffer) {
    char *tBuf = (char *)xzonemalloc(zone, n + 1);

    if (!tBuf) {
      return nil;
    }

    strncpy(tBuf, aString, n);
    tBuf[n] = '\0';
    
    [self setStringValue:tBuf fromZone:zone];
    xzonefree(zone, tBuf);
    
    return self;
  }

  if (!aString) {
    return self;
  }
 
  if (n > strlen(aString)) {
    n = strlen(aString);
  }

  nSize = _length + n + 1;
  if (nSize > _capacity) {
    nBuf    = (char *)xzonemalloc(zone, nSize);
    _capacity = nSize;
    nBuf[0] = '\0';

    strcat(nBuf, _buffer);
    strncat(nBuf, aString, n);
    xzonefree([self zone], _buffer);
    _buffer = nBuf;
  } else {
    strncat(_buffer, aString, n);
  }

  _length = strlen(_buffer);

  return self;
}

/*
 * MUST terminate a list of strings with nil.
 */
- (id)concatenate:(id)strings, ...
{
  id      aString;
  va_list ptr;

  va_start(ptr, strings);
  aString = strings;
  while (aString) {
    if ([aString respondsTo:@selector(stringValue)]) {
      const char *sptr = [aString stringValue];

      [self cat:sptr
         length:([aString respondsTo:@selector(length)]
                 ? [aString length]
                 : strlen(sptr))
       fromZone:[self zone]];
    };
    aString = va_arg(ptr, id);
  }
  va_end(ptr);

  return self;
}

- (id)insert:(const char *)aString
          at:(size_t)index
{
  id t1 = nil;
  id t2 = nil;

  if ((aString == NULL) || (strlen(aString) <= 0)) {
    return self;
  }

  if (index >= _length) {
    return [self cat:aString];
  }

  t1 = [self left:index];
  if (!t1) {
    t1 = [[[self class] alloc] init];
  }

  t2 = [self right:_length - index];
  [[t1 cat:aString] concatenate:t2];
  [self setStringValue:[t1 stringValue]];

  [t1 free];
  [t2 free];

  return self;
}

- (id)insertString:(id)sender
                at:(size_t)index
{
  if (![sender respondsTo:@selector(stringValue)]) {
    return self;
  }

  return [self insert:[sender stringValue] at:index];
}

- (id)insert:(const char *)aString
{
  return [self insert:aString at:0];
}

- (id)insertString:(id)sender
{
  return [self insertString:sender at:0];
}

- (id)insertFromFormat:(const char *)format, ...
{
  va_list args;

  va_start(args, format);
  [self insertAt:0
     fromFormat:format
      arguments:args];
  va_end(args);

  return self;
}

- (id)insertAt:(size_t)index
    fromFormat:(const char *)format, ...
{
  va_list args;

  va_start(args, format);
  [self insertAt:index
      fromFormat:format
       arguments:args];
  va_end(args);

  return self;
}

- (id)insertAt:(size_t)index
    fromFormat:(const char *)format
     arguments:(va_list)args
{
  char *buf = NULL;

  buf = (char *)xzonemalloc([self zone], 1024);

  vsnprintf(buf, 1024, format, args);

  [self insert:buf at:index];
  xzonefree([self zone], buf);

  return self;
}

@end                            //* String

@implementation String (Debug)

/*
 * Prints debugging information.
 */
- (void)_printDebugInfo:(int)indent
{
  debug_print(indent,
              "str       = [%s] (%#x)\n",
              _buffer,
              (unsigned int)_buffer);

  debug_print(indent, "len       = %d\n", _length);
  debug_print(indent, "allocated = %d\n", _capacity);
}

@end                            //* String (Debug)

/* String.m ends here */
/*
 * Local Variables: ***
 * indent-tabs-mode: nil ***
 * End: ***
 */
