//
//  RKObjectManager+RACSupport.h
//  AnywhereFriends
//
//  Created by Alexander Kolov on 30/03/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "RKObjectManager.h"

@class RACSignal;

@interface RKObjectManager (RACSupport)

- (RACSignal *)rac_getObjectsAtPath:(NSString *)path parameters:(NSDictionary *)parameters;
- (RACSignal *)rac_getObject:(id)object path:(NSString *)path parameters:(NSDictionary *)parameters;
- (RACSignal *)rac_postObject:(id)object path:(NSString *)path parameters:(NSDictionary *)parameters;
- (RACSignal *)rac_putObject:(id)object path:(NSString *)path parameters:(NSDictionary *)parameters;
- (RACSignal *)rac_patchObject:(id)object path:(NSString *)path parameters:(NSDictionary *)parameters;
- (RACSignal *)rac_deleteObject:(id)object path:(NSString *)path parameters:(NSDictionary *)parameters;

- (RACSignal *)rac_requestObject:(id)object path:(NSString *)path parameters:(NSDictionary *)parameters
                          method:(RKRequestMethod)method;

@end
