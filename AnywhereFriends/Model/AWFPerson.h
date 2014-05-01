//
//  AWFPerson.h
//  AnywhereFriends
//
//  Created by Alexander Kolov on 30/03/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

@import CoreLocation;

#import "_AWFPerson.h"

typedef NS_ENUM(NSUInteger, AWFBodyBuild) {
  AWFBodyBuildUnknown,
  AWFBodyBuildSlim,
  AWFBodyBuildAverage,
  AWFBodyBuildAthletic,
  AWFBodyBuildExtraPounds
};

typedef NS_ENUM(NSUInteger, AWFHairLength) {
  AWFHairLengthUnknown,
  AWFHairLengthShort,
  AWFHairLengthMedium,
  AWFHairLengthLong
};

typedef NS_ENUM(NSUInteger, AWFFriendshipStatus) {
  AWFFriendshipStatusNone,
  AWFFriendshipStatusPending,
  AWFFriendshipStatusFriend
};

@interface AWFPerson : _AWFPerson

@property (nonatomic, readonly) NSNumber *age;
@property (nonatomic, readonly) NSString *fullName;
@property (nonatomic, readonly) NSString *abbreviatedName;
@property (nonatomic, readonly) NSString *locationName;
@property (nonatomic, readonly) CLLocationCoordinate2D locationCoordinate;

@end
