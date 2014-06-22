//
//  AWFSession.h
//  AnywhereFriends
//
//  Created by Alexander Kolov on 13/10/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

@import Foundation;
@import CoreLocation;

@class AWFActivity;
@class AWFPerson;
@class RACSignal;

@interface AWFSession : NSObject

@property (nonatomic, strong, readonly) NSString *currentUserID;
@property (nonatomic, strong, readonly) AWFPerson *currentUser;

+ (instancetype)sharedSession;
+ (BOOL)hasSessionCookie;
+ (BOOL)isLoggedIn;
+ (NSManagedObjectContext *)managedObjectContext;

- (RACSignal *)createUserWithEmail:(NSString *)email
                          password:(NSString *)password
                         firstName:(NSString *)firstName
                          lastName:(NSString *)lastName
                            gender:(NSString *)gender;

- (RACSignal *)openSessionWithEmail:(NSString *)email password:(NSString *)password;
- (RACSignal *)openSessionWithFacebookToken:(NSString *)facebookToken;
- (RACSignal *)openSessionWithTwitterToken:(NSString *)twitterToken secret:(NSString *)secret;
- (RACSignal *)openSessionWithVKToken:(NSString *)vkToken;

- (RACSignal *)closeSession;

- (RACSignal *)getUserSelf;
- (RACSignal *)getUserSelfFriends;
- (RACSignal *)getUsersAtCoordinate:(CLLocationCoordinate2D)coordinate withRadius:(CGFloat)radius
                         pageNumber:(NSUInteger)pageNumber pageSize:(NSUInteger)pageSize;

- (RACSignal *)updateUserSelfLocation:(CLPlacemark *)placemark;
- (RACSignal *)updateUserSelf;

- (RACSignal *)friendUser:(AWFPerson *)person;
- (RACSignal *)unfriendUser:(AWFPerson *)person;
- (RACSignal *)approveFriendRequestFromUser:(AWFPerson *)person;
- (RACSignal *)rejectFriendRequestFromUser:(AWFPerson *)person;

- (RACSignal *)getUserSelfActivity;
- (RACSignal *)markActivityAsRead:(AWFActivity *)activity;

@end
