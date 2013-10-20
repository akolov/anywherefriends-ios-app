//
//  AWFSession.h
//  AnywhereFriends
//
//  Created by Alexander Kolov on 13/10/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

@import Foundation;

#import <ReactiveCocoa/ReactiveCocoa.h>


@interface AWFSession : NSObject

+ (instancetype)sharedSession;

- (RACSignal *)createUserWithEmail:(NSString *)email
                          password:(NSString *)password
                         firstName:(NSString *)firstname
                          lastName:(NSString *)lastname
                            gender:(NSString *)gender
                     facebookToken:(NSString *)facebookToken
                      twitterToken:(NSString *)twitterToken
                           vkToken:(NSString *)vkToken;

- (RACSignal *)openSessionWithEmail:(NSString *)email
                           password:(NSString *)password
                      facebookToken:(NSString *)facebookToken
                       twitterToken:(NSString *)twitterToken
                            vkToken:(NSString *)vkToken;

- (RACSignal *)closeSession;

@end