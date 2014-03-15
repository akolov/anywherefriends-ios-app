//
//  AWFProfileHeaderView.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/18/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

#import "AWFConfig.h"
#import "AWFProfileHeaderView.h"

#import <AXKCollectionViewTools/AXKCollectionViewTools.h>

#import "AWFShapeView.h"
#import "AWFLabelButton.h"
#import "AWFPhotoCollectionViewCell.h"
#import "UIBezierPath+AccessoryArrowGlyph.h"

@interface AWFProfileHeaderView ()

@property (nonatomic, strong) UICollectionView *photoCollectionView;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UIButton *locationButton;
@property (nonatomic, strong) AWFShapeView *arrowView;
@property (nonatomic, strong) AWFLabelButton *friendButton;
@property (nonatomic, strong) AWFLabelButton *messageButton;

@end

@implementation AWFProfileHeaderView

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

    // Set up other buttons

    self.friendButton = [AWFLabelButton autolayoutView];
    self.friendButton.layer.cornerRadius = 5.0f;
    self.friendButton.titleLabel.font = [UIFont helveticaNeueFontOfSize:16.0f];
    [self.friendButton setTitleText:NSLocalizedString(@"AWF_PROFILE_ADD_FRIEND_BUTTON_TITLE", nil)
                           forState:UIControlStateNormal];
    [self.friendButton setTitleText:NSLocalizedString(@"AWF_PROFILE_FRIENDS_BUTTON_TITLE", nil)
                           forState:UIControlStateSelected];
    [self.friendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.friendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.friendButton setBackgroundColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.friendButton setBackgroundColor:[UIColor awfGreenColor] forState:UIControlStateSelected];
    [self addSubview:self.friendButton];

    self.messageButton = [AWFLabelButton autolayoutView];
    self.messageButton.layer.cornerRadius = 5.0f;
    self.messageButton.titleLabel.font = [UIFont helveticaNeueFontOfSize:16.0f];
    [self.messageButton setTitleText:NSLocalizedString(@"AWF_PROFILE_OFFLINE_BUTTON_TITLE", nil)
                            forState:UIControlStateNormal];
    [self.messageButton setTitleText:NSLocalizedString(@"AWF_PROFILE_ONLINE_BUTTON_TITLE", nil)
                            forState:UIControlStateSelected];
    [self.messageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.messageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.messageButton setBackgroundColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.messageButton setBackgroundColor:[UIColor awfGreenColor] forState:UIControlStateSelected];
    [self addSubview:self.messageButton];

    // Set up constraints

    [self.photoCollectionView pinToFillContainerOnAxis:UILayoutConstraintAxisHorizontal];
    [self.photoCollectionView pinHeight:159.0f withRelation:NSLayoutRelationEqual];
    [self pin:@"V:|[photoCollectionView]-16.0-[descriptionLabel]-16.0-[locationButton]"
      options:NSLayoutFormatAlignAllCenterX owner:self];

    [self pin:@"H:|-[friendButton]-[messageButton(==friendButton)]-|"
      options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom owner:self];
    [self pin:@"V:[locationButton]-16.0-[friendButton]|" options:0 owner:self];
    [self.friendButton pinHeight:26.0f withRelation:NSLayoutRelationEqual];

    [self.locationButton pin:@"H:|[locationLabel][arrowView]|" options:0 owner:self];
    [self.locationLabel pinToFillContainerOnAxis:UILayoutConstraintAxisVertical];
    [self.arrowView pinToCenterInContainerOnAxis:UILayoutConstraintAxisVertical];
    [self pin:@"H:|-[locationButton]-|" options:0 owner:self];
  }
  return self;
}

@end
