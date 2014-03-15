//
//  AWFPerson.h
//  AnywhereFriends
//
//  Created by Alexander Kolov on 12/01/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

@import Foundation;
@import CoreLocation.CLLocation;

#import "AWFObject.h"
#import "AWFGender.h"

@interface AWFPerson : AWFObject

@property (nonatomic, assign) AWFGender gender;
@property (nonatomic, strong) NSString *personID;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *bio;
@property (nonatomic, readonly) NSUInteger age;
@property (nonatomic, strong) NSDate *birthday;
@property (nonatomic, strong) NSNumber *weight;
@property (nonatomic, strong) NSNumber *height;
@property (nonatomic, strong) NSString *hairLength;
@property (nonatomic, strong) NSString *hairColor;
@property (nonatomic, strong) NSString *eyeColor;
@property (nonatomic, strong) NSString *bodyBuild;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSDictionary *placemark;
@property (nonatomic, assign) CLLocationDistance distance;

+ (instancetype)personFromDictionary:(NSDictionary *)dictionary;

- (NSString *)fullName;
- (NSString *)abbreviatedName;
- (NSString *)locationName;

@end
