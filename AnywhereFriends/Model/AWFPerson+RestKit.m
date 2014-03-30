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

#import "NSManagedObject+RestKit.h"

@implementation AWFPerson (RestKit)

#pragma mark - Response

+ (RKEntityMapping *)responseMapping {
  static RKEntityMapping *mapping;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    mapping = [super responseMapping];
  });
  return mapping;
}

+ (NSArray *)responseDescriptorMatrix {
  return @[@[@(RKRequestMethodGET) , AWFAPIPathUser,  [NSNull null]],
           @[@(RKRequestMethodPOST), AWFAPIPathUser,  @"user"],
           @[@(RKRequestMethodPUT),  AWFAPIPathUser,  @"user"],
           @[@(RKRequestMethodGET),  AWFAPIPathUsers, @"users"]];
}

+ (NSArray *)identificationAttributes {
  return @[@"personID"];
}

+ (NSArray *)attributeMappingsArray {
  return @[@"bio", @"birthday", @"email", @"gender", @"height", @"weight"];
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
