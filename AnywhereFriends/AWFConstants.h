//
//  AWFConstants.h
//  AnywhereFriends
//
//  Created by Alexander Kolov on 30/03/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

@import Foundation;

// API

OBJC_EXPORT NSString *const AWFAPIBaseURL;
OBJC_EXPORT NSString *const AWFAPIPathLogin;
OBJC_EXPORT NSString *const AWFAPIPathLogout;
OBJC_EXPORT NSString *const AWFAPIPathUser;
OBJC_EXPORT NSString *const AWFAPIPathUserActivity;
OBJC_EXPORT NSString *const AWFAPIPathUserActivityID;
OBJC_EXPORT NSString *const AWFAPIPathUserFriends;
OBJC_EXPORT NSString *const AWFAPIPathUserFriendsApprove;
OBJC_EXPORT NSString *const AWFAPIPathUserFriendsReject;
OBJC_EXPORT NSString *const AWFAPIPathUsers;

OBJC_EXPORT NSString *const AWFURLParameterEmail;
OBJC_EXPORT NSString *const AWFURLParameterPassword;
OBJC_EXPORT NSString *const AWFURLParameterFirstName;
OBJC_EXPORT NSString *const AWFURLParameterIDs;
OBJC_EXPORT NSString *const AWFURLParameterLastName;
OBJC_EXPORT NSString *const AWFURLParameterLocation;
OBJC_EXPORT NSString *const AWFURLParameterGender;
OBJC_EXPORT NSString *const AWFURLParameterFacebookToken;
OBJC_EXPORT NSString *const AWFURLParameterTwitterToken;
OBJC_EXPORT NSString *const AWFURLParameterVKToken;

// Facebook

#define AWF_FACEBOOK_PERMISSIONS @[@"email", @"user_birthday", @"user_likes", @"user_location"]

// Twitter

OBJC_EXPORT NSString *const AWFTwitterConsumerKey;
OBJC_EXPORT NSString *const AWFTwitterConsumerSecret;

// VK

#define AWF_VK_PERMISSIONS @[@"offline", @"email"]

// CoreData

OBJC_EXPORT NSString *const AWFPersistentStoreName;

// Errors

OBJC_EXPORT NSString *const AWFErrorDomain;

// User Defaults

OBJC_EXPORT NSString *const AWFUserDefaultsCurrentUserIDKey;

// Notifications

OBJC_EXPORT NSString *const AWFLoginRequiredNotification;
OBJC_EXPORT NSString *const AWFUserDidLoginNotification;
