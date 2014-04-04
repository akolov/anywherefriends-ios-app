//
//  AWFSignupViewController.h
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/7/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

@import UIKit;

#import "AWFGender.h"

@interface AWFSignupViewController : UITableViewController

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, assign) AWFGender gender;

@end
