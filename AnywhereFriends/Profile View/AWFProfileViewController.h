//
//  AWFProfileViewController.h
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/18/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

@import UIKit;

@class AWFPerson;
@class AWFProfileHeaderView;

@interface AWFProfileViewController : UITableViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, readonly) AWFPerson *person;
@property (nonatomic, readonly) UIView *profileHeaderView;
@property (nonatomic, strong) NSString *personID;

- (id)initWithPersonID:(NSString *)personID;
- (void)reloadHeaderView;

@end
