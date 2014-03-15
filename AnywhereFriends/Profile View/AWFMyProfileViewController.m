//
//  AWFMyProfileViewController.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 15/03/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "AWFConfig.h"
#import "AWFMyProfileViewController.h"

#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "AWFSession.h"

@interface AWFMyProfileViewController ()

@end

@implementation AWFMyProfileViewController

- (void)viewDidLoad {
  [[[AWFSession sharedSession] getUserSelf]
   subscribeNext:^(AWFPerson *person) {
     self.person = person;
     [super viewDidLoad];
     self.navigationItem.rightBarButtonItem = self.editButtonItem;
   }
   error:^(NSError *error) {
     ErrorLog(error.localizedDescription);
   }];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
