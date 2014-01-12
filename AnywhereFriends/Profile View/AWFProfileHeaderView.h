//
//  AWFProfileHeaderView.h
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/18/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AWFLabelButton.h"


@interface AWFProfileHeaderView : UIView

@property (nonatomic, weak, readonly) UICollectionView *photoCollectionView;
@property (nonatomic, weak, readonly) UILabel *descriptionLabel;
@property (nonatomic, weak, readonly) UILabel *locationLabel;
@property (nonatomic, weak, readonly) AWFLabelButton *followButton;
@property (nonatomic, weak, readonly) AWFLabelButton *messageButton;

@end
