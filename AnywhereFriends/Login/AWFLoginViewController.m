//
//  AWFLoginViewController.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/4/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

#import "AWFLoginViewController.h"

#import <QuartzCore/QuartzCore.h>
#import <Slash/Slash.h>

#import "AWFNavigationTitleView.h"


@interface AWFLoginViewController ()

@end


@implementation AWFLoginViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.navigationController.navigationBarHidden = NO;
  self.navigationItem.titleView = [AWFNavigationTitleView navigationTitleView];

  self.view.backgroundColor = [UIColor defaultBackgroundColor];

  [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 0) {
    return 2;
  }
  else {
    return 1;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];

  if (indexPath.section == 0) {
    if (indexPath.row == 0) {
      cell.textLabel.text = NSLocalizedString(@"AWF_LOGIN_FORM_EMAIL_TITLE", @"Title of the email form field on the login screen");
    }
    else if (indexPath.row == 1) {
      cell.textLabel.text = NSLocalizedString(@"AWF_LOGIN_FORM_PASSWORD_TITLE", @"Title of the password form field on the login screen");
    }
  }
  else {

  }

  return cell;
}

#pragma mark - UITableView delegates

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if (section == 1) {
    return NSLocalizedString(@"AWF_LOGIN_FORM_CONNECT_WITH_TITLE", @"Title of connect with login section");
  }

  return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  return 65.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

  UIView *view = [[UIView alloc] initWithFrame:CGRectZero];

  if (section == 0) {
    UIButton *loginButton = [UIButton autolayoutButton];
    loginButton.backgroundColor = [UIColor blackColor];
    loginButton.frame = CGRectMake(10.0f, 0, 300.0f, 44.0f);
    loginButton.layer.cornerRadius = 2.0f;

    [loginButton setTitle:NSLocalizedString(@"AWF_LOGIN_FORM_LOGIN_BUTTON_TITLE", @"Title of the login button") forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    NSDictionary *const views = NSDictionaryOfVariableBindings(loginButton);

    [view addSubview:loginButton];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[loginButton]-|" options:0 metrics:nil views:views]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20.0-[loginButton]-4.0-|" options:0 metrics:nil views:views]];
  }
  else {

    NSDictionary *const style = @{@"$default": @{
                                      NSFontAttributeName            : [UIFont systemFontOfSize:16.0f],
                                      NSForegroundColorAttributeName : [UIColor blackColor]},
                                  @"strong": @{
                                      NSFontAttributeName            : [UIFont boldSystemFontOfSize:16.0f]}
                                  };

    NSString *markup = NSLocalizedString(@"AWF_LOGIN_FORM_SIGN_UP_LABEL", @"Title of the sign up label in the login form");
    NSAttributedString *attributedText = [SLSMarkupParser attributedStringWithMarkup:markup style:style error:NULL];

    UILabel *signupLabel = [UILabel autolayoutView];
    signupLabel.adjustsFontSizeToFitWidth = YES;
    signupLabel.attributedText = attributedText;
    signupLabel.textColor = [UIColor blackColor];
    signupLabel.minimumScaleFactor = 0.8f;
    signupLabel.numberOfLines = 1;

    NSDictionary *const views = NSDictionaryOfVariableBindings(signupLabel);

    [view addSubview:signupLabel];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[signupLabel]-|" options:0 metrics:nil views:views]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20.0-[signupLabel]" options:0 metrics:nil views:views]];
  }

  return view;
}

@end
