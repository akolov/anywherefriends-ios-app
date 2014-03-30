//
//  RKObjectManager+RACSupport.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 30/03/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "RKObjectManager+RACSupport.h"

#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation RKObjectManager (RACSupport)

- (RACSignal *)rac_getObjectsAtPath:(NSString *)path parameters:(NSDictionary *)parameters {
  return [self rac_requestObject:nil path:path parameters:parameters method:RKRequestMethodGET];
}

- (RACSignal *)rac_getObject:(id)object path:(NSString *)path parameters:(NSDictionary *)parameters {
  return [self rac_requestObject:object path:path parameters:parameters method:RKRequestMethodGET];
}

- (RACSignal *)rac_postObject:(id)object path:(NSString *)path parameters:(NSDictionary *)parameters {
  return [self rac_requestObject:object path:path parameters:parameters method:RKRequestMethodPOST];
}

- (RACSignal *)rac_putObject:(id)object path:(NSString *)path parameters:(NSDictionary *)parameters {
  return [self rac_requestObject:object path:path parameters:parameters method:RKRequestMethodPUT];
}

- (RACSignal *)rac_patchObject:(id)object path:(NSString *)path parameters:(NSDictionary *)parameters {
  return [self rac_requestObject:object path:path parameters:parameters method:RKRequestMethodPATCH];
}

- (RACSignal *)rac_deleteObject:(id)object path:(NSString *)path parameters:(NSDictionary *)parameters {
  return [self rac_requestObject:object path:path parameters:parameters method:RKRequestMethodDELETE];
}

- (RACSignal *)rac_requestObject:(id)object path:(NSString *)path parameters:(NSDictionary *)parameters
                          method:(RKRequestMethod)method {
  NSAssert(object || path, @"Cannot make a request without an object or a path.");

  @weakify(self);
  return [RACSignal createSignal:^(id<RACSubscriber> subscriber) {
    @strongify(self);

    RKObjectRequestOperation *operation =
      [self appropriateObjectRequestOperationWithObject:object method:method path:path parameters:parameters];

    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
      [subscriber sendNext:RACTuplePack(operation, mappingResult)];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
      [subscriber sendError:error];
    }];

    [self enqueueObjectRequestOperation:operation];

    return [RACDisposable disposableWithBlock:^{
      [operation cancel];
    }];
  }];
}

@end
