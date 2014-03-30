//
//  AWFActivity.h
//  AnywhereFriends
//
//  Created by Alexander Kolov on 20/03/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "_AWFActivity.h"

typedef NS_ENUM(NSUInteger, AWFActivityStatus) {
  AWFActivityStatusUnknown = 0,
  AWFActivityStatusUnread = 1,
  AWFActivityStatusRead = 2
};

typedef NS_ENUM(NSUInteger, AWFActivityType) {
  AWFActivityTypeUnknown = 0,
  AWFActivityTypeFriendRequest = 1
};

@interface AWFActivity : _AWFActivity

@end
