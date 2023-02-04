/*
 * result.h --- CoreMark results structure.
 *
 * Copyright (c) 2023 Paul Ward <asmodai@gmail.com>
 *
 * Author:     Paul Ward <asmodai@gmail.com>
 * Maintainer: Paul Ward <asmodai@gmail.com>
 * Created:    Fri,  3 Feb 2023 13:06:27 +0000 (GMT)
 */

/* {{{ License: */
/*
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at

 *   http://www.apache.org/licenses/LICENSE-2.0

 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
/* }}} */

/* {{{ Commentary: */
/*
 *
 */
/* }}} */

#ifndef _result_h_
#define _result_h_

#include "stdint.h"

typedef enum {
  RUN_6K_PERFORMANCE = 0,
  RUN_6K_VALIDATION  = 1,
  RUN_PROFILE        = 2,
  RUN_2K_PERFORMANCE = 3,
  RUN_2K_VALIDATION  = 4,
  RUN_INVALID        = 5,
} run_type_t;

typedef struct results_s {
  size_t     coremark_size;
  size_t     total_ticks;
  size_t     total_errors;
  double     total_secs;
  run_type_t run_type;
  int        mem_type;
  size_t     iterations;
  double     iterations_per_sec;
  uint16_t   seed_crc;
  uint16_t   list_crc;
  uint16_t   matrix_crc;
  uint16_t   state_crc;
  uint16_t   final_crc;
  uint8_t    correct;
  double     score;
} results_t;

#endif /* !_result_h_ */

/* result.h ends here */
