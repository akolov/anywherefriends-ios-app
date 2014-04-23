//
//  AWFMessagesRequestCell.h
//  AnywhereFriends
//
//  Created by Alexander Kolov on 22/04/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

@import UIKit;

@interface AWFMessagesRequestCell : UITableViewCell

@property (nonatomic, strong, readonly) UILabel *nameLabel;
@property (nonatomic, strong, readonly) UILabel *timeLabel;
@property (nonatomic, strong, readonly) UILabel *lastMessageLabel;
@property (nonatomic, strong, readonly) UILabel *placeholderView;
@property (nonatomic, strong, readonly) UIButton *acceptButton;
@property (nonatomic, strong, readonly) UIButton *ignoreButton;
@property (nonatomic, copy) void (^onAcceptAction)(void);
@property (nonatomic, copy) void (^onIgnoreAction)(void);

@end
