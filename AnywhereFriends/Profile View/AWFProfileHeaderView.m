//
//  AWFProfileHeaderView.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/18/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

#import "AWFProfileHeaderView.h"

#import <AXKCollectionViewTools/AXKCollectionViewTools.h>

#import "UIBezierPath+AccessoryArrowGlyph.h"

#import "AWFIconButton.h"
#import "AWFPhotoCollectionViewCell.h"


@interface AWFProfileHeaderView ()

@property (nonatomic, weak) UICollectionView *photoCollectionView;
@property (nonatomic, weak) UILabel *descriptionLabel;
@property (nonatomic, weak) UILabel *locationLabel;
@property (nonatomic, weak) AWFLabelButton *followButton;
@property (nonatomic, weak) AWFLabelButton *messageButton;

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

    UILabel *descriptionLabel = [UILabel autolayoutView];
    descriptionLabel.font = [UIFont helveticaNeueFontOfSize:14.0f];
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.preferredMaxLayoutWidth = frame.size.width - 40.0f;
    descriptionLabel.textColor = [UIColor grayColor];
    self.descriptionLabel = descriptionLabel;
    [self addSubview:descriptionLabel];

    // Set up location button

    UILabel *locationLabel = [UILabel autolayoutView];
    locationLabel.numberOfLines = 0;
    locationLabel.preferredMaxLayoutWidth = frame.size.width - 40.0f;
    self.locationLabel = locationLabel;
    [self addSubview:locationLabel];

    AWFIconButton *locationButton = [AWFIconButton autolayoutView];
    locationButton.icon.path = [UIBezierPath accessoryArrowGlyph];
    [locationButton setIconColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self addSubview:locationButton];

    // Set up other buttons

    AWFLabelButton *followButton = [AWFLabelButton autolayoutView];
    followButton.layer.cornerRadius = 5.0f;
    followButton.titleLabel.font = [UIFont helveticaNeueFontOfSize:16.0f];
    [followButton setTitleText:NSLocalizedString(@"AWF_PROFILE_FOLLOW_BUTTON_TITLE", @"Title of the follow button of the profile view") forState:UIControlStateNormal];
    [followButton setTitleText:NSLocalizedString(@"AWF_PROFILE_FOLLOWING_BUTTON_TITLE", @"Title of the following button of the profile view") forState:UIControlStateSelected];
    [followButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [followButton setBackgroundColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [followButton setBackgroundColor:[UIColor awfGreenColor] forState:UIControlStateSelected];
    self.followButton = followButton;
    [self addSubview:followButton];

    AWFLabelButton *messageButton = [AWFLabelButton autolayoutView];
    messageButton.layer.cornerRadius = 5.0f;
    messageButton.titleLabel.font = [UIFont helveticaNeueFontOfSize:16.0f];
    [messageButton setTitleText:NSLocalizedString(@"AWF_PROFILE_OFFLINE_BUTTON_TITLE", @"Title of the offline button of the profile view") forState:UIControlStateNormal];
    [messageButton setTitleText:NSLocalizedString(@"AWF_PROFILE_ONLINE_BUTTON_TITLE", @"Title of the online button of the profile view") forState:UIControlStateSelected];
    [messageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [messageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [messageButton setBackgroundColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [messageButton setBackgroundColor:[UIColor awfGreenColor] forState:UIControlStateSelected];
    self.messageButton = messageButton;
    [self addSubview:messageButton];

    // Set up constraints

    NSDictionary *const views = NSDictionaryOfVariableBindings(photoCollectionView, descriptionLabel, locationLabel, locationButton, followButton, messageButton);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[photoCollectionView]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[followButton]-[messageButton(==followButton)]-|" options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20.0-[locationLabel][locationButton(6.0)]-20.0-|" options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[photoCollectionView(159.0)]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[photoCollectionView]-16.0-[descriptionLabel]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[descriptionLabel]-16.0-[locationLabel]-20.0-[followButton(26.0)]|" options:0 metrics:nil views:views]];
  }
  return self;
}

@end
