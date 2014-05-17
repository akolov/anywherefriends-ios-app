//
//  AWFJSONRequestOperation.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 17/05/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "AWFConfig.h"
#import "AWFJSONRequestOperation.h"

@interface AFURLConnectionOperation () <NSURLConnectionDataDelegate>

@property (readwrite, nonatomic, strong) NSRecursiveLock *lock;

@end

@implementation AWFJSONRequestOperation

- (NSError *)error {
  [self.lock lock];

  NSUInteger statusCode = ([self.response isKindOfClass:[NSHTTPURLResponse class]]) ? (NSUInteger)[self.response statusCode] : 200;

  if (statusCode == 403) {
    [[NSNotificationCenter defaultCenter] postNotificationName:AWFLoginRequiredNotification object:nil];
  }

  NSError *error = [super error];
  [self.lock unlock];
  return error;
}

@end
