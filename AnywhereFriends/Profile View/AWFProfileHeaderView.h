//
//  AWFProfileHeaderView.h
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/18/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

@import UIKit;

@class AWFIconButton;
@class AWFLabelButton;

@interface AWFProfileHeaderView : UIView

@property (nonatomic, strong, readonly) UICollectionView *photoCollectionView;
@property (nonatomic, strong, readonly) UILabel *descriptionLabel;
@property (nonatomic, strong, readonly) UILabel *locationLabel;
@property (nonatomic, strong, readonly) AWFIconButton *locationButton;
@property (nonatomic, strong, readonly) AWFLabelButton *friendButton;
@property (nonatomic, strong, readonly) AWFLabelButton *messageButton;

@end
