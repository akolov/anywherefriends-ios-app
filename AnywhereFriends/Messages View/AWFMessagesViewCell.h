//
//  AWFMessagesViewCell.h
//  AnywhereFriends
//
//  Created by Alexander Kolov on 15/03/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

@import UIKit;

@interface AWFMessagesViewCell : UITableViewCell

@property (nonatomic, strong, readonly) UILabel *nameLabel;
@property (nonatomic, strong, readonly) UILabel *timeLabel;
@property (nonatomic, strong, readonly) UILabel *lastMessageLabel;
@property (nonatomic, strong, readonly) UILabel *placeholderView;
@property (nonatomic, strong, readonly) UIView *unreadIndicator;

@end
