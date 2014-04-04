//
//  AWFLoginConnectViewCell.h
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/6/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

@import UIKit;

@class AWFIconButton;

@interface AWFLoginConnectViewCell : UITableViewCell

@property (nonatomic, strong, readonly) AWFIconButton *facebookButton;
@property (nonatomic, strong, readonly) AWFIconButton *twitterButton;
@property (nonatomic, strong, readonly) AWFIconButton *vkontakteButton;

@property (nonatomic, copy) void (^onFacebookButtonAction)(void);
@property (nonatomic, copy) void (^onTwitterButtonAction)(void);
@property (nonatomic, copy) void (^onVkontakteButtonAction)(void);

@end
