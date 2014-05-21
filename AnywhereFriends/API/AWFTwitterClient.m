//
//  AWFTwitterClient.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 22/05/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

@import Accounts;
@import Social;

#import "AWFConfig.h"
#import "AWFTwitterClient.h"
#import "NSString+AWFAdditions.h"

#import <AXKRACExtensions/AFHTTPClient+AXKRACExtensions.h>
#import <OAuthCore/OAuthCore.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface AWFTwitterClient ()

@property (nonatomic, strong) ACAccountStore *accountStore;
@property (nonatomic, strong) ACAccountType *accountType;

- (RACSignal *)stepOneAuthorization;
- (RACSignal *)stepTwoAuthorizationWithAccount:(ACAccount *)account reverseAuthParams:(NSString *)reverseAuthParams;

@end

@implementation AWFTwitterClient

+ (instancetype)sharedClient {
  static id instance;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [[[self class] alloc] initWithBaseURL:[[self class] baseURL]];
  });
  return instance;
}

+ (NSURL *)baseURL {
  return [NSURL URLWithString:@"https://api.twitter.com"];
}

- (ACAccountStore *)accountStore {
  if (!_accountStore) {
    _accountStore = [[ACAccountStore alloc] init];
  }
  return _accountStore;
}

- (ACAccountType *)accountType {
  if (!_accountType) {
    _accountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
  }
  return _accountType;
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method path:(NSString *)path
                                parameters:(NSDictionary *)parameters {
  NSMutableURLRequest *request = [super requestWithMethod:method path:path parameters:parameters];
  NSString *authorizationHeader = OAuthorizationHeader(request.URL, request.HTTPMethod, request.HTTPBody,
                                                       AWFTwitterConsumerKey, AWFTwitterConsumerSecret, nil, nil);

  [request setValue:authorizationHeader forHTTPHeaderField:@"Authorization"];
  return request;
}

- (RACSignal *)performReverseAuthorization {
  return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    [self.accountStore requestAccessToAccountsWithType:self.accountType options:nil completion:^(BOOL granted, NSError *error) {
      if (granted) {
        @weakify(self);
        [[[self stepOneAuthorization]
          flattenMap:^RACStream *(NSString *reverseAuthParams) {
            @strongify(self);
            NSArray *accounts = [self.accountStore accountsWithAccountType:self.accountType];
            ACAccount *account = [accounts firstObject];
            return [self stepTwoAuthorizationWithAccount:account reverseAuthParams:reverseAuthParams];
          }]
         subscribeNext:^(RACTuple *tuple) {
           [subscriber sendNext:tuple];
         }
         error:^(NSError *error) {
           [subscriber sendError:error];
         }
         completed:^{
           [subscriber sendCompleted];
         }];
      }
      else {
        [subscriber sendError:error];
      }
    }];

    return nil;
  }];
}

- (RACSignal *)stepOneAuthorization {
  NSDictionary *parameters = @{@"x_auth_mode": @"reverse_auth"};
  return [[self rac_postPath:@"/oauth/request_token" parameters:parameters] map:^id(RACTuple *x) {
    return [[NSString alloc] initWithData:x.second encoding:NSUTF8StringEncoding];
  }];
}

- (RACSignal *)stepTwoAuthorizationWithAccount:(ACAccount *)account reverseAuthParams:(NSString *)reverseAuthParams {
  return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/oauth/access_token"];
    NSDictionary *params = @{@"x_reverse_auth_target": AWFTwitterConsumerKey,
                             @"x_reverse_auth_parameters": reverseAuthParams};

    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodPOST
                                                      URL:url
                                               parameters:params];
    request.account = account;

    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
      if (!error) {
        NSString *response = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSDictionary *query = [response dictionaryFromQueryString];
        NSString *token = query[@"oauth_token"];
        NSString *secret = query[@"oauth_token_secret"];

        [subscriber sendNext:RACTuplePack(token, secret)];
        [subscriber sendCompleted];
      }
      else {
        [subscriber sendError:error];
      }
    }];

    return nil;
  }];
}

@end
