//
//  AWFValueTransformers.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 19/01/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "AWFConfig.h"
#import "AWFValueTransformers.h"

#import <TransformerKit/NSValueTransformer+TransformerKit.h>

#import "AWFActivity.h"
#import "AWFGender.h"
#import "AWFPerson.h"

NSString *const AWFBodyBuildValueTransformerName = @"AWFBodyBuildValueTransformerName";
NSString *const AWFEyeColorValueTransformerName = @"AWFEyeColorValueTransformerName";
NSString *const AWFGenderValueTransformerName = @"AWFGenderValueTransformerName";
NSString *const AWFHairColorValueTransformerName = @"AWFHairColorValueTransformerName";
NSString *const AWFHairLengthValueTransformerName = @"AWFHairLengthValueTransformerName";
NSString *const AWFFriendshipStatusTransformerName = @"AWFFriendshipStatusTransformerName";
NSString *const AWFActivityStatusTransformerName = @"AWFActivityStatusTransformerName";
NSString *const AWFActivityTypeTransformerName = @"AWFActivityTypeTransformerName";

static NSString *const AWFBodyBuildSlimName        = @"slim";
static NSString *const AWFBodyBuildAverageName     = @"average";
static NSString *const AWFBodyBuildAthleticName    = @"athletic";
static NSString *const AWFBodyBuildExtraPoundsName = @"extra_pounds";

static NSString *const AWFEyeColorAmberName  = @"amber";
static NSString *const AWFEyeColorBlueName   = @"blue";
static NSString *const AWFEyeColorBrownName  = @"brown";
static NSString *const AWFEyeColorGrayName   = @"gray";
static NSString *const AWFEyeColorGreenName  = @"green";
static NSString *const AWFEyeColorHazelName  = @"hazel";
static NSString *const AWFEyeColorRedName    = @"red";
static NSString *const AWFEyeColorVioletName = @"violet";

static NSString *const AWFGenderMaleName   = @"male";
static NSString *const AWFGenderFemaleName = @"female";

static NSString *const AWFHairColorAuburnName   = @"auburn";
static NSString *const AWFHairColorBlackName    = @"black";
static NSString *const AWFHairColorBlondName    = @"blond";
static NSString *const AWFHairColorBrownName    = @"brown";
static NSString *const AWFHairColorChestnutName = @"chestnut";
static NSString *const AWFHairColorGrayName     = @"gray";
static NSString *const AWFHairColorRedName      = @"red";
static NSString *const AWFHairColorWhiteName    = @"white";

static NSString *const AWFHairLengthShortName  = @"short";
static NSString *const AWFHairLengthMediumName = @"middle";
static NSString *const AWFHairLengthLongName   = @"long";

static NSString *const AWFFriendshipStatusNotFriendName = @"not_friend";
static NSString *const AWFFriendshipStatusFriendName = @"friend";
static NSString *const AWFFriendshipStatusPendingName = @"pending";

static NSString *const AWFActivityStatusUnreadName = @"unread";
static NSString *const AWFActivityStatusReadName = @"read";

static NSString *const AWFActivityTypeFriendRequestName = @"friend_request";

@implementation AWFValueTransformers

+ (void)load {
  @autoreleasepool {

    // Gender

    [NSValueTransformer
     registerValueTransformerWithName:AWFGenderValueTransformerName transformedValueClass:[NSString class]
     returningTransformedValueWithBlock:^id(id value) {
       if (!value || [value isEqual:[NSNull null]]) {
         return @(AWFGenderUnknown);
       }
       else if ([value caseInsensitiveCompare:AWFGenderFemaleName] == NSOrderedSame) {
         return @(AWFGenderFemale);
       }
       else if ([value caseInsensitiveCompare:AWFGenderMaleName] == NSOrderedSame) {
         return @(AWFGenderMale);
       }
       return @(AWFGenderUnknown);
     } allowingReverseTransformationWithBlock:^id(id value) {
       switch ([value unsignedIntegerValue]) {
         case AWFGenderFemale:
           return AWFGenderFemaleName;
         case AWFGenderMale:
           return AWFGenderMaleName;
         default:
           return nil;
       }
     }];

    // Eye Color

    [NSValueTransformer
     registerValueTransformerWithName:AWFEyeColorValueTransformerName transformedValueClass:[NSString class]
     returningTransformedValueWithBlock:^id(id value) {
       if (!value || [value isEqual:[NSNull null]]) {
         return @(AWFEyeColorUnknown);
       }
       else if ([value caseInsensitiveCompare:AWFEyeColorAmberName] == NSOrderedSame) {
         return @(AWFEyeColorAmber);
       }
       else if ([value caseInsensitiveCompare:AWFEyeColorBlueName] == NSOrderedSame) {
         return @(AWFEyeColorBlue);
       }
       else if ([value caseInsensitiveCompare:AWFEyeColorBrownName] == NSOrderedSame) {
         return @(AWFEyeColorBrown);
       }
       else if ([value caseInsensitiveCompare:AWFEyeColorGrayName] == NSOrderedSame) {
         return @(AWFEyeColorGray);
       }
       else if ([value caseInsensitiveCompare:AWFEyeColorGreenName] == NSOrderedSame) {
         return @(AWFEyeColorGreen);
       }
       else if ([value caseInsensitiveCompare:AWFEyeColorHazelName] == NSOrderedSame) {
         return @(AWFEyeColorHazel);
       }
       else if ([value caseInsensitiveCompare:AWFEyeColorRedName] == NSOrderedSame) {
         return @(AWFEyeColorRed);
       }
       else if ([value caseInsensitiveCompare:AWFEyeColorVioletName] == NSOrderedSame) {
         return @(AWFEyeColorViolet);
       }
       return @(AWFEyeColorUnknown);
     } allowingReverseTransformationWithBlock:^id(id value) {
       switch ([value unsignedIntegerValue]) {
         case AWFEyeColorAmber:
           return AWFEyeColorAmberName;
         case AWFEyeColorBlue:
           return AWFEyeColorBlueName;
         case AWFEyeColorBrown:
           return AWFEyeColorBrownName;
         case AWFEyeColorGray:
           return AWFEyeColorGrayName;
         case AWFEyeColorGreen:
           return AWFEyeColorGreenName;
         case AWFEyeColorHazel:
           return AWFEyeColorHazelName;
         case AWFEyeColorRed:
           return AWFEyeColorRedName;
         case AWFEyeColorViolet:
           return AWFEyeColorVioletName;
         default:
           return nil;
       }
     }];

    // Body Build

    [NSValueTransformer
     registerValueTransformerWithName:AWFBodyBuildValueTransformerName transformedValueClass:[NSString class]
     returningTransformedValueWithBlock:^id(id value) {
       if (!value || [value isEqual:[NSNull null]]) {
         return @(AWFBodyBuildUnknown);
       }
       else if ([value caseInsensitiveCompare:AWFBodyBuildSlimName] == NSOrderedSame) {
         return @(AWFBodyBuildSlim);
       }
       else if ([value caseInsensitiveCompare:AWFBodyBuildAverageName] == NSOrderedSame) {
         return @(AWFBodyBuildAverage);
       }
       else if ([value caseInsensitiveCompare:AWFBodyBuildAthleticName] == NSOrderedSame) {
         return @(AWFBodyBuildAthletic);
       }
       else if ([value caseInsensitiveCompare:AWFBodyBuildExtraPoundsName] == NSOrderedSame) {
         return @(AWFBodyBuildExtraPounds);
       }
       return @(AWFBodyBuildUnknown);
     } allowingReverseTransformationWithBlock:^id(id value) {
       switch ([value unsignedIntegerValue]) {
         case AWFBodyBuildSlim:
           return AWFBodyBuildSlimName;
         case AWFBodyBuildAverage:
           return AWFBodyBuildAverageName;
         case AWFBodyBuildAthletic:
           return AWFBodyBuildAthleticName;
         case AWFBodyBuildExtraPounds:
           return AWFBodyBuildExtraPoundsName;
         default:
           return nil;
       }
     }];

    // Hair Color

    [NSValueTransformer
     registerValueTransformerWithName:AWFHairColorValueTransformerName transformedValueClass:[NSString class]
     returningTransformedValueWithBlock:^id(id value) {
       if (!value || [value isEqual:[NSNull null]]) {
         return @(AWFHairColorUnknown);
       }
       else if ([value caseInsensitiveCompare:AWFHairColorAuburnName] == NSOrderedSame) {
         return @(AWFHairColorAuburn);
       }
       else if ([value caseInsensitiveCompare:AWFHairColorBlackName] == NSOrderedSame) {
         return @(AWFHairColorBlack);
       }
       else if ([value caseInsensitiveCompare:AWFHairColorBlondName] == NSOrderedSame) {
         return @(AWFHairColorBlond);
       }
       else if ([value caseInsensitiveCompare:AWFHairColorBrownName] == NSOrderedSame) {
         return @(AWFHairColorBrown);
       }
       else if ([value caseInsensitiveCompare:AWFHairColorChestnutName] == NSOrderedSame) {
         return @(AWFHairColorChestnut);
       }
       else if ([value caseInsensitiveCompare:AWFHairColorGrayName] == NSOrderedSame) {
         return @(AWFHairColorGray);
       }
       else if ([value caseInsensitiveCompare:AWFHairColorRedName] == NSOrderedSame) {
         return @(AWFHairColorRed);
       }
       else if ([value caseInsensitiveCompare:AWFHairColorWhiteName] == NSOrderedSame) {
         return @(AWFHairColorWhite);
       }
       return @(AWFHairColorUnknown);
     } allowingReverseTransformationWithBlock:^id(id value) {
       switch ([value unsignedIntegerValue]) {
         case AWFHairColorAuburn:
           return AWFHairColorAuburnName;
         case AWFHairColorBlack:
           return AWFHairColorBlackName;
         case AWFHairColorBlond:
           return AWFHairColorBlondName;
         case AWFHairColorBrown:
           return AWFHairColorBrownName;
         case AWFHairColorChestnut:
           return AWFHairColorChestnutName;
         case AWFHairColorGray:
           return AWFHairColorGrayName;
         case AWFHairColorRed:
           return AWFHairColorRedName;
         case AWFHairColorWhite:
           return AWFHairColorWhiteName;
         default:
           return nil;
       }
     }];

    // Hair Length

    [NSValueTransformer
     registerValueTransformerWithName:AWFHairLengthValueTransformerName transformedValueClass:[NSString class]
     returningTransformedValueWithBlock:^id(id value) {
       if (!value || [value isEqual:[NSNull null]]) {
         return @(AWFHairLengthUnknown);
       }
       else if ([value caseInsensitiveCompare:AWFHairLengthShortName] == NSOrderedSame) {
         return @(AWFHairLengthShort);
       }
       else if ([value caseInsensitiveCompare:AWFHairLengthMediumName] == NSOrderedSame) {
         return @(AWFHairLengthMedium);
       }
       else if ([value caseInsensitiveCompare:AWFHairLengthLongName] == NSOrderedSame) {
         return @(AWFHairLengthLong);
       }
       return @(AWFHairLengthUnknown);
     } allowingReverseTransformationWithBlock:^id(id value) {
       switch ([value unsignedIntegerValue]) {
         case AWFHairLengthShort:
           return AWFHairLengthShortName;
         case AWFHairLengthMedium:
           return AWFHairLengthMediumName;
         case AWFHairLengthLong:
           return AWFHairLengthLongName;
         default:
           return nil;
       }
     }];

    // Friendship

    [NSValueTransformer
     registerValueTransformerWithName:AWFFriendshipStatusTransformerName transformedValueClass:[NSString class]
     returningTransformedValueWithBlock:^id(id value) {
       if (!value || [value isEqual:[NSNull null]]) {
         return @(AWFFriendshipStatusNone);
       }
       else if ([value caseInsensitiveCompare:AWFFriendshipStatusNotFriendName] == NSOrderedSame) {
         return @(AWFFriendshipStatusNone);
       }
       else if ([value caseInsensitiveCompare:AWFFriendshipStatusPendingName] == NSOrderedSame) {
         return @(AWFFriendshipStatusPending);
       }
       else if ([value caseInsensitiveCompare:AWFFriendshipStatusFriendName] == NSOrderedSame) {
         return @(AWFFriendshipStatusFriend);
       }
       return @(AWFFriendshipStatusNone);
     } allowingReverseTransformationWithBlock:^id(id value) {
       switch ([value unsignedIntegerValue]) {
         case AWFFriendshipStatusPending:
           return AWFFriendshipStatusPendingName;
         case AWFFriendshipStatusFriend:
           return AWFFriendshipStatusFriendName;
         case AWFFriendshipStatusNone:
           return AWFFriendshipStatusNotFriendName;
         default:
           return nil;
       }
     }];

    // Activity Status

    [NSValueTransformer
     registerValueTransformerWithName:AWFActivityStatusTransformerName transformedValueClass:[NSString class]
     returningTransformedValueWithBlock:^id(id value) {
       if (!value || [value isEqual:[NSNull null]]) {
         return @(AWFActivityStatusUnknown);
       }
       else if ([value caseInsensitiveCompare:AWFActivityStatusUnreadName] == NSOrderedSame) {
         return @(AWFActivityStatusUnread);
       }
       else if ([value caseInsensitiveCompare:AWFActivityStatusReadName] == NSOrderedSame) {
         return @(AWFActivityStatusRead);
       }
       return @(AWFActivityStatusUnknown);
     } allowingReverseTransformationWithBlock:^id(id value) {
       switch ([value unsignedIntegerValue]) {
         case AWFActivityStatusUnread:
           return AWFActivityStatusUnreadName;
         case AWFActivityStatusRead:
           return AWFActivityStatusReadName;
         default:
           return nil;
       }
     }];

    // Activity Type

    [NSValueTransformer
     registerValueTransformerWithName:AWFActivityTypeTransformerName transformedValueClass:[NSString class]
     returningTransformedValueWithBlock:^id(id value) {
       if (!value || [value isEqual:[NSNull null]]) {
         return @(AWFActivityTypeUnknown);
       }
       else if ([value caseInsensitiveCompare:AWFActivityTypeFriendRequestName] == NSOrderedSame) {
         return @(AWFActivityTypeFriendRequest);
       }
       return @(AWFActivityTypeUnknown);
     } allowingReverseTransformationWithBlock:^id(id value) {
       switch ([value unsignedIntegerValue]) {
         case AWFActivityTypeFriendRequest:
           return AWFActivityTypeFriendRequestName;
         default:
           return nil;
       }
     }];
  }
}

@end
