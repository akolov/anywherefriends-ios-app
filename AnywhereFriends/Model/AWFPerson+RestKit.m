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

+ (RKObjectMapping *)requestMapping {
  static RKObjectMapping *mapping;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    mapping = [super requestMapping];

    // Body Build

    {
      RKAttributeMapping *bodyBuildMapping =
        [RKAttributeMapping attributeMappingFromKeyPath:@"bodyBuild" toKeyPath:@"build"];

      bodyBuildMapping.valueTransformer =
      [RKBlockValueTransformer
       valueTransformerWithValidationBlock:^BOOL(__unsafe_unretained Class inputValueClass,
                                                 __unsafe_unretained Class outputValueClass) {
         return ([inputValueClass isSubclassOfClass:[NSNumber class]] &&
                 [outputValueClass isSubclassOfClass:[NSString class]]);
       } transformationBlock:^BOOL(id inputValue, __autoreleasing id *outputValue,
                                   __unsafe_unretained Class outputClass, NSError *__autoreleasing *error) {
         RKValueTransformerTestInputValueIsKindOfClass(inputValue, [NSNumber class], error);
         RKValueTransformerTestOutputValueClassIsSubclassOfClass(outputClass, [NSString class], error);

         *outputValue = [[NSValueTransformer valueTransformerForName:AWFBodyBuildValueTransformerName]
                         reverseTransformedValue:inputValue];
         return YES;
       }];

      [mapping addPropertyMapping:bodyBuildMapping];
    }

    // Eye Color

    {
      RKAttributeMapping *eyeColorMapping =
      [RKAttributeMapping attributeMappingFromKeyPath:@"eyeColor" toKeyPath:@"eye_color"];

      eyeColorMapping.valueTransformer =
      [RKBlockValueTransformer
       valueTransformerWithValidationBlock:^BOOL(__unsafe_unretained Class inputValueClass,
                                                 __unsafe_unretained Class outputValueClass) {
         return ([inputValueClass isSubclassOfClass:[NSNumber class]] &&
                 [outputValueClass isSubclassOfClass:[NSString class]]);
       } transformationBlock:^BOOL(id inputValue, __autoreleasing id *outputValue,
                                   __unsafe_unretained Class outputClass, NSError *__autoreleasing *error) {
         RKValueTransformerTestInputValueIsKindOfClass(inputValue, [NSNumber class], error);
         RKValueTransformerTestOutputValueClassIsSubclassOfClass(outputClass, [NSString class], error);

         *outputValue = [[NSValueTransformer valueTransformerForName:AWFEyeColorValueTransformerName]
                         reverseTransformedValue:inputValue];
         return YES;
       }];

      [mapping addPropertyMapping:eyeColorMapping];
    }

    // Gender

    {
      RKAttributeMapping *genderMapping =
      [RKAttributeMapping attributeMappingFromKeyPath:@"gender" toKeyPath:@"gender"];

      genderMapping.valueTransformer =
      [RKBlockValueTransformer
       valueTransformerWithValidationBlock:^BOOL(__unsafe_unretained Class inputValueClass,
                                                 __unsafe_unretained Class outputValueClass) {
         return ([inputValueClass isSubclassOfClass:[NSNumber class]] &&
                 [outputValueClass isSubclassOfClass:[NSString class]]);
       } transformationBlock:^BOOL(id inputValue, __autoreleasing id *outputValue,
                                   __unsafe_unretained Class outputClass, NSError *__autoreleasing *error) {
         RKValueTransformerTestInputValueIsKindOfClass(inputValue, [NSNumber class], error);
         RKValueTransformerTestOutputValueClassIsSubclassOfClass(outputClass, [NSString class], error);

         *outputValue = [[NSValueTransformer valueTransformerForName:AWFGenderValueTransformerName]
                         reverseTransformedValue:inputValue];
         return YES;
       }];

      [mapping addPropertyMapping:genderMapping];
    }

    // Hair Color

    {
      RKAttributeMapping *hairColorMapping =
      [RKAttributeMapping attributeMappingFromKeyPath:@"hairColor" toKeyPath:@"hair_color"];

      hairColorMapping.valueTransformer =
      [RKBlockValueTransformer
       valueTransformerWithValidationBlock:^BOOL(__unsafe_unretained Class inputValueClass,
                                                 __unsafe_unretained Class outputValueClass) {
         return ([inputValueClass isSubclassOfClass:[NSNumber class]] &&
                 [outputValueClass isSubclassOfClass:[NSString class]]);
       } transformationBlock:^BOOL(id inputValue, __autoreleasing id *outputValue,
                                   __unsafe_unretained Class outputClass, NSError *__autoreleasing *error) {
         RKValueTransformerTestInputValueIsKindOfClass(inputValue, [NSNumber class], error);
         RKValueTransformerTestOutputValueClassIsSubclassOfClass(outputClass, [NSString class], error);

         *outputValue = [[NSValueTransformer valueTransformerForName:AWFHairColorValueTransformerName]
                         reverseTransformedValue:inputValue];
         return YES;
       }];

      [mapping addPropertyMapping:hairColorMapping];
    }

    // Hair Length

    {
      RKAttributeMapping *hairLengthMapping =
      [RKAttributeMapping attributeMappingFromKeyPath:@"hairLength" toKeyPath:@"hair_length"];

      hairLengthMapping.valueTransformer =
      [RKBlockValueTransformer
       valueTransformerWithValidationBlock:^BOOL(__unsafe_unretained Class inputValueClass,
                                                 __unsafe_unretained Class outputValueClass) {
         return ([inputValueClass isSubclassOfClass:[NSNumber class]] &&
                 [outputValueClass isSubclassOfClass:[NSString class]]);
       } transformationBlock:^BOOL(id inputValue, __autoreleasing id *outputValue,
                                   __unsafe_unretained Class outputClass, NSError *__autoreleasing *error) {
         RKValueTransformerTestInputValueIsKindOfClass(inputValue, [NSNumber class], error);
         RKValueTransformerTestOutputValueClassIsSubclassOfClass(outputClass, [NSString class], error);

         *outputValue = [[NSValueTransformer valueTransformerForName:AWFHairLengthValueTransformerName]
                         reverseTransformedValue:inputValue];
         return YES;
       }];

      [mapping addPropertyMapping:hairLengthMapping];
    }
  });
  return mapping;
}

#pragma mark - Request

+ (NSArray *)requestDescriptorMatrix {
  return @[@[@(RKRequestMethodPUT), [NSNull null]]];
}

+ (NSArray *)requestMappingsArray {
  return @[@"bio", @"birthday", @"email", @"height", @"weight"];
}

+ (NSDictionary *)requestMappingsDictionary {
  return @{@"firstName": @"first_name",
           @"lastName": @"last_name"};
}

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

    // Eye Color

    {
      RKAttributeMapping *eyeColorMapping =
        [RKAttributeMapping attributeMappingFromKeyPath:@"eye_color" toKeyPath:@"eyeColor"];

      eyeColorMapping.valueTransformer =
        [RKBlockValueTransformer
         valueTransformerWithValidationBlock:^BOOL(__unsafe_unretained Class inputValueClass,
                                                   __unsafe_unretained Class outputValueClass) {
           return ([inputValueClass isSubclassOfClass:[NSString class]] &&
                   [outputValueClass isSubclassOfClass:[NSNumber class]]);
         } transformationBlock:^BOOL(id inputValue, __autoreleasing id *outputValue,
                                     __unsafe_unretained Class outputClass, NSError *__autoreleasing *error) {
           RKValueTransformerTestInputValueIsKindOfClass(inputValue, [NSString class], error);
           RKValueTransformerTestOutputValueClassIsSubclassOfClass(outputClass, [NSNumber class], error);

           *outputValue = [[NSValueTransformer valueTransformerForName:AWFEyeColorValueTransformerName]
                           transformedValue:inputValue];
           return YES;
         }];

      [mapping addPropertyMapping:eyeColorMapping];
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

    // Hair Color

    {
      RKAttributeMapping *hairColorMapping =
        [RKAttributeMapping attributeMappingFromKeyPath:@"hair_color" toKeyPath:@"hairColor"];

      hairColorMapping.valueTransformer =
        [RKBlockValueTransformer
         valueTransformerWithValidationBlock:^BOOL(__unsafe_unretained Class inputValueClass,
                                                   __unsafe_unretained Class outputValueClass) {
           return ([inputValueClass isSubclassOfClass:[NSString class]] &&
                   [outputValueClass isSubclassOfClass:[NSNumber class]]);
         } transformationBlock:^BOOL(id inputValue, __autoreleasing id *outputValue,
                                     __unsafe_unretained Class outputClass, NSError *__autoreleasing *error) {
           RKValueTransformerTestInputValueIsKindOfClass(inputValue, [NSString class], error);
           RKValueTransformerTestOutputValueClassIsSubclassOfClass(outputClass, [NSNumber class], error);

           *outputValue = [[NSValueTransformer valueTransformerForName:AWFHairColorValueTransformerName]
                           transformedValue:inputValue];
           return YES;
         }];

      [mapping addPropertyMapping:hairColorMapping];
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
           @"first_name"  : @"firstName",
           @"last_name"   : @"lastName",
           @"latitude"    : @"locationLatitude",
           @"longitude"   : @"locationLongitude",
           @"location.locality"     : @"locationLocality",
           @"location.thoroughfare" : @"locationThoroughfare",
           @"location_updated"      : @"locationUpdated"};
}

@end
