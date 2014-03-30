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

#import "AWFGender.h"
#import "AWFPerson.h"

NSString *const AWFGenderValueTransformerName = @"AWFGenderValueTransformerName";
NSString *const AWFFriendshipStatusTransformerName = @"AWFFriendshipStatusTransformerName";

static NSString *const AWFGenderMaleName   = @"male";
static NSString *const AWFGenderFemaleName = @"female";

static NSString *const AWFFriendshipStatusNotFriendName = @"not_friend";
static NSString *const AWFFriendshipStatusFriendName = @"friend";
static NSString *const AWFFriendshipStatusPendingName = @"pending";

@implementation AWFValueTransformers

+ (void)load {
  @autoreleasepool {
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
  }
}

@end
