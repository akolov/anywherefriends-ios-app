//
//  AWFGenderPicker.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 20/10/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

#import "AWFConfig.h"
#import "AWFGenderPicker.h"

#import "UIColor+CustomColors.h"

@interface AWFGenderPicker ()

@property (nonatomic, strong) UIButton *femaleButton;
@property (nonatomic, strong) UIButton *maleButton;

- (void)onButtonTouchUpInside:(UIButton *)sender;

@end

@implementation AWFGenderPicker

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.femaleButton = [UIButton autolayoutView];
    self.femaleButton.titleLabel.font = [UIFont helveticaNeueCondensedLightFontOfSize:16.0f];
    [self.femaleButton setTitle:NSLocalizedString(@"AWF_LOGIN_FORM_GENDER_FEMALE", nil) forState:UIControlStateNormal];
    [self.femaleButton setTitleColor:[UIColor colorWithRed:0.796 green:0.796 blue:0.815 alpha:1.0f] forState:UIControlStateNormal];
    [self.femaleButton setTitleColor:[UIColor awfBlueTextColor] forState:UIControlStateSelected];
    [self.femaleButton addTarget:self action:@selector(onButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.femaleButton];

    self.maleButton = [UIButton autolayoutView];
    self.maleButton.titleLabel.font = [UIFont helveticaNeueCondensedLightFontOfSize:16.0f];
    [self.maleButton setTitle:NSLocalizedString(@"AWF_LOGIN_FORM_GENDER_MALE", nil) forState:UIControlStateNormal];
    [self.maleButton setTitleColor:[UIColor colorWithRed:0.796 green:0.796 blue:0.815 alpha:1.0f] forState:UIControlStateNormal];
    [self.maleButton setTitleColor:[UIColor awfBlueTextColor] forState:UIControlStateSelected];
    [self.maleButton addTarget:self action:@selector(onButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.maleButton];

    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_femaleButton][_maleButton(==_femaleButton)]|"
                                             options:NSLayoutFormatAlignAllBaseline
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(_femaleButton, _maleButton)]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.femaleButton
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0f
                                                      constant:0]];
  }
  return self;
}

- (void)onButtonTouchUpInside:(UIButton *)sender {
  if (sender == self.femaleButton) {
    self.femaleButton.selected = YES;
    self.maleButton.selected = NO;
  }
  else {
    self.femaleButton.selected = NO;
    self.maleButton.selected = YES;
  }
}

- (NSString *)gender {
  return self.femaleButton.selected ? @"female" : @"male";
}

@end
