/* -*- ObjC -*-
 * Manager.m --- Bundle loader/manager implementation.
 *
 * Copyright (c) 2023 Paul Ward <asmodai@gmail.com>
 *
 * Author:     Paul Ward <asmodai@gmail.com>
 * Maintainer: Paul Ward <asmodai@gmail.com>
 * Created:    Thu, 26 Jan 2023 10:54:38 +0000 (GMT)
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
#import "NetInfo.h"
#import "Manager.h"
#import "BundleManager.h"
#import "UserButtonCell.h"
#import "NSBModule.h"
#import "Utils.h"
#import "String.h"
#import "Platform.h"

#import <objc/List.h>
#import <appkit/appkit.h>
#import <sys/dir.h>
#import <sys/dirent.h>

/* This will go elsewhere at some point. */
#define VERSION "0.4"

static
BOOL
fileNameHasExtension(const char *f, const char *e)
{
  const char *dot = NULL;

  if (f && e && (dot = strrchr(f, '.')) && !strcmp(dot + 1, e)) {
    return YES;
  }

  return NO;
}

@implementation Manager

- appDidInit:sender
{
  String *version;

  version = [[String alloc] initFromFormat:"Version %s", VERSION];

  _lstBundles   = [[List allocFromZone:[self zone]] init];
  _mgrInfo      = [[MatrixManager alloc] init];
  _mgrBenchmark = [[MatrixManager alloc] init];

  [[_mgrInfo      setMatrix:btnsInfo] reset];
  [[_mgrBenchmark setMatrix:btnsBenchmark] reset];
  
  [_mgrInfo      setView:viewInfo];
  [_mgrBenchmark setView:viewBenchmark];

  [(TextField *)txtVersion setStringValue: [version stringValue]];

  [self createBundlesAndLoadModules:NO];
  [self createBundleLists];

  [[viewBenchmark window] makeKeyAndOrderFront:self];
  [[viewBenchmark window] center];

  return self;
}

- free
{
  [viewCurrentBenchmark removeFromSuperview];

  _lstBundles = [[_lstBundles freeObjects] free];
  _lstBundles = NULL;

  return [super free];
}

- createBundlesAndLoadModules:(BOOL)doLoad
{
  char path[MAXPATHLEN + 1];

  strcpy(path, [[NXBundle mainBundle] directory]);

  [_lstBundles freeObjects];

  /* Only care for bundles inside the app wrapper. */
  [self createBundlesForDirectory:path
                      loadModules:doLoad];

  return self;
}

- (id)loadBundle:(BundleManager *)bundle
{
  // Set proxy objects.
  [[bundle module] setMachProxy:[Mach sharedInstance]];
  [[bundle module] setNetInfoProxy:[NetInfo sharedInstance]];
  [[bundle module] setPlatformProxy:[Platform sharedInstance]];

  // Load in the bundle's nib.
  if ([[bundle module] loadNib] == nil) {
    int res = alertf("NSBench Bundle Loader",
                     "Quit",
                     "Ignore",
                     NULL,
                     "Could not load the bundle for '%s'.",
                     [bundle moduleName]);
    if (res == 1) {
      exit(EXIT_FAILURE);
    }
  }

  return self;
}

- createBundlesForDirectory:(const char *)path
                loadModules:(BOOL)doLoad
{
  char           modulePath[MAXPATHLEN + 1] = { 0 };
  char          *modulePathInsert           = NULL;
  DIR           *dir                        = NULL;
  struct direct *dirEntry                   = NULL;
  BundleManager *bundle                     = NULL;

  strcpy(modulePath, path);
  modulePathInsert  = modulePath + strlen(modulePath);
  *modulePathInsert = '/';
  modulePathInsert++;

  dir = opendir(path);
  if (!dir) {
    return self;
  }

  while (dirEntry = readdir(dir)) {
    if (dirEntry->d_name[0] == '.' ||
        !fileNameHasExtension(dirEntry->d_name, "bundle"))
    {
      continue;
    }

    strcpy(modulePathInsert, dirEntry->d_name);
    bundle = [[BundleManager allocFromZone:[self zone]]
               initForDirectory:modulePath];

    [_lstBundles addObjectIfAbsent:bundle];

    if (doLoad) {
      [self loadBundle:bundle];
    }
  }

  closedir(dir);

  return self;
}

- (void)createBundleLists
{
  size_t count = 0;
  size_t i     = 0;


  count = [_lstBundles count];
  for (i = 0; i < count; ++i) {
    BundleManager *b = [_lstBundles objectAt:i];

    if ([b loadFirst]) {
      [_mgrBenchmark addButton:[b moduleImage]
                        module:b
                        action:@selector(benchmarkButtonPressed:)
                        target:self];
      [_mgrInfo addButton:[b moduleImage]
                   module:b
                   action:@selector(infoButtonPressed:)
                   target:self];
      break;
    }
  }

  for (i = 0; i < count; ++i) {
    BundleManager *b = [_lstBundles objectAt:i];

    if ([b loadFirst]) {
      continue;
    }

    [_mgrBenchmark addButton:[b moduleImage]
                      module:b
                      action:@selector(benchmarkButtonPressed:)
                      target:self];
    [_mgrInfo addButton:[b moduleImage]
                 module:b
                 action:@selector(infoButtonPressed:)
                 target:self];
  }

  [wndBenchmark display];
}

- (void)benchmarkButtonPressed:(id)sender
{
  UserButtonCell *btn = (UserButtonCell *)[sender selectedCell];

  if (btn && [_lstBundles indexOf:[btn user]] != NX_NOT_IN_LIST) {
    BundleManager *bndl = (BundleManager *)[btn user];
    id             view = [[bndl module] benchmarkView];
    id             bar  = [[bndl module] buttonBarView];

    if (view == nil) {
      /* Load in bundle and try again. */
      [self loadBundle:bndl];
      view = [[bndl module] benchmarkView];
      bar  = [[bndl module] buttonBarView];
    }

    if (view != nil) {
      [viewBenchmark setContentView:[view contentView]];
    }

    if (bar != nil) {
      [viewButtonBar setContentView:[bar  contentView]];
    }

    [viewBenchmark display];
    [viewButtonBar display];
    [wndBenchmark display];
  }
}

- (void)infoButtonPressed:(id)sender
{
  UserButtonCell *btn = (UserButtonCell *)[sender selectedCell];

  if (btn && [_lstBundles indexOf:[btn user]] != NX_NOT_IN_LIST) {
    BundleManager *b = (BundleManager *)[btn user];
 
    [(TextField *)txtBundleName      setStringValue:[b moduleName]];
    [(TextField *)txtBundleAuthor    setStringValue:[b moduleAuthor]];
    [(TextField *)txtBundleVersion   setStringValue:[b moduleVersion]];
    [(TextField *)txtBundleCopyright setStringValue:[b moduleCopyright]];
    
    [viewInfo setContentView:[viewInfoTemplate contentView]];
  } else {
    [viewInfo setContentView:[viewInfoNotLoaded contentView]];
  }

  [viewInfo display];
  [wndInfo display];

}

- showInfo:sender
{
  [wndInfo makeKeyAndOrderFront:self];
  [_mgrInfo selectFirst];
  [wndInfo display];

  return self;
}

@end /* Manager */

/* Manager.m ends here. */
