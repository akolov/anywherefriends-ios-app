//
//  AWFLabelButton.h
//  AnywhereFriends
//
//  Created by Alexander Kolov on 7/29/13.
//  Copyright (c) 2013 AnywhereFriends. All rights reserved.
//

#import "AWFButton.h"


@interface AWFLabelButton : AWFButton

@property (nonatomic, strong, readonly) UILabel *titleLabel;

- (UIColor *)titleColorForState:(UIControlState)state;
- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state;

@end
