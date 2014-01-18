//
//  AWFObject.h
//  AnywhereFriends
//
//  Created by Alexander Kolov on 18/01/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

@import Foundation;

#define nilOrObjectForKey(JSON_, KEY_) \
  [[JSON_ objectForKey:KEY_] isEqual:[NSNull null]] ? nil : [JSON_ objectForKey:KEY_]


@interface AWFObject : NSObject


@end
