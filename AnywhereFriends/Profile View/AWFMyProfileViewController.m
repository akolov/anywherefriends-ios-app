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

#import "AWFPerson.h"
#import "AWFSession.h"

@implementation AWFMyProfileViewController

- (void)viewDidAppear:(BOOL)animated {
  @weakify(self);
  [[[AWFSession sharedSession] getUserSelf]
   subscribeNext:^(AWFPerson *person) {
     @strongify(self);
     self.personID = person.personID;
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

#pragma mark - Accessors 

- (NSString *)personID {
  return [AWFSession sharedSession].currentUserID;
}

@end
