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

NSString *const AWFGenderValueTransformerName = @"AWFGenderValueTransformerName";
NSString *const AWFFriendshipStatusTransformerName = @"AWFFriendshipStatusTransformerName";
NSString *const AWFActivityStatusTransformerName = @"AWFActivityStatusTransformerName";
NSString *const AWFActivityTypeTransformerName = @"AWFActivityTypeTransformerName";

static NSString *const AWFGenderMaleName   = @"male";
static NSString *const AWFGenderFemaleName = @"female";

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
       }
       return nil;
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
       }
       return nil;
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
       }
       return nil;
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
       }
       return nil;
     }];
  }
}

@end
