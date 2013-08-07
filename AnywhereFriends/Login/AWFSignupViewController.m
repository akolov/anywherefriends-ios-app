//
//  AWFSignupViewController.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/7/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

#import "AWFSignupViewController.h"

#import "AWFLoginFormViewCell.h"
#import "AWFNavigationTitleView.h"


@interface AWFSignupViewController ()

@end


@implementation AWFSignupViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.navigationController.navigationBarHidden = NO;
  self.title = NSLocalizedString(@"AWF_LOGIN_FORM_SIGN_UP_TITLE", @"Title of the sign up form");

  self.view.backgroundColor = [UIColor awfDefaultBackgroundColor];

  [self.tableView registerClass:[AWFLoginFormViewCell class] forCellReuseIdentifier:[AWFLoginFormViewCell reuseIdentifier]];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  AWFLoginFormViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[AWFLoginFormViewCell reuseIdentifier] forIndexPath:indexPath];

  switch (indexPath.row) {
    case 0:
      cell.textLabel.text = NSLocalizedString(@"AWF_LOGIN_FORM_EMAIL_TITLE", @"Title of the email form field on the login screen");
      cell.textField.placeholder = NSLocalizedString(@"AWF_LOGIN_FORM_EMAIL_PLACEHOLDER", @"Placeholder text of the email form field on the login screen");
      break;
    case 1:
      cell.textLabel.text = NSLocalizedString(@"AWF_LOGIN_FORM_PASSWORD_TITLE", @"Title of the password form field on the login screen");
      cell.textField.placeholder = NSLocalizedString(@"AWF_LOGIN_FORM_PASSWORD_PLACEHOLDER", @"Placeholder text of the password form field on the login screen");
      break;
    case 2:
      cell.textLabel.text = NSLocalizedString(@"AWF_LOGIN_FORM_PASSWORD_CONFIRMATION_TITLE", @"Title of the password confirmation form field on the login screen");
      cell.textField.placeholder = NSLocalizedString(@"AWF_LOGIN_FORM_PASSWORD_CONFIRMATION_PLACEHOLDER", @"Placeholder text of the password confirmation form field on the login screen");
      break;
    case 3:
      cell.textLabel.text = NSLocalizedString(@"AWF_LOGIN_FORM_FIRST_NAME_TITLE", @"Title of the first field form field on the login screen");
      cell.textField.placeholder = NSLocalizedString(@"AWF_LOGIN_FORM_FIRST_NAME_PLACEHOLDER", @"Placeholder text of the first field form field on the login screen");
      break;
    case 4:
      cell.textLabel.text = NSLocalizedString(@"AWF_LOGIN_FORM_LAST_NAME_TITLE", @"Title of the last name form field on the login screen");
      cell.textField.placeholder = NSLocalizedString(@"AWF_LOGIN_FORM_LAST_NAME_PLACEHOLDER", @"Placeholder text of the last name form field on the login screen");
      break;
  }

  return cell;
}

@end
