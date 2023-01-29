/*
 * String.h --- String data type interface.
 *
 * Copyright (c) 2015-2023 Paul Ward <asmodai@gmail.com>
 *
 * Author:     Paul Ward <asmodai@gmail.com>
 * Maintainer: Paul Ward <asmodai@gmail.com>
 * Created:    Tue,  3 Nov 2015 01:26:55 +0000 (GMT)
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
 * This class is not meant as a replacement for MiscString or NSString,
 * but just as a simple string implementation that can be used on any
 * NeXT platform without having to have either OpenStep's foundation or
 * MiscKit.
 */
/* }}} */

#import <objc/Object.h>
#import "Object+Debug.h"

#import <appkit/Text.h>

#import <sys/types.h>

#import "Utils.h"

/*
 * Simple string class implementation.  This is partially based on the
 * MiscString implementation.
 *
 * It is not meant as a drop-in for either MiscString or NSString.
 */
@interface String : Object
{
  char   *_buffer;              // String buffer.
  size_t  _length;              // Length of string.
  size_t  _capacity;            // Capacity of buffer.
}

/*
 * Initialisation.
 */
- (id)init;
- (id)initWithCapacity:(size_t)capacity;
- (id)initWithCapacity:(size_t)capacity
              fromZone:(NXZone *)zone;
- (id)initWithString:(const char *)string;
- (id)initWithCopy:(String *)other;
- (id)initFromFormat:(const char *)fmt, ...;

/*
 * Allocation.
 */
- (id)allocateBuffer:(size_t)size;
- (id)allocateBuffer:(size_t)size
            fromZone:(NXZone *)zone;

/*
 * Copying.
 */
- (char *)getCopyInto:(char *)buf;
- (void)takeCopyFrom:(String *)other;

/*
 * Destruction.
 */
- (id)free;
- (id)freeString;

/*
 * Predicates.
 */
- (BOOL)isEmpty;

/*
 * Character methods.
 */
- (char)charAt:(size_t)index;
- (size_t)numOfChar:(char)aChar;
- (size_t)numOfChar:(char)aChar
      caseSensitive:(BOOL)sense;
- (size_t)numOfChars:(const char *)aString;
- (size_t)numOfChars:(const char *)aString
       caseSensitive:(BOOL)sense;
- (int)spotOf:(char)aChar;
- (int)spotOf:(char)aChar
caseSensitive:(BOOL)sense;
- (int)spotOf:(char)aChar
   occurrence:(int)occurrence
caseSensitive:(BOOL)sense;

/*
 * Length.
 */
- (size_t)length;
- (size_t)recalcLength;
- (id)fixStringLength;
- (id)fixStringLengthAt:(size_t)index;

/*
 * Capacity.
 */
- (id)setCapacity:(size_t)capacity;
- (size_t)capacity;

/*
 * Accessors.
 */
- (void)setStringValue:(const char *)string;
- (void)setStringValue:(const char *)string
              fromZone:(NXZone *)zone;
- (const char *)stringValue;
- (NXAtom)uniqueStringValue;
- (unsigned long)intValue;
- (float)floatValue;

/*
 * Equality.
 */
- (BOOL)isEqual:(id)anObject;
- (BOOL)isEqualToCString:(const char *)string;
- (BOOL)isEqualToCString:(const char *)string
                  length:(size_t)len;

/*
 * Case conversion.
 */
- (id)toLower;
- (id)toUpper;

/*
 * Fields.
 */
- (id)left:(size_t)count
  fromZone:(NXZone *)zone;
- (id)right:(size_t)count
   fromZone:(NXZone *)zone;
- (id)left:(size_t)count;
- (id)right:(size_t)count;

/*
 * Insertion.
 */
- (id)cat:(const char *)aString;
- (id)cat:(const char *)aString
   length:(size_t)n;
- (id)cat:(const char *)aString
   length:(size_t)n
 fromZone:(NXZone *)zone;
- (id)concatenate:(id)strings, ...;
- (id)insert:(const char *)aString
          at:(size_t)index;
- (id)insert:(const char *)aString;
- (id)insertString:(id)sender;
- (id)insertString:(id)sender
                at:(size_t)index;
- (id)insertFromFormat:(const char *)format, ...;
- (id)insertAt:(size_t)index
    fromFormat:(const char *)format, ...;
- (id)insertAt:(size_t)index
    fromFormat:(const char *)format
     arguments:(va_list)args;

/*
 * Hash methods.
 */
- (unsigned int)hash;

@end                            // String

@interface String (Debug)

/*
 * Debugging.
 */
- (void)_printDebugInfo:(int)indent;

@end                            // String (Debug)

/* String.h ends here */
/*
 * Local Variables: ***
 * mode: objc ***
 * indent-tabs-mode: nil ***
 * End: ***
 */
