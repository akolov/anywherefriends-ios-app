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

@end
