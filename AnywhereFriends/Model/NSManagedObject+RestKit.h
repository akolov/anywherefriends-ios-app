//
//  NSManagedObject+RestKit.h
//  AnywhereFriends
//
//  Created by Alexander Kolov on 9/9/13.
//  Copyright (c) 2013 Alexander Kolov. All rights reserved.
//

@import Foundation;
@import CoreData;

@class RKEntityMapping;
@class RKObjectMapping;

@interface NSManagedObject (RestKit)

+ (NSString *)entityName;
+ (instancetype)createInMainContext;

/** --------------------------------------------------------------------------------------------------------------------
 * @name Request Mapping
 *  --------------------------------------------------------------------------------------------------------------------
 */

+ (NSArray *)requestDescriptors NS_REQUIRES_SUPER;
+ (NSArray *)requestDescriptorMatrix;
+ (RKObjectMapping *)requestMapping;

/** --------------------------------------------------------------------------------------------------------------------
 * @name Request Mapping Attributes
 *  --------------------------------------------------------------------------------------------------------------------
 */

+ (NSArray *)requestMappingsArray;
+ (NSDictionary *)requestMappingsDictionary;

/** --------------------------------------------------------------------------------------------------------------------
 * @name Response Mapping
 *  --------------------------------------------------------------------------------------------------------------------
 */

+ (NSArray *)responseDescriptors NS_REQUIRES_SUPER;
+ (NSArray *)responseDescriptorMatrix;
+ (RKEntityMapping *)responseMapping;

/** --------------------------------------------------------------------------------------------------------------------
 * @name Response Mapping Attributes
 *  --------------------------------------------------------------------------------------------------------------------
 */

+ (NSArray *)identificationAttributes;
+ (NSArray *)modificationAttributes;
+ (NSDictionary *)attributeMappingsDictionary;
+ (NSArray *)attributeMappingsArray;
+ (NSDictionary *)relationshipMappings;
+ (NSDictionary *)relationshipConnections;


@end
