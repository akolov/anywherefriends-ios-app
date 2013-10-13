//
//  AWFSession.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 13/10/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

#import "AWFSession.h"
#import <AFNetworking/AFNetworking.h>
#import <libextobjc/EXTScope.h>


static NSString *AWFAPIBaseURL = @"https://awf.awf";

static NSString *AWFAPIPathUser = @"user";
static NSString *AWFAPIPathLogin = @"login";
static NSString *AWFAPIPathLogout = @"logout";

static NSString *AWFURLParameterEmail = @"email";
static NSString *AWFURLParameterPassword = @"password";
static NSString *AWFURLParameterFirstName = @"firstname";
static NSString *AWFURLParameterLastName = @"lastname";
static NSString *AWFURLParameterGender = @"gender";
static NSString *AWFURLParameterInterests = @"interests";
static NSString *AWFURLParameterFacebookToken = @"facebook_token";
static NSString *AWFURLParameterTwitterToken = @"twitter_token";
static NSString *AWFURLParameterVKToken = @"vk_token";


@interface AWFSession ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end


@implementation AWFSession

#pragma mark - Properties

+ (NSURL *)baseURL {
  return [NSURL URLWithString:AWFAPIBaseURL];
}

- (AFHTTPSessionManager *)sessionManager {
  if (!_sessionManager) {
    _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:AWFSession.baseURL];
  }
  return _sessionManager;
}

#pragma mark - User methods

- (RACSignal *)createUserWithEmail:(NSString *)email
                          password:(NSString *)password
                         firstName:(NSString *)firstname
                          lastName:(NSString *)lastname
                            gender:(NSUInteger)gender
                         interests:(NSArray *)interests
                     facebookToken:(NSString *)facebookToken
                      twitterToken:(NSString *)twitterToken
                           vkToken:(NSString *)vkToken {
  @weakify(self);

  return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    @strongify(self);

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:email forKey:AWFURLParameterEmail];
    [parameters setValue:password forKey:AWFURLParameterPassword];
    [parameters setValue:firstname forKey:AWFURLParameterFirstName];
    [parameters setValue:lastname forKey:AWFURLParameterLastName];
    [parameters setValue:@(gender) forKey:AWFURLParameterGender];
    [parameters setValue:interests forKey:AWFURLParameterInterests];
    [parameters setValue:facebookToken forKey:AWFURLParameterFacebookToken];
    [parameters setValue:twitterToken forKey:AWFURLParameterTwitterToken];
    [parameters setValue:vkToken forKey:AWFURLParameterVKToken];

    NSURLSessionDataTask *task = [self.sessionManager POST:AWFAPIPathUser
                                                parameters:parameters
                                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                                     [subscriber sendNext:responseObject];
                                                     [subscriber sendCompleted];
                                                   }
                                                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                     [subscriber sendError:error];
                                                   }];

    return [RACDisposable disposableWithBlock:^{
      [task cancel];
    }];
  }];
}

- (RACSignal *)openSessionWithEmail:(NSString *)email
                           password:(NSString *)password
                      facebookToken:(NSString *)facebookToken
                       twitterToken:(NSString *)twitterToken
                            vkToken:(NSString *)vkToken {
  @weakify(self);

  return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    @strongify(self);

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:email forKey:AWFURLParameterEmail];
    [parameters setValue:password forKey:AWFURLParameterPassword];
    [parameters setValue:facebookToken forKey:AWFURLParameterFacebookToken];
    [parameters setValue:twitterToken forKey:AWFURLParameterTwitterToken];
    [parameters setValue:vkToken forKey:AWFURLParameterVKToken];

    NSURLSessionDataTask *task = [self.sessionManager POST:AWFAPIPathLogin
                                                parameters:parameters
                                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                                     [subscriber sendNext:responseObject];
                                                     [subscriber sendCompleted];
                                                   }
                                                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                     [subscriber sendError:error];
                                                   }];
    
    return [RACDisposable disposableWithBlock:^{
      [task cancel];
    }];
  }];
}

- (RACSignal *)closeSession {
  @weakify(self);

  return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    @strongify(self);

    NSURLSessionDataTask *task = [self.sessionManager POST:AWFAPIPathLogout
                                                parameters:nil
                                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                                     [subscriber sendNext:responseObject];
                                                     [subscriber sendCompleted];
                                                   }
                                                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                     [subscriber sendError:error];
                                                   }];

    return [RACDisposable disposableWithBlock:^{
      [task cancel];
    }];
  }];
}

@end
