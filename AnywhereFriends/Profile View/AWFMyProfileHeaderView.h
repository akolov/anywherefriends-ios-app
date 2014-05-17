//
//  AWFMyProfileHeaderView.h
//  AnywhereFriends
//
//  Created by Alexander Kolov on 17/05/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

@import UIKit;

@interface AWFMyProfileHeaderView : UIView

@property (nonatomic, strong, readonly) UICollectionView *photoCollectionView;
@property (nonatomic, strong, readonly) UILabel *descriptionLabel;
@property (nonatomic, strong, readonly) UILabel *locationLabel;
@property (nonatomic, strong, readonly) UIButton *locationButton;

@end
