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
NSString *const AWFAPIPathLoginFacebook = @"login/fb/";
NSString *const AWFAPIPathLoginTwitter = @"login/twitter/";
NSString *const AWFAPIPathLoginVK = @"login/vk/";
NSString *const AWFAPIPathLogout = @"logout/";
NSString *const AWFAPIPathUser = @"user/";
NSString *const AWFAPIPathUserActivity = @"user/activity/";
NSString *const AWFAPIPathUserActivityID = @"user/activity/:activityID";
NSString *const AWFAPIPathUserFriends = @"user/friends/";
NSString *const AWFAPIPathUserFriendsApprove = @"user/friends/approve/";
NSString *const AWFAPIPathUserFriendsReject = @"user/friends/reject/";
NSString *const AWFAPIPathUsers = @"users/";

NSString *const AWFURLParameterEmail = @"email";
NSString *const AWFURLParameterPassword = @"password";
NSString *const AWFURLParameterFirstName = @"first_name";
NSString *const AWFURLParameterIDs = @"ids";
NSString *const AWFURLParameterLastName = @"last_name";
NSString *const AWFURLParameterLocation = @"location";
NSString *const AWFURLParameterGender = @"gender";
NSString *const AWFURLParameterToken = @"token";
NSString *const AWFURLParameterTokenSecret = @"token_secret";

// Twitter

NSString *const AWFTwitterConsumerKey = @"IJ1DicuT1NAzv0CcK55LoULLj";
NSString *const AWFTwitterConsumerSecret = @"VclwTngguqHic5lyYgeKYFmNuNpiCCEBQ5TYytMFe6GR6RKF3c";

// CoreData

NSString *const AWFPersistentStoreName = @"AnywhereFriends.sqlite";

// Errors

NSString *const AWFErrorDomain = @"com.anywherefriends";

// User Defaults

NSString *const AWFUserDefaultsCurrentUserIDKey = @"AWFUserDefaultsCurrentUserIDKey";

// Notifications

NSString *const AWFLoginRequiredNotification = @"AWFLoginRequiredNotification";
NSString *const AWFUserDidLoginNotification = @"AWFUserDidLoginNotification";
