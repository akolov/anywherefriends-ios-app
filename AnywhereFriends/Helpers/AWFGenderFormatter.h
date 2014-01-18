//
//  AWFGenderFormatter.h
//  AnywhereFriends
//
//  Created by Alexander Kolov on 19/01/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

@import Foundation;

#import "AWFGender.h"


@interface AWFGenderFormatter : NSFormatter

- (NSString *)stringFromGender:(AWFGender)gender;

@end
