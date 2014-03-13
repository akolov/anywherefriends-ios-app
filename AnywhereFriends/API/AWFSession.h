//
//  AWFSession.h
//  AnywhereFriends
//
//  Created by Alexander Kolov on 13/10/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

@import Foundation;
@import CoreLocation;

@class AWFPerson;
@class RACSignal;

@interface AWFSession : NSObject

+ (instancetype)sharedSession;
+ (BOOL)hasSessionCookie;
+ (BOOL)isLoggedIn;

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

- (RACSignal *)getUserSelf;
- (RACSignal *)getUserFriends;
- (RACSignal *)getUsersAtCoordinate:(CLLocationCoordinate2D)coordinate withRadius:(CGFloat)radius
                         pageNumber:(NSUInteger)pageNumber pageSize:(NSUInteger)pageSize;

- (RACSignal *)updateUserSelfLocation:(CLPlacemark *)placemark;
- (RACSignal *)friendUser:(AWFPerson *)person;
- (RACSignal *)unfriendUser:(AWFPerson *)person;

@end
