//
//  AWFTwitterClient.h
//  AnywhereFriends
//
//  Created by Alexander Kolov on 22/05/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import <AFNetworking/AFHTTPClient.h>

@interface AWFTwitterClient : AFHTTPClient

+ (instancetype)sharedClient;
+ (NSURL *)baseURL;

- (RACSignal *)performReverseAuthorization;

@end
