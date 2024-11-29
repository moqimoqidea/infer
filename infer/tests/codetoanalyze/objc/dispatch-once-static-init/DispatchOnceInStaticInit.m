/*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */
#import <Foundation/Foundation.h>

@interface Manager : NSObject

@end

@implementation Manager

+ (instancetype)getInstance {
  static Manager* manager;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [Manager new];
  });
  return manager;
}

@end

__attribute__((constructor)) static void initializer_test_interproc_bad() {
  [Manager getInstance];
}

void foo_good() { initializer_test_interproc_bad(); }

__attribute__((constructor)) static void initializer_test_intraproc_bad() {
  static Manager* manager;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [Manager new];
  });
}

__attribute__((constructor)) static void
initializer_test_interproc_condition_bad(BOOL flag) {
  if (flag) {
    [Manager getInstance];
  }
}