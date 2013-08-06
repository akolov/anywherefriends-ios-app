//
//  AWFIconLabelButton.h
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/5/13.
//  Copyright (c) 2013 AnywhereFriends. All rights reserved.
//

#import "AWFButton.h"
#import "AWFIconLabelView.h"


@interface AWFIconLabelButton : AWFButton

@property (nonatomic, strong, readonly) AWFIconLabelView *contentView;
@property (nonatomic, readonly) AWFShapeView *icon;
@property (nonatomic, readonly) UILabel *titleLabel;

- (UIColor *)titleColorForState:(UIControlState)state;
- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state;

@end
