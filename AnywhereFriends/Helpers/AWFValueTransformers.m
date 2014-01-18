//
//  AWFValueTransformers.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 19/01/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "AWFValueTransformers.h"

#import <TransformerKit/NSValueTransformer+TransformerKit.h>

#import "AWFGender.h"


NSString *const AWFGenderValueTransformerName = @"AWFGenderValueTransformerName";


static NSString *const AWFGenderMaleName   = @"male";
static NSString *const AWFGenderFemaleName = @"female";


@implementation AWFValueTransformers

+ (void)load {
  @autoreleasepool {
    [NSValueTransformer
     registerValueTransformerWithName:AWFGenderValueTransformerName transformedValueClass:[NSString class]
     returningTransformedValueWithBlock:^id(id value) {
       if (!value) {
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
       switch ([value integerValue]) {
         case AWFGenderFemale:
           return AWFGenderFemaleName;
         case AWFGenderMale:
           return AWFGenderMaleName;
       }
       return nil;
     }];
  }
}

@end
