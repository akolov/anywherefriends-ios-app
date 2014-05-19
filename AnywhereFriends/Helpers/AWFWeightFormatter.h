//
//  AWFWeightFormatter.h
//  AnywhereFriends
//
//  Created by Alexander Kolov on 09/03/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

@import Foundation;

@interface AWFWeightFormatter : NSFormatter

- (NSString *)stringFromWeight:(NSNumber *)weight;

+ (float)kilogramsWithPounds:(float)pounds;

@end
