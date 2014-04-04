//
//  AWFProfileViewController.h
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/18/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

@import UIKit;

@class AWFProfileHeaderView;

@interface AWFProfileViewController : UITableViewController

@property (nonatomic, strong, readonly) AWFProfileHeaderView *headerView;
@property (nonatomic, strong) NSString *personID;

- (id)initWithPersonID:(NSString *)personID;

@end
