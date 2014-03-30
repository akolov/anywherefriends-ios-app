//
//  NSManagedObject+RestKit.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 9/9/13.
//  Copyright (c) 2013 Alexander Kolov. All rights reserved.
//

#import "AWFConfig.h"
#import "NSManagedObject+RestKit.h"

#import <RestKit/RestKit.h>

@implementation NSManagedObject (RestKit)

+ (NSString *)entityName {
  return nil;
}

+ (instancetype)createInMainContext {
  return [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext
          insertNewObjectForEntityForName:[self entityName]];
}

#pragma mark - Request Mapping

+ (NSArray *)requestDescriptors {
  NSMutableArray *descriptors = [NSMutableArray array];
  for (NSArray *row in [self requestDescriptorMatrix]) {
    NSAssert([row count] == 2, @"Request Descriptor Matrix row size should equal 2");
    [descriptors addObject:
     [RKRequestDescriptor requestDescriptorWithMapping:[self requestMapping]
                                           objectClass:[self class]
                                           rootKeyPath:[row[1] isEqual:[NSNull null]] ? nil : row[1]
                                                method:[row[0] integerValue]]];
  }
  return descriptors;
}

+ (NSArray *)requestDescriptorMatrix {
  return nil;
}

+ (RKObjectMapping *)requestMapping {
  static RKObjectMapping *mapping;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    mapping = [RKObjectMapping requestMapping];
    if ([self requestMappingsArray]) {
      [mapping addAttributeMappingsFromArray:[self requestMappingsArray]];
    }

    if ([self requestMappingsDictionary]) {
      [mapping addAttributeMappingsFromDictionary:[self requestMappingsDictionary]];
    }
  });

  return mapping;
}

#pragma mark - Request Attributes

+ (NSArray *)requestMappingsArray {
  return nil;
}

+ (NSDictionary *)requestMappingsDictionary {
  return nil;
}

#pragma mark - Response Mapping

+ (NSArray *)responseDescriptors {
  NSMutableArray *descriptors = [NSMutableArray array];
  NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
  for (NSArray *row in [self responseDescriptorMatrix]) {
    NSAssert([row count] == 3, @"Response Descriptor Matrix row size should equal 3");
    [descriptors addObject:
     [RKResponseDescriptor responseDescriptorWithMapping:[self responseMapping]
                                                  method:[row[0] integerValue]
                                             pathPattern:row[1]
                                                 keyPath:row[2]
                                             statusCodes:statusCodes]];
  }
  return descriptors;
}

+ (NSArray *)responseDescriptorMatrix {
  return nil;
}

+ (RKEntityMapping *)responseMapping {
  RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:[self entityName]
                                                 inManagedObjectStore:[RKManagedObjectStore defaultStore]];

  if ([self identificationAttributes]) {
    [mapping setIdentificationAttributes:[self identificationAttributes]];
  }

  if ([self modificationAttributes]) {
    [mapping setModificationAttributesForNames:[self modificationAttributes]];
  }

  if ([self attributeMappingsDictionary]) {
    [mapping addAttributeMappingsFromDictionary:[self attributeMappingsDictionary]];
  }

  if ([self attributeMappingsArray]) {
    [mapping addAttributeMappingsFromArray:[self attributeMappingsArray]];
  }

  if ([self relationshipMappings]) {
    [[self relationshipMappings] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
      [mapping addRelationshipMappingWithSourceKeyPath:key mapping:obj];
    }];
  }

  if ([self relationshipConnections]) {
    [[self relationshipConnections] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
      [mapping addConnectionForRelationship:key connectedBy:obj];
    }];
  }

  return mapping;
}

#pragma mark - Response Attributes

+ (NSArray *)identificationAttributes {
  return nil;
}

+ (NSArray *)modificationAttributes {
  return nil;
}

+ (NSDictionary *)attributeMappingsDictionary {
  return nil;
}

+ (NSArray *)attributeMappingsArray {
  return nil;
}

+ (NSDictionary *)relationshipMappings {
  return nil;
}

+ (NSDictionary *)relationshipConnections {
  return nil;
}

@end
