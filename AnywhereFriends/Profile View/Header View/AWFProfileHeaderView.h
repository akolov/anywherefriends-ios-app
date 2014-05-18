//
//  AWFProfileHeaderView.h
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/18/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

@import UIKit;

#import "AWFPerson.h"

@class AWFLabelButton;

@interface AWFProfileHeaderView : UIView

@property (nonatomic, strong, readonly) UICollectionView *photoCollectionView;
@property (nonatomic, strong, readonly) UILabel *descriptionLabel;
@property (nonatomic, strong, readonly) UILabel *locationLabel;
@property (nonatomic, strong, readonly) UIButton *locationButton;
@property (nonatomic, strong, readonly) AWFLabelButton *friendButton;
@property (nonatomic, strong, readonly) AWFLabelButton *messageButton;

- (void)setFriendshipStatus:(AWFFriendshipStatus)status;

@end
