//
//  AWFBodyBuildFormatter.h
//  AnywhereFriends
//
//  Created by Alexander Kolov on 01/05/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

@import Foundation;

#import "AWFPerson.h"

@interface AWFBodyBuildFormatter : NSFormatter

- (NSString *)stringFromBodyBuild:(AWFBodyBuild)bodyBuild;

@end
