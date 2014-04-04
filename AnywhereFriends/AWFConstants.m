//
//  AWFConstants.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 30/03/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "AWFConstants.h"

NSString *const AWFAPIBaseURL = @"http://api.awf.spoofa.info/v1/";
NSString *const AWFAPIPathLogin = @"login/";
NSString *const AWFAPIPathLogout = @"logout/";
NSString *const AWFAPIPathUser = @"user/";
NSString *const AWFAPIPathUserActivity = @"user/activity/";
NSString *const AWFAPIPathUserActivityID = @"user/activity/:activityID";
NSString *const AWFAPIPathUserFriends = @"user/friends/";
NSString *const AWFAPIPathUsers = @"users/";

NSString *const AWFURLParameterEmail = @"email";
NSString *const AWFURLParameterPassword = @"password";
NSString *const AWFURLParameterFirstName = @"first_name";
NSString *const AWFURLParameterIDs = @"ids";
NSString *const AWFURLParameterLastName = @"last_name";
NSString *const AWFURLParameterLocation = @"location";
NSString *const AWFURLParameterGender = @"gender";
NSString *const AWFURLParameterFacebookToken = @"facebook_token";
NSString *const AWFURLParameterTwitterToken = @"twitter_token";
NSString *const AWFURLParameterVKToken = @"vk_token";

// CoreData

NSString *const AWFPersistentStoreName = @"AnywhereFriends.sqlite";

// Errors

NSString *const AWFErrorDomain = @"com.anywherefriends";

// User Defaults

NSString *const AWFUserDefaultsCurrentUserIDKey = @"AWFUserDefaultsCurrentUserIDKey";
