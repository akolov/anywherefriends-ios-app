//
//  AWFProfileViewController.h
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/18/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

@import UIKit;

#import "AWFPerson.h"
#import "AWFProfileHeaderView.h"


@interface AWFProfileViewController : UITableViewController

@property (nonatomic, readonly) AWFProfileHeaderView *headerView;
@property (nonatomic, strong) AWFPerson *person;

- (id)initWithPerson:(AWFPerson *)person;

@end
