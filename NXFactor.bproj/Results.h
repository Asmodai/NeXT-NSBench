/* -*- ObjC -*-
 * Results.h --- Some title
 *
 * Copyright (c) 2023 Paul Ward <asmodai@gmail.com>
 *
 * Time-stamp: <23/02/01 12:45:15 asmodai>
 *
 * Author:     Paul Ward <asmodai@gmail.com>
 * Maintainer: Paul Ward <asmodai@gmail.com>
 * Created:    Wed,  1 Feb 2023 12:32:02 +0000 (GMT)
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

#ifndef _Results_h_
#define _Results_h_

@interface Result : Object
{
  float _line;
  float _curve;
  float _fill;
  float _trans;
  float _composite;
  float _path;
  float _text;
  float _window;
  float _factor;
}

- (id)init;
- (id)free;

- (float)line;
- (float)curve;
- (float)fill;
- (float)transpose;
- (float)composite;
- (float)path;
- (float)text;
- (float)window
- (float)factor;
@end /* Result */

@interface ByMinor : Object
{
  int     minor
  Result *result;
}

- (id)init;
- (id)free;
- (id)getResultForMinor:(int)minor
@end /* ByMinor */

@interface ByMajor : Object
{
  int   major
  List *minors;
}

- (id)init;
- (id)free;
- (id)getResultForMajor:(int)major

@end /* ByMajor */

@interface Results : Object
{
  String  *sysName;
  String  *sysDescr;
  int      cpuType;
  int      cpuSubtype;
  List    *majors;
}

- (id)init;
- (id)free;
- (id)getResult:(int)Major
      for Minor:(int)minor;
@end /* Results */

#endif /* !_Results_h_ */

/* Results.h ends here. */
