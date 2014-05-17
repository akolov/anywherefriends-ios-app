//
//  AWFMyProfileHeaderView.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 17/05/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "AWFConfig.h"
#import "AWFMyProfileHeaderView.h"

#import <AXKCollectionViewTools/AXKCollectionViewTools.h>

#import "AWFMyProfileHeaderView.h"
#import "AWFPhotoCollectionViewCell.h"
#import "AWFShapeView.h"
#import "UIBezierPath+AccessoryArrowGlyph.h"

@interface AWFMyProfileHeaderView ()

@property (nonatomic, strong) UICollectionView *photoCollectionView;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UIButton *locationButton;
@property (nonatomic, strong) AWFShapeView *arrowView;
@property (nonatomic, strong) AWFMyProfileHeaderView *headerView;

@end

@implementation AWFMyProfileHeaderView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {

    // Set up photo collection

    UICollectionViewFlowLayout *collectionLayout = [[UICollectionViewFlowLayout alloc] init];
    collectionLayout.itemSize = CGSizeMake(159.0f, 159.0f);
    collectionLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    collectionLayout.minimumLineSpacing = 2.0f;

    UICollectionView *photoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionLayout];
    photoCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.photoCollectionView = photoCollectionView;
    [self addSubview:photoCollectionView];

    [photoCollectionView registerClass:[AWFPhotoCollectionViewCell class] forCellWithReuseIdentifier:[AWFPhotoCollectionViewCell reuseIdentifier]];

    // Set up labels

    self.descriptionLabel = [UILabel autolayoutView];
    self.descriptionLabel.font = [UIFont helveticaNeueFontOfSize:14.0f];
    self.descriptionLabel.numberOfLines = 0;
    self.descriptionLabel.preferredMaxLayoutWidth = frame.size.width - 40.0f;
    self.descriptionLabel.textColor = [UIColor grayColor];
    [self addSubview:self.descriptionLabel];

    // Set up location button

    self.locationButton = [UIButton autolayoutView];
    [self addSubview:self.locationButton];

    self.locationLabel = [UILabel autolayoutView];
    self.locationLabel.numberOfLines = 0;
    self.locationLabel.preferredMaxLayoutWidth = frame.size.width - 40.0f;
    [self.locationButton addSubview:self.locationLabel];

    self.arrowView = [AWFShapeView autolayoutView];
    self.arrowView.path = [UIBezierPath accessoryArrowGlyph];
    self.arrowView.shapeLayer.fillColor = [UIColor grayColor].CGColor;
    [self.locationButton addSubview:self.arrowView];

    // Set up constraints

    [self.photoCollectionView pinToFillContainerOnAxis:UILayoutConstraintAxisHorizontal];
    [self pin:@"V:|[photoCollectionView(159.0)]-16.0-[descriptionLabel]-16.0-[locationButton]-16.0-|"
      options:NSLayoutFormatAlignAllCenterX owner:self];

    [self.locationButton pin:@"H:|[locationLabel][arrowView]|" options:0 owner:self];
    [self.locationLabel pinToFillContainerOnAxis:UILayoutConstraintAxisVertical];
    [self.arrowView pinToCenterInContainerOnAxis:UILayoutConstraintAxisVertical];
    [self pin:@"H:|-[locationButton]-|" options:0 owner:self];
  }
  return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
