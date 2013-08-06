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

#import "UIImage+CustomBackgrounds.h"

#import "AWFLoginConnectViewCell.h"
#import "AWFLoginFormViewCell.h"
#import "AWFNavigationTitleView.h"


@interface AWFLoginViewController ()

@end


@implementation AWFLoginViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.navigationController.navigationBarHidden = NO;
  self.navigationItem.titleView = [AWFNavigationTitleView navigationTitleView];

  self.view.backgroundColor = [UIColor defaultBackgroundColor];

  [self.tableView registerClass:[AWFLoginConnectViewCell class] forCellReuseIdentifier:[AWFLoginConnectViewCell reuseIdentifier]];
  [self.tableView registerClass:[AWFLoginFormViewCell class] forCellReuseIdentifier:[AWFLoginFormViewCell reuseIdentifier]];
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
  UITableViewCell *cell;

  if (indexPath.section == 0) {
    cell = [tableView dequeueReusableCellWithIdentifier:[AWFLoginFormViewCell reuseIdentifier]];

    if (indexPath.row == 0) {
      cell.textLabel.text = NSLocalizedString(@"AWF_LOGIN_FORM_EMAIL_TITLE", @"Title of the email form field on the login screen");
    }
    else if (indexPath.row == 1) {
      cell.textLabel.text = NSLocalizedString(@"AWF_LOGIN_FORM_PASSWORD_TITLE", @"Title of the password form field on the login screen");
    }
  }
  else {
    cell = [tableView dequeueReusableCellWithIdentifier:[AWFLoginConnectViewCell reuseIdentifier]];
  }

  return cell;
}

#pragma mark - UITableView delegates

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    return 44.0f;
  }
  else {
    return 60.0f;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 36.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  if (section == 1) {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 17.0f, 0, 0)];
    title.font = [UIFont helveticaNeueCondensedLightFontOfSize:14.0f];
    title.text = NSLocalizedString(@"AWF_LOGIN_FORM_CONNECT_WITH_TITLE", @"Title of connect with login section");
    title.textColor = [UIColor darkGrayTextColor];

    [title sizeToFit];
    [view addSubview:title];
    
    return view;
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
    loginButton.backgroundColor = nil;
    loginButton.frame = CGRectMake(10.0f, 0, 300.0f, 44.0f);
    loginButton.layer.cornerRadius = 2.0f;
    loginButton.titleLabel.font = [UIFont avenirNextCondensedDemiBoldFontOfSize:16.0f];
    loginButton.titleLabel.layer.shadowColor = [UIColor whiteColor].CGColor;
    loginButton.titleLabel.layer.shadowOffset = CGSizeMake(0, 1.0f);
    loginButton.titleLabel.layer.shadowOpacity = 1.0f;
    loginButton.titleLabel.layer.shadowRadius = 0;

    [loginButton setTitle:NSLocalizedString(@"AWF_LOGIN_FORM_LOGIN_BUTTON_TITLE", @"Title of the login button") forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor colorWithDecimalRed:9.0f green:124.0f blue:194.0f alpha:1.0f] forState:UIControlStateNormal];

    NSDictionary *const options = @{UIImageGradientColors: @[[UIColor colorWithDecimalWhite:231.0f alpha:1.0f], [UIColor whiteColor]],
                                    UIImageBottomStrokeColor: [UIColor whiteColor],
                                    UIImageStrokeColor: [UIColor colorWithDecimalWhite:190.0f alpha:1.0f],
                                    UIImageStrokeWidth: @(1.2f)};

    UIImage *normalImage = [UIImage normalPushImageWithSize:CGSizeMake(10.0f, 45.0f) gradient:@[[UIColor whiteColor], [UIColor colorWithWhite:0.95f alpha:1.0f]] backgroundColor:[UIColor defaultBackgroundColor] cornerRadius:3.0f];
    UIImage *highlightedImage = [UIImage buttonImageWithSize:CGSizeMake(10.0f, 45.0f) options:options cornerRadius:3.0f];

    [loginButton setBackgroundImage:normalImage forState:UIControlStateNormal];
    [loginButton setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];

    NSDictionary *const views = NSDictionaryOfVariableBindings(loginButton);

    [view addSubview:loginButton];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[loginButton]-|" options:0 metrics:nil views:views]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20.0-[loginButton]-4.0-|" options:0 metrics:nil views:views]];
  }
  else {
    NSDictionary *const style = @{@"$default": @{
                                      NSFontAttributeName            : [UIFont helveticaNeueCondensedLightFontOfSize:18.0f],
                                      NSForegroundColorAttributeName : [UIColor blackColor]},
                                  @"strong": @{
                                      NSFontAttributeName            : [UIFont helveticaNeueCondensedMediumFontOfSize:18.0f]}
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
