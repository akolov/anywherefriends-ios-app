//
//  AWFLayoutGuide.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 02/01/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "AWFConfig.h"
#import "AWFLayoutGuide.h"

@interface AWFLayoutGuide ()

@property (nonatomic, assign) CGFloat length;

@end

@implementation AWFLayoutGuide

- (id)initWithLength:(CGFloat)length {
  self = [super init];
  if (self) {
    self.length = length;
  }
  return self;
}

@end
