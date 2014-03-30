//
//  AWFClient.h
//  AnywhereFriends
//
//  Created by Alexander Kolov on 30/03/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import <AFNetworking/AFHTTPClient.h>

@interface AWFClient : AFHTTPClient

+ (instancetype)sharedClient;
+ (NSURL *)baseURL;

@end
