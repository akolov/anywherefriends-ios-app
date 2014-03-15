//
//  AWFLoginConnectViewCell.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/6/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

#import "AWFConfig.h"
#import "AWFLoginConnectViewCell.h"

#import "AWFIconButton.h"
#import "AWFShapeView.h"
#import "UIBezierPath+FacebookGlyph.h"
#import "UIBezierPath+TwitterGlyph.h"
#import "UIBezierPath+VKontakteGlyph.h"

static CGFloat const AWFButtonSize = 45.0f;

@interface AWFLoginConnectViewCell ()

@property (nonatomic, strong) AWFIconButton *facebookButton;
@property (nonatomic, strong) AWFIconButton *twitterButton;
@property (nonatomic, strong) AWFIconButton *vkontakteButton;

@end

@implementation AWFLoginConnectViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    // Facebook button

    UIImage *facebookBackground = UIGraphicsContextWithOptions(CGSizeMake(AWFButtonSize, AWFButtonSize), NO, 0, ^(CGRect rect, CGContextRef context) {
      UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:12.0f];
      [path addClip];

      NSArray *components = @[(__bridge id)[UIColor colorWithDecimalRed:67.0f green:228.0f blue:252.0f alpha:1.0f].CGColor,
                              (__bridge id)[UIColor colorWithDecimalRed:34.0f green:102.0f blue:235.0f alpha:1.0f].CGColor];

      CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
      CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)components, NULL);
      CGContextDrawLinearGradient(context, gradient, CGPointZero, CGPointMake(0, CGRectGetHeight(rect)), 0);
      CGGradientRelease(gradient);
      CGColorSpaceRelease(colorSpace);
    });

    self.facebookButton = [AWFIconButton autolayoutView];
    self.facebookButton.backgroundColor = [UIColor whiteColor];
    self.facebookButton.icon.path = [UIBezierPath facebookGlyph];

    [self.facebookButton setBackgroundImage:facebookBackground forState:UIControlStateNormal];
    [self.facebookButton setIconColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.contentView addSubview:self.facebookButton];

    // Twitter button

    UIImage *twitterBackground = UIGraphicsContextWithOptions(CGSizeMake(AWFButtonSize, AWFButtonSize), NO, 0, ^(CGRect rect, CGContextRef context) {
      UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:12.0f];
      [path addClip];

      NSArray *components = @[(__bridge id)[UIColor colorWithDecimalRed:157.0f green:253.0f blue:248.0f alpha:1.0f].CGColor,
                              (__bridge id)[UIColor colorWithDecimalRed:40.0f green:164.0f blue:246.0f alpha:1.0f].CGColor];

      CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
      CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)components, NULL);
      CGContextDrawLinearGradient(context, gradient, CGPointZero, CGPointMake(0, CGRectGetHeight(rect)), 0);
      CGGradientRelease(gradient);
      CGColorSpaceRelease(colorSpace);
    });

    self.twitterButton = [AWFIconButton autolayoutView];
    self.twitterButton.backgroundColor = [UIColor whiteColor];
    self.twitterButton.icon.path = [UIBezierPath twitterGlyph];

    [self.twitterButton setBackgroundImage:twitterBackground forState:UIControlStateNormal];
    [self.twitterButton setIconColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.contentView addSubview:self.twitterButton];

    // VKontakte button

    UIImage *vkontakteBackground = UIGraphicsContextWithOptions(CGSizeMake(AWFButtonSize, AWFButtonSize), NO, 0, ^(CGRect rect, CGContextRef context) {
      UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:12.0f];
      [path addClip];

      NSArray *components = @[(__bridge id)[UIColor colorWithDecimalRed:177.0f green:216.0f blue:239.0f alpha:1.0f].CGColor,
                              (__bridge id)[UIColor colorWithDecimalRed:41.0f green:138.0f blue:196.0f alpha:1.0f].CGColor];

      CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
      CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)components, NULL);
      CGContextDrawLinearGradient(context, gradient, CGPointZero, CGPointMake(0, CGRectGetHeight(rect)), 0);
      CGGradientRelease(gradient);
      CGColorSpaceRelease(colorSpace);
    });

    self.vkontakteButton = [AWFIconButton autolayoutView];
    self.vkontakteButton.backgroundColor = [UIColor whiteColor];
    self.vkontakteButton.icon.path = [UIBezierPath vkontakteGlyph];

    [self.vkontakteButton setBackgroundImage:vkontakteBackground forState:UIControlStateNormal];
    [self.vkontakteButton setIconColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.contentView addSubview:self.vkontakteButton];

    // Autolayout

    UIView *spacerOne = [UIView autolayoutView];
    [self.contentView addSubview:spacerOne];

    UIView *spacerTwo = [UIView autolayoutView];
    [self.contentView addSubview:spacerTwo];

    UIView *spacerThree = [UIView autolayoutView];
    [self.contentView addSubview:spacerThree];

    UIView *spacerFour = [UIView autolayoutView];
    [self.contentView addSubview:spacerFour];

    NSDictionary *const metrics = @{@"size": @(AWFButtonSize)};
    NSDictionary *const views = NSDictionaryOfVariableBindings(_facebookButton, _twitterButton, _vkontakteButton, spacerOne, spacerTwo, spacerThree, spacerFour);
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[spacerOne][_facebookButton(size)][spacerTwo(==spacerOne)][_twitterButton(==_facebookButton)][spacerThree(==spacerOne)][_vkontakteButton(==_facebookButton)][spacerFour(==spacerOne)]|" options:0 metrics:metrics views:views]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.facebookButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.facebookButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:AWFButtonSize]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.twitterButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.twitterButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:AWFButtonSize]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.vkontakteButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.vkontakteButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:AWFButtonSize]];
  }

  return self;
}

@end
