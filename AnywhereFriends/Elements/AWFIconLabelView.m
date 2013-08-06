//
//  AWFIconLabelView.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/5/13.
//  Copyright (c) 2013 AnywhereFriends. All rights reserved.
//

#import "AWFIconLabelView.h"


@interface AWFIconLabelView ()

@property (nonatomic, strong) AWFShapeView *icon;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, weak) NSLayoutConstraint *spacingConstraint;

- (void)initIconLabelView;

@end


@implementation AWFIconLabelView

- (void)initIconLabelView {
  self.icon = [AWFShapeView autolayoutView];
  [self addSubview:self.icon];

  self.label = [UILabel autolayoutView];
  [self addSubview:self.label];

  NSDictionary *const views = NSDictionaryOfVariableBindings(_icon, _label);
  NSLayoutConstraint *spacingConstraint = [NSLayoutConstraint constraintWithItem:self.icon attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.label attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0];
  self.spacingConstraint = spacingConstraint;

  [self addConstraint:spacingConstraint];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_icon]|" options:0 metrics:nil views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_label]|" options:0 metrics:nil views:views]];
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self initIconLabelView];
  }
  return self;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  [self initIconLabelView];
}

- (CGSize)intrinsicContentSize {
  return CGSizeMake(self.icon.intrinsicContentSize.width + self.label.intrinsicContentSize.width - self.spacing, MAX(self.icon.intrinsicContentSize.height, self.label.intrinsicContentSize.height));
}

#pragma mark - Public methods

- (void)setSpacing:(CGFloat)spacing {
  _spacing = spacing;
  self.spacingConstraint.constant = spacing;
  [self invalidateIntrinsicContentSize];
}

@end
