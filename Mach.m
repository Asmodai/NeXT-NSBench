/* -*- ObjC -*-
 * Mach.m --- Mach message proxy implementation.
 *
 * Copyright (c) 2023 Paul Ward <asmodai@gmail.com>
 *
 * Author:     Paul Ward <asmodai@gmail.com>
 * Maintainer: Paul Ward <asmodai@gmail.com>
 * Created:    Fri, 27 Jan 2023 20:32:15 +0000 (GMT)
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

#import "Mach.h"

#import <libc.h>

#import <sys/types.h>
#import <sys/vfs.h>

#import <mach/mach.h>
#import <mach/vm_statistics.h>
#import <mach/host_info.h>
#import <mach/mach_host.h>
#import <mach/mach_error.h>

#import "Malloc.h"
#import "Utils.h"

static Mach *sharedMach = nil;

@implementation Mach

+ (id)sharedInstance
{
  if (sharedMach == nil) {
    [Mach initialize];
  }

  return sharedMach;
}

+ (void)initialize
{
  if (self == [Mach class]) {
    sharedMach = [[self alloc] init];
  }
}

- (id)init
{
  return [super init];
}

/* This isn't really a Mach call... but, meh. */
- (int)host_id
{
  return gethostid();
}

- (void)kernel_version:(kernel_version_t *)data
{
  kern_return_t kret = 0;

  kret = host_kernel_version(host_self(), data);
  if (kret != KERN_SUCCESS) {
    mach_error("host_kernel_version() failed", kret);
    exit(EXIT_FAILURE);
  }
}

- (void)cpu_type:(char **)cpuType
         subtype:(char **)cpuSubtype
{
  struct host_basic_info kbi   = { 0 };
  kern_return_t          kret  = 0;
  unsigned int           count = HOST_BASIC_INFO_COUNT;

  kret = host_info(host_self(), HOST_BASIC_INFO, (host_info_t)&kbi, &count);
  if (kret != KERN_SUCCESS) {
    mach_error("host_info() failed", kret);
    exit(EXIT_FAILURE);
  }

  /*
   * Rather than using `slot_name', we do things manually so we can
   * have tighter control over what gets returned.
   */
  switch (kbi.cpu_type) {
    /*
     * Motorola 68k
     */
    case CPU_TYPE_MC680x0:
      asprintf(cpuType, "Motorola 680x0");
      switch (kbi.cpu_subtype) {
        case CPU_SUBTYPE_MC68030:
          asprintf(cpuSubtype, "Motorola 68030");
          break;
        case CPU_SUBTYPE_MC68040:
          asprintf(cpuSubtype, "Motorola 68040");
          break;
        default:
          asprintf(cpuSubtype, "Motorola 680x0");
      }
      break;

      /*
       * Intel IA-32.
       */
    case CPU_TYPE_I386:
      asprintf(cpuType, "Intel IA-32");
      switch (kbi.cpu_subtype) {
        case CPU_SUBTYPE_386:
          asprintf(cpuSubtype, "Intel i386");
          break;
        case CPU_SUBTYPE_486:
          asprintf(cpuSubtype, "Intel i486");
          break;
        case CPU_SUBTYPE_486SX:
          asprintf(cpuSubtype, "Intel i486SX");
          break;
        case CPU_SUBTYPE_586:
          asprintf(cpuSubtype, "Intel i586");
          break;
        case CPU_SUBTYPE_586SX:
          asprintf(cpuSubtype, "Intel i586SX");
          break;
        default:
          asprintf(cpuSubtype, "Intel i386");
      }
      break;

      /*
       * HP PA-RISC.
       */
    case CPU_TYPE_HPPA:
      asprintf(cpuType, "PA-RISC");
      switch (kbi.cpu_subtype) {
        case CPU_SUBTYPE_HPPA_7100:
          asprintf(cpuSubtype, "HP PA-RISC 7100");
          break;
        case CPU_SUBTYPE_HPPA_7100LC:
          asprintf(cpuSubtype, "HP PA-RISC 7100LC");
          break;
        default:
          asprintf(cpuSubtype, "HP PA-RISC");
      }
      break;
      
      /*
       * Sun SPARC.
       */
    case CPU_TYPE_SPARC:
      // SPARC's CPU type will probably be `generic' on a SPARCstation.
      // The name `Sun SPARC' is also misleading :)
      asprintf(cpuType,    "Sun SPARC");
      asprintf(cpuSubtype, "Sun SPARC");
      break;

    default:
      asprintf(cpuType,    "Unknown");
      asprintf(cpuSubtype, "Unknown");
  }
}

- (void)vm_statistics:(vm_statistics_data_t *)data
{
  kern_return_t kret = 0;

  kret = vm_statistics(task_self(), data);
  if (kret != KERN_SUCCESS) {
    mach_error("vm_statistics() failed", kret);
    exit(EXIT_FAILURE);
  }
}

- (void)machine_info:(machine_info_data_t *)data
{
  kern_return_t kret = 0;

  kret = xxx_host_info(task_self(), data);
  if (kret != KERN_SUCCESS) {
    mach_error("xxx_host_info() failed", kret);
    exit(EXIT_FAILURE);
  }
}

@end /* Mach */

/* Mach.m ends here. */
