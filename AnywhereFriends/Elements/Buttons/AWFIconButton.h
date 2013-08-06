//
//  AWFIconButton.h
//  AnywhereFriends
//
//  Created by Alexander Kolov on 7/29/13.
//  Copyright (c) 2013 AnywhereFriends. All rights reserved.
//

#import "AWFButton.h"
#import "AWFShapeView.h"


@interface AWFIconButton : AWFButton

@property (nonatomic, strong, readonly) AWFShapeView *icon;

- (UIColor *)iconColorForState:(UIControlState)state;
- (void)setIconColor:(UIColor *)color forState:(UIControlState)state;

@end
