//
//  AWFAppDelegate+AWFFacebookSDK.h
//  AnywhereFriends
//
//  Created by Alexander Kolov on 19/05/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "AWFAppDelegate.h"

#import <FacebookSDK/FacebookSDK.h>

@interface AWFAppDelegate (AWFFacebookSDK)

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;

@end
