//
//  AWFСonfig.h
//  AnywhereFriends
//
//  Created by Alexander Kolov on 15/03/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

@import Darwin.POSIX.libgen;
@import Foundation;
@import UIKit;

#import <AXKViewLayout/UIView+AXKViewLayout.h>

#import <AXKRACExtensions/NSNotificationCenter+AXKRACExtensions.h>

#import "AWFConstants.h"
#import "CGContext+Blocks.h"
#import "UIColor+ColorTools.h"
#import "UIColor+CustomColors.h"
#import "UIFont+CustomFonts.h"
#import "UIViewController+AWFNotification.h"
#import "UIViewController+ShownTitle.h"

#ifdef DEBUG
#  define DEBUG_MODE 1
#else
#  define DEBUG_MODE 0
#endif

#ifndef ErrorLog
#define ErrorLog(format, ...) \
  do { \
    if (DEBUG_MODE) { \
      char buf[] = __FILE__; \
      NSLog([@" *** Error (%s:%d:%s): " stringByAppendingString:format], \
        basename(buf), __LINE__, __func__, # __VA_ARGS__); \
      } \
    } while (0)
#endif

#define AWF_METRES_IN_KILOMETRE 1000.0
#define AWF_KILOMETRES_IN_DEGREE 111.32
#define AWF_METRES_IN_DEGREE (AWF_KILOMETRES_IN_DEGREE * AWF_METRES_IN_KILOMETRE)
#define AWF_DEGREES_IN_KILOMETRE (1.0 / AWF_KILOMETRES_IN_DEGREE)
#define AWF_DEGREES_IN_METRE (AWF_DEGREES_IN_KILOMETRE / AWF_METRES_IN_KILOMETRE)

#ifndef AWF_SAFE_CALLBACK
#define AWF_SAFE_CALLBACK(callback, ...) if (callback) {\
  callback(__VA_ARGS__);\
}
#endif
