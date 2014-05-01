//
//  AWFPerson+RestKit.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 30/03/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "AWFConfig.h"
#import "AWFPerson+RestKit.h"

#import <RestKit/RestKit.h>

#import "AWFValueTransformers.h"
#import "NSManagedObject+RestKit.h"

@implementation AWFPerson (RestKit)

#pragma mark - Response

+ (RKEntityMapping *)responseMapping {
  static RKEntityMapping *mapping;

  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    mapping = [super responseMapping];

    // Body Build

    {
      RKAttributeMapping *bodyBuildMapping =
        [RKAttributeMapping attributeMappingFromKeyPath:@"build" toKeyPath:@"bodyBuild"];

      bodyBuildMapping.valueTransformer =
        [RKBlockValueTransformer
         valueTransformerWithValidationBlock:^BOOL(__unsafe_unretained Class inputValueClass,
                                                   __unsafe_unretained Class outputValueClass) {
           return ([inputValueClass isSubclassOfClass:[NSString class]] &&
                   [outputValueClass isSubclassOfClass:[NSNumber class]]);
         } transformationBlock:^BOOL(id inputValue, __autoreleasing id *outputValue,
                                     __unsafe_unretained Class outputClass, NSError *__autoreleasing *error) {
           RKValueTransformerTestInputValueIsKindOfClass(inputValue, [NSString class], error);
           RKValueTransformerTestOutputValueClassIsSubclassOfClass(outputClass, [NSNumber class], error);

           *outputValue = [[NSValueTransformer valueTransformerForName:AWFBodyBuildValueTransformerName]
                           transformedValue:inputValue];
           return YES;
         }];

      [mapping addPropertyMapping:bodyBuildMapping];
    }

    // Gender

    {
      RKAttributeMapping *genderMapping =
        [RKAttributeMapping attributeMappingFromKeyPath:@"gender" toKeyPath:@"gender"];

      genderMapping.valueTransformer =
        [RKBlockValueTransformer
         valueTransformerWithValidationBlock:^BOOL(__unsafe_unretained Class inputValueClass,
                                                   __unsafe_unretained Class outputValueClass) {
           return ([inputValueClass isSubclassOfClass:[NSString class]] &&
                   [outputValueClass isSubclassOfClass:[NSNumber class]]);
         } transformationBlock:^BOOL(id inputValue, __autoreleasing id *outputValue,
                                     __unsafe_unretained Class outputClass, NSError *__autoreleasing *error) {
           RKValueTransformerTestInputValueIsKindOfClass(inputValue, [NSString class], error);
           RKValueTransformerTestOutputValueClassIsSubclassOfClass(outputClass, [NSNumber class], error);

           *outputValue = [[NSValueTransformer valueTransformerForName:AWFGenderValueTransformerName]
                           transformedValue:inputValue];
           return YES;
         }];

      [mapping addPropertyMapping:genderMapping];
    }

    // Hair Length

    {
      RKAttributeMapping *hairLengthMapping =
        [RKAttributeMapping attributeMappingFromKeyPath:@"hair_length" toKeyPath:@"hairLength"];

      hairLengthMapping.valueTransformer =
        [RKBlockValueTransformer
         valueTransformerWithValidationBlock:^BOOL(__unsafe_unretained Class inputValueClass,
                                                   __unsafe_unretained Class outputValueClass) {
           return ([inputValueClass isSubclassOfClass:[NSString class]] &&
                   [outputValueClass isSubclassOfClass:[NSNumber class]]);
         } transformationBlock:^BOOL(id inputValue, __autoreleasing id *outputValue,
                                     __unsafe_unretained Class outputClass, NSError *__autoreleasing *error) {
           RKValueTransformerTestInputValueIsKindOfClass(inputValue, [NSString class], error);
           RKValueTransformerTestOutputValueClassIsSubclassOfClass(outputClass, [NSNumber class], error);

           *outputValue = [[NSValueTransformer valueTransformerForName:AWFHairLengthValueTransformerName]
                           transformedValue:inputValue];
           return YES;
         }];

      [mapping addPropertyMapping:hairLengthMapping];
    }

    // Friendship

    {
      RKAttributeMapping *friendshipMapping =
        [RKAttributeMapping attributeMappingFromKeyPath:@"friendship" toKeyPath:@"friendship"];

      friendshipMapping.valueTransformer =
        [RKBlockValueTransformer
         valueTransformerWithValidationBlock:^BOOL(__unsafe_unretained Class inputValueClass,
                                                   __unsafe_unretained Class outputValueClass) {
           return ([inputValueClass isSubclassOfClass:[NSString class]] &&
                   [outputValueClass isSubclassOfClass:[NSNumber class]]);
         } transformationBlock:^BOOL(id inputValue, __autoreleasing id *outputValue,
                                     __unsafe_unretained Class outputClass, NSError *__autoreleasing *error) {
           RKValueTransformerTestInputValueIsKindOfClass(inputValue, [NSString class], error);
           RKValueTransformerTestOutputValueClassIsSubclassOfClass(outputClass, [NSNumber class], error);

           *outputValue = [[NSValueTransformer valueTransformerForName:AWFFriendshipStatusTransformerName]
                           transformedValue:inputValue];
           return YES;
         }];

      [mapping addPropertyMapping:friendshipMapping];
    }
  });

  return mapping;
}

+ (NSArray *)responseDescriptorMatrix {
  return @[@[@(RKRequestMethodGET),    AWFAPIPathUser,        [NSNull null]],
           @[@(RKRequestMethodPOST),   AWFAPIPathUser,        [NSNull null]],
           @[@(RKRequestMethodPUT),    AWFAPIPathUser,        [NSNull null]],
           @[@(RKRequestMethodGET),    AWFAPIPathUsers,       @"users"],
           @[@(RKRequestMethodGET),    AWFAPIPathUserFriends, @"friends"],
           @[@(RKRequestMethodPOST),   AWFAPIPathUserFriends, @"friends"],
           @[@(RKRequestMethodDELETE), AWFAPIPathUserFriends, @"friends"]];
}

+ (NSArray *)identificationAttributes {
  return @[@"personID"];
}

+ (NSArray *)attributeMappingsArray {
  return @[@"bio", @"birthday", @"email", @"height", @"weight"];
}

+ (NSDictionary *)attributeMappingsDictionary {
  return @{@"id"          : @"personID",
           @"eye_color"   : @"eyeColor",
           @"first_name"  : @"firstName",
           @"hair_color"  : @"hairColor",
           @"last_name"   : @"lastName",
           @"latitude"    : @"locationLatitude",
           @"longitude"   : @"locationLongitude",
           @"location.locality"     : @"locationLocality",
           @"location.thoroughfare" : @"locationThoroughfare",
           @"location_updated"      : @"locationUpdated"};
}

@end
