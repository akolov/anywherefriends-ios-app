//
//  AWFSignupViewController.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/7/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

#import "AWFSignupViewController.h"

#import "UIImage+CustomBackgrounds.h"

#import "AWFLoginFormViewCell.h"
#import "AWFNavigationTitleView.h"


@interface AWFSignupViewController ()

- (UIView *)tableFooterView;

@end


@implementation AWFSignupViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.navigationController.navigationBarHidden = NO;
  self.title = NSLocalizedString(@"AWF_LOGIN_FORM_SIGN_UP_TITLE", @"Title of the sign up form");

  self.tableView.showsHorizontalScrollIndicator = NO;
  self.tableView.showsVerticalScrollIndicator = NO;
  self.tableView.tableFooterView = [self tableFooterView];
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

#pragma mark - UITableView

- (UIView *)tableFooterView {
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 50.0f)];

  UIButton *loginButton = [UIButton autolayoutButton];
  loginButton.backgroundColor = nil;
  loginButton.frame = CGRectMake(10.0f, 0, 300.0f, 44.0f);
  loginButton.layer.cornerRadius = 2.0f;
  loginButton.titleLabel.font = [UIFont helveticaNeueCondensedMediumFontOfSize:16.0f];
  loginButton.titleLabel.layer.shadowColor = [UIColor whiteColor].CGColor;
  loginButton.titleLabel.layer.shadowOffset = CGSizeMake(0, 1.0f);
  loginButton.titleLabel.layer.shadowOpacity = 1.0f;
  loginButton.titleLabel.layer.shadowRadius = 0;

  [loginButton setTitle:NSLocalizedString(@"AWF_LOGIN_FORM_SIGNUP_BUTTON_TITLE", @"Title of the signup button") forState:UIControlStateNormal];
  [loginButton setTitleColor:[UIColor awfBlueTextColor] forState:UIControlStateNormal];

  NSDictionary *const options = @{UIImageGradientColors: @[[UIColor colorWithDecimalWhite:231.0f alpha:1.0f], [UIColor whiteColor]],
                                  UIImageBottomStrokeColor: [UIColor whiteColor],
                                  UIImageStrokeColor: [UIColor colorWithDecimalWhite:190.0f alpha:1.0f],
                                  UIImageStrokeWidth: @(1.2f)};

  UIImage *normalImage = [UIImage normalPushImageWithSize:CGSizeMake(10.0f, 45.0f) gradient:@[[UIColor whiteColor], [UIColor colorWithWhite:0.95f alpha:1.0f]] backgroundColor:[UIColor awfDefaultBackgroundColor] cornerRadius:3.0f];
  UIImage *highlightedImage = [UIImage buttonImageWithSize:CGSizeMake(10.0f, 45.0f) options:options cornerRadius:3.0f];

  [loginButton setBackgroundImage:normalImage forState:UIControlStateNormal];
  [loginButton setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];

  NSDictionary *const views = NSDictionaryOfVariableBindings(loginButton);

  [view addSubview:loginButton];
  [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[loginButton]-|" options:0 metrics:nil views:views]];
  [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[loginButton(40.0)]" options:0 metrics:nil views:views]];

  return view;
}

@end
