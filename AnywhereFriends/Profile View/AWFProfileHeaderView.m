//
//  AWFProfileHeaderView.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/18/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

#import "AWFProfileHeaderView.h"

#import <AXKCollectionViewTools/AXKCollectionViewTools.h>

#import "AWFIconButton.h"
#import "AWFLabelButton.h"
#import "AWFPhotoCollectionViewCell.h"
#import "UIBezierPath+AccessoryArrowGlyph.h"

@interface AWFProfileHeaderView ()

@property (nonatomic, strong) UICollectionView *photoCollectionView;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) AWFIconButton *locationButton;
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

    self.locationLabel = [UILabel autolayoutView];
    self.locationLabel.numberOfLines = 0;
    self.locationLabel.preferredMaxLayoutWidth = frame.size.width - 40.0f;
    [self addSubview:self.locationLabel];

    self.locationButton = [AWFIconButton autolayoutView];
    self.locationButton.icon.path = [UIBezierPath accessoryArrowGlyph];
    [self.locationButton setIconColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self addSubview:self.locationButton];

    // Set up other buttons

    self.friendButton = [AWFLabelButton autolayoutView];
    self.friendButton.layer.cornerRadius = 5.0f;
    self.friendButton.titleLabel.font = [UIFont helveticaNeueFontOfSize:16.0f];
    [self.friendButton setTitleText:NSLocalizedString(@"AWF_PROFILE_ADD_FRIEND_BUTTON_TITLE", nil) forState:UIControlStateNormal];
    [self.friendButton setTitleText:NSLocalizedString(@"AWF_PROFILE_FRIENDS_BUTTON_TITLE", nil) forState:UIControlStateSelected];
    [self.friendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.friendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.friendButton setBackgroundColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.friendButton setBackgroundColor:[UIColor awfGreenColor] forState:UIControlStateSelected];
    [self addSubview:self.friendButton];

    self.messageButton = [AWFLabelButton autolayoutView];
    self.messageButton.layer.cornerRadius = 5.0f;
    self.messageButton.titleLabel.font = [UIFont helveticaNeueFontOfSize:16.0f];
    [self.messageButton setTitleText:NSLocalizedString(@"AWF_PROFILE_OFFLINE_BUTTON_TITLE", nil) forState:UIControlStateNormal];
    [self.messageButton setTitleText:NSLocalizedString(@"AWF_PROFILE_ONLINE_BUTTON_TITLE", nil) forState:UIControlStateSelected];
    [self.messageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.messageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.messageButton setBackgroundColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.messageButton setBackgroundColor:[UIColor awfGreenColor] forState:UIControlStateSelected];
    [self addSubview:self.messageButton];

    // Set up constraints

    NSDictionary *const views = NSDictionaryOfVariableBindings(photoCollectionView, _descriptionLabel, _locationLabel, _locationButton, _friendButton, _messageButton);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[photoCollectionView]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_friendButton]-[_messageButton(==_friendButton)]-|" options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20.0-[_locationLabel][_locationButton(6.0)]-20.0-|" options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[photoCollectionView(159.0)]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[photoCollectionView]-16.0-[_descriptionLabel]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_descriptionLabel]-16.0-[_locationLabel]-20.0-[_friendButton(26.0)]|" options:0 metrics:nil views:views]];
  }
  return self;
}

@end
