//
//  AWFClient.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 30/03/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "AWFConfig.h"
#import "AWFClient.h"

#import <AFNetworking/AFJSONRequestOperation.h>

@implementation AWFClient

+ (instancetype)sharedClient {
  static AWFClient *instance;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [[AWFClient alloc] initWithBaseURL:[AWFClient baseURL]];
  });

  return instance;
}

+ (NSURL *)baseURL {
  return [NSURL URLWithString:AWFAPIBaseURL];
}

- (id)initWithBaseURL:(NSURL *)url {
  self = [super initWithBaseURL:url];
  if (self) {
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
  }

  return self;
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method path:(NSString *)path
                                parameters:(NSDictionary *)parameters {
  NSMutableURLRequest *request = [super requestWithMethod:method path:path parameters:parameters];
  request.HTTPShouldUsePipelining = YES;
  return request;
}

@end
