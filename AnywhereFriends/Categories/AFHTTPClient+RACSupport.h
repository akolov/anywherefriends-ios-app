//
//  AFHTTPClient+RACSupport.h
//  StylightKit
//
//  Created by Robert Widmann on 3/28/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import <AFNetworking/AFHTTPClient.h>

@class RACSignal;

extern NSString * const RAFNetworkingOperationErrorKey;

@interface AFHTTPClient (RACSupport)

- (RACSignal *)rac_getPath:(NSString *)path parameters:(NSDictionary *)parameters;
- (RACSignal *)rac_postPath:(NSString *)path parameters:(NSDictionary *)parameters;
- (RACSignal *)rac_putPath:(NSString *)path parameters:(NSDictionary *)parameters;
- (RACSignal *)rac_deletePath:(NSString *)path parameters:(NSDictionary *)parameters;
- (RACSignal *)rac_patchPath:(NSString *)path parameters:(NSDictionary *)parameters;

#ifdef _SYSTEMCONFIGURATION_H
- (RACSignal *)networkReachabilityStatusSignal;
#endif

@end
