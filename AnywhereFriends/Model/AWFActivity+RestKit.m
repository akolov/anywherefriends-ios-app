//
//  AWFActivity+RestKit.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 30/03/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "AWFConfig.h"
#import "AWFActivity+RestKit.h"

#import <RestKit/RestKit.h>

#import "AWFPerson+RestKit.h"
#import "AWFValueTransformers.h"
#import "NSManagedObject+RestKit.h"

@implementation AWFActivity (RestKit)

#pragma mark - Response

+ (RKEntityMapping *)responseMapping {
  static RKEntityMapping *mapping;

  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    mapping = [super responseMapping];

    // Activity Status

    {
      RKAttributeMapping *statusMapping =
      [RKAttributeMapping attributeMappingFromKeyPath:@"status" toKeyPath:@"status"];

      statusMapping.valueTransformer =
        [RKBlockValueTransformer
         valueTransformerWithValidationBlock:^BOOL(__unsafe_unretained Class inputValueClass,
                                                   __unsafe_unretained Class outputValueClass) {
           return ([inputValueClass isSubclassOfClass:[NSString class]] &&
                   [outputValueClass isSubclassOfClass:[NSNumber class]]);
         } transformationBlock:^BOOL(id inputValue, __autoreleasing id *outputValue,
                                     __unsafe_unretained Class outputClass, NSError *__autoreleasing *error) {
           RKValueTransformerTestInputValueIsKindOfClass(inputValue, [NSString class], error);
           RKValueTransformerTestOutputValueClassIsSubclassOfClass(outputClass, [NSNumber class], error);

           *outputValue = [[NSValueTransformer valueTransformerForName:AWFActivityStatusTransformerName]
                           transformedValue:inputValue];
           return YES;
         }];

      [mapping addPropertyMapping:statusMapping];
    }

    // Activity Type

    {
      RKAttributeMapping *typeMapping =
        [RKAttributeMapping attributeMappingFromKeyPath:@"type" toKeyPath:@"type"];

      typeMapping.valueTransformer =
        [RKBlockValueTransformer
         valueTransformerWithValidationBlock:^BOOL(__unsafe_unretained Class inputValueClass,
                                                   __unsafe_unretained Class outputValueClass) {
           return ([inputValueClass isSubclassOfClass:[NSString class]] &&
                   [outputValueClass isSubclassOfClass:[NSNumber class]]);
         } transformationBlock:^BOOL(id inputValue, __autoreleasing id *outputValue,
                                     __unsafe_unretained Class outputClass, NSError *__autoreleasing *error) {
           RKValueTransformerTestInputValueIsKindOfClass(inputValue, [NSString class], error);
           RKValueTransformerTestOutputValueClassIsSubclassOfClass(outputClass, [NSNumber class], error);

           *outputValue = [[NSValueTransformer valueTransformerForName:AWFActivityTypeTransformerName]
                           transformedValue:inputValue];
           return YES;
         }];

      [mapping addPropertyMapping:typeMapping];
    }

    // Creator

    {
      RKRelationshipMapping *creatorMapping =
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"created_by" toKeyPath:@"creator"
                                                  withMapping:[AWFPerson responseMapping]];
      [mapping addPropertyMapping:creatorMapping];
    }
  });
  
  return mapping;
}

+ (NSArray *)responseDescriptorMatrix {
  return @[@[@(RKRequestMethodGET), AWFAPIPathUserActivity, @"activity"]];
}

+ (NSArray *)identificationAttributes {
  return @[@"activityID"];
}

+ (NSArray *)modificationAttributes {
  return @[@"dateCreated"];
}

+ (NSDictionary *)attributeMappingsDictionary {
  return @{@"id"   : @"activityID",
           @"date" : @"dateCreated"};
}

@end
