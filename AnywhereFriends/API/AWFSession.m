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

#import "AWFPerson.h"


static NSString *AWFAPIBaseURL = @"http://api.awf.spoofa.info/v1/";

static NSString *AWFAPIPathUser = @"user/";
static NSString *AWFAPIPathUsers = @"users/";
static NSString *AWFAPIPathLogin = @"login/";
static NSString *AWFAPIPathLogout = @"logout/";

static NSString *AWFURLParameterEmail = @"email";
static NSString *AWFURLParameterPassword = @"password";
static NSString *AWFURLParameterFirstName = @"first_name";
static NSString *AWFURLParameterLastName = @"last_name";
static NSString *AWFURLParameterGender = @"gender";
static NSString *AWFURLParameterFacebookToken = @"facebook_token";
static NSString *AWFURLParameterTwitterToken = @"twitter_token";
static NSString *AWFURLParameterVKToken = @"vk_token";


@interface AWFSession ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end


@implementation AWFSession

#pragma mark - Properties

+ (instancetype)sharedSession {
  static AWFSession *session;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    session = [[AWFSession alloc] init];
  });
  return session;
}

+ (BOOL)hasSessionCookie {
  NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:self.baseURL];
  for (NSHTTPCookie *cookie in cookies) {
    if ([cookie.name isEqualToString:@"sid"] &&
        cookie.value.length > 0 &&
        [cookie.expiresDate compare:[NSDate date]] == NSOrderedDescending) {
      return YES;
    }
  }
  return NO;
}

+ (BOOL)isLoggedIn {
  return self.hasSessionCookie;
}

+ (NSURL *)baseURL {
  return [NSURL URLWithString:AWFAPIBaseURL];
}

- (AFHTTPSessionManager *)sessionManager {
  if (!_sessionManager) {
    _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:AWFSession.baseURL];
  }
  return _sessionManager;
}

#pragma mark - Login methods

- (RACSignal *)createUserWithEmail:(NSString *)email
                          password:(NSString *)password
                         firstName:(NSString *)firstname
                          lastName:(NSString *)lastname
                            gender:(NSString *)gender
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
    [parameters setValue:gender forKey:AWFURLParameterGender];
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

#pragma mark - Profile methods

- (RACSignal *)getUserSelf {
  @weakify(self);

  return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    @strongify(self);

    NSURLSessionDataTask *task = [self.sessionManager POST:AWFAPIPathUser
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

#pragma mark - People search

- (RACSignal *)getUsersAtCoordinate:(CLLocationCoordinate2D)coordinate withRadius:(CGFloat)radius
                         pageNumber:(NSUInteger)pageNumber pageSize:(NSUInteger)pageSize {
  @weakify(self);

  return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    @strongify(self);

    NSDictionary *parameters = @{@"lat": @(coordinate.latitude),
                                 @"lon": @(coordinate.longitude),
                                 @"r": @(radius),
                                 @"page": @(pageNumber),
                                 @"per_page": @(pageSize)};

    NSURLSessionDataTask *task = [self.sessionManager
                                  GET:AWFAPIPathUsers
                                  parameters:parameters
                                  success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
                                    NSMutableArray *people = [NSMutableArray array];
                                    for (NSDictionary *dict in responseObject[@"users"]) {
                                      [people addObject:[AWFPerson personFromDictionary:dict]];
                                    }

                                    [people sortedArrayUsingDescriptors:
                                     @[[NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:YES]]];

                                    [subscriber sendNext:people];
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
