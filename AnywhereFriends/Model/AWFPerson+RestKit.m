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

    // Gender

    {
      RKAttributeMapping *contentTypeMapping =
        [RKAttributeMapping attributeMappingFromKeyPath:@"gender" toKeyPath:@"gender"];

      contentTypeMapping.valueTransformer =
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

      [mapping addPropertyMapping:contentTypeMapping];
    }

    // Friendship

    {
      RKAttributeMapping *contentTypeMapping =
        [RKAttributeMapping attributeMappingFromKeyPath:@"friendship" toKeyPath:@"friendship"];

      contentTypeMapping.valueTransformer =
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

      [mapping addPropertyMapping:contentTypeMapping];
    }
  });

  return mapping;
}

+ (NSArray *)responseDescriptorMatrix {
  return @[@[@(RKRequestMethodGET),  AWFAPIPathUser,        [NSNull null]],
           @[@(RKRequestMethodPOST), AWFAPIPathUser,        @"user"],
           @[@(RKRequestMethodPUT),  AWFAPIPathUser,        @"user"],
           @[@(RKRequestMethodGET),  AWFAPIPathUsers,       @"users"],
           @[@(RKRequestMethodGET),  AWFAPIPathUserFriends, @"friends"]];
}

+ (NSArray *)identificationAttributes {
  return @[@"personID"];
}

+ (NSArray *)attributeMappingsArray {
  return @[@"bio", @"birthday", @"email", @"height", @"weight"];
}

+ (NSDictionary *)attributeMappingsDictionary {
  return @{@"id"          : @"personID",
           @"build"       : @"bodyBuild",
           @"eye_color"   : @"eyeColor",
           @"first_name"  : @"firstName",
           @"hair_color"  : @"hairColor",
           @"hair_length" : @"hairLength",
           @"last_name"   : @"lastName",
           @"latitude"    : @"locationLatitude",
           @"longitude"   : @"locationLongitude",
           @"location.locality"     : @"locationLocality",
           @"location.thoroughfare" : @"locationThoroughfare",
           @"location_updated"      : @"locationUpdated"};
}

@end
