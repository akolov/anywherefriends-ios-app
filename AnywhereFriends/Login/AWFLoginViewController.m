//
//  AWFLoginViewController.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/4/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

#import "AWFConfig.h"
#import "AWFLoginViewController.h"

#import "AZNotification.h"
#import <AXKCollectionViewTools/AXKCollectionViewTools.h>

#import <FacebookSDK/FacebookSDK.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Slash/Slash.h>
#import <VK-ios-sdk/VKSdk.h>

#import "AWFAppDelegate+AWFFacebookSDK.h"
#import "AWFLoginConnectViewCell.h"
#import "AWFLoginFormViewCell.h"
#import "AWFNavigationController.h"
#import "AWFNavigationTitleView.h"
#import "AWFNearbyViewController.h"
#import "AWFSession.h"
#import "AWFTwitterClient.h"
#import "AWFSignupViewController.h"
#import "UIImage+CustomBackgrounds.h"

@interface AWFLoginViewController ()

@property (nonatomic, strong) ACAccountStore *accountStore;
@property (nonatomic, strong) NSArray *fields;

- (void)onForgotPasswordButtonTouchUpInside:(id)sender;
- (void)onLoginButtonTouchUpInside:(id)sender;
- (void)onSignupButtonTouchUpInside:(id)sender;

- (UITextField *)newFormTextField;
- (NSString *)email;
- (NSString *)password;

@end

@implementation AWFLoginViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.navigationItem.titleView = [AWFNavigationTitleView navigationTitleView];

  self.tableView.showsHorizontalScrollIndicator = NO;
  self.tableView.showsVerticalScrollIndicator = NO;
  self.view.backgroundColor = [UIColor awfDefaultBackgroundColor];

  [self.tableView registerClassForCellReuse:[AWFLoginConnectViewCell class]];
  [self.tableView registerClassForCellReuse:[AWFLoginFormViewCell class]];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
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
  if (indexPath.section == 0) {
    AWFLoginFormViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:[AWFLoginFormViewCell reuseIdentifier] forIndexPath:indexPath];

    UIView *view = self.fields[indexPath.row];
    cell.field = view;

    if (indexPath.row == 0) {
      cell.textLabel.text = NSLocalizedString(@"AWF_LOGIN_FORM_EMAIL_TITLE", nil);
      [(UITextField *)view setPlaceholder:NSLocalizedString(@"AWF_LOGIN_FORM_EMAIL_PLACEHOLDER", nil)];
    }
    else if (indexPath.row == 1) {
      cell.textLabel.text = NSLocalizedString(@"AWF_LOGIN_FORM_PASSWORD_TITLE", nil);
      [(UITextField *)view setPlaceholder:NSLocalizedString(@"AWF_LOGIN_FORM_PASSWORD_PLACEHOLDER", nil)];
    }

    return cell;
  }
  else {

    @weakify(self);

    AWFLoginConnectViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:[AWFLoginConnectViewCell reuseIdentifier]];
    cell.onFacebookButtonAction = ^{
      [FBSession
       openActiveSessionWithReadPermissions:AWF_FACEBOOK_PERMISSIONS
       allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
         AWFAppDelegate *appDelegate = [AWFAppDelegate sharedInstance];
         [appDelegate sessionStateChanged:session state:state error:error];
       }];
    };

    cell.onTwitterButtonAction = ^{
      [[[[AWFTwitterClient sharedClient] performReverseAuthorization]
        flattenMap:^RACStream *(RACTuple *tuple) {
          RACTupleUnpack(NSString *token, NSString *secret) = tuple;
          return [[AWFSession sharedSession] openSessionWithTwitterToken:token secret:secret];
        }]
       subscribeError:^(NSError *error) {
         [self showNotificationWithTitle:error.localizedDescription notificationType:AZNotificationTypeError];
       }
       completed:^{
         @strongify(self);
         [self dismissViewControllerAnimated:YES completion:NULL];
       }];
    };

    cell.onVkontakteButtonAction = ^{
      [VKSdk authorize:AWF_VK_PERMISSIONS];
    };

    return cell;
  }

  return nil;
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
  UIView *view = [[UIView alloc] initWithFrame:CGRectZero];

  UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 17.0f, 0, 0)];
  title.font = [UIFont helveticaNeueCondensedLightFontOfSize:14.0f];

  if (section == 0) {
    title.text = NSLocalizedString(@"AWF_LOGIN_FORM_LOGIN_SECTION_TITLE", nil);
  }
  else {
    title.text = NSLocalizedString(@"AWF_LOGIN_FORM_CONNECT_WITH_SECTION_TITLE", nil);
  }

  title.textColor = [UIColor awfDarkGrayTextColor];

  [title sizeToFit];
  [view addSubview:title];

  return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  if (section == 0) {
    return 90.0f;
  }
  else {
    return 64.0f;
  }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

  UIView *view = [[UIView alloc] initWithFrame:CGRectZero];

  if (section == 0) {

    // Login button

    UIButton *loginButton = [UIButton autolayoutView];
    loginButton.backgroundColor = nil;
    loginButton.frame = CGRectMake(10.0f, 0, 300.0f, 44.0f);
    loginButton.layer.cornerRadius = 2.0f;
    loginButton.titleLabel.font = [UIFont helveticaNeueCondensedMediumFontOfSize:16.0f];
    loginButton.titleLabel.layer.shadowColor = [UIColor whiteColor].CGColor;
    loginButton.titleLabel.layer.shadowOffset = CGSizeMake(0, 1.0f);
    loginButton.titleLabel.layer.shadowOpacity = 1.0f;
    loginButton.titleLabel.layer.shadowRadius = 0;

    [loginButton addTarget:self action:@selector(onLoginButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setTitle:NSLocalizedString(@"AWF_LOGIN_FORM_LOGIN_BUTTON_TITLE", @"Title of the login button") forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor awfBlueTextColor] forState:UIControlStateNormal];

    NSDictionary *const options = @{UIImageGradientColors: @[[UIColor colorWithDecimalWhite:231.0f alpha:1.0f], [UIColor whiteColor]],
                                    UIImageBottomStrokeColor: [UIColor whiteColor],
                                    UIImageStrokeColor: [UIColor colorWithDecimalWhite:190.0f alpha:1.0f],
                                    UIImageStrokeWidth: @(1.2f)};

    UIImage *normalImage = [UIImage normalPushImageWithSize:CGSizeMake(10.0f, 45.0f) gradient:@[[UIColor whiteColor], [UIColor colorWithWhite:0.95f alpha:1.0f]] backgroundColor:[UIColor awfDefaultBackgroundColor] cornerRadius:3.0f];
    UIImage *highlightedImage = [UIImage buttonImageWithSize:CGSizeMake(10.0f, 45.0f) options:options cornerRadius:3.0f];

    [loginButton setBackgroundImage:normalImage forState:UIControlStateNormal];
    [loginButton setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];

    // Forgot password button

    UIButton *forgotButton = [UIButton autolayoutView];
    forgotButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    forgotButton.titleLabel.font = [UIFont helveticaNeueCondensedLightFontOfSize:14.0f];
    forgotButton.titleLabel.minimumScaleFactor = 0.5f;
    forgotButton.titleLabel.numberOfLines = 1;

    [forgotButton addTarget:self action:@selector(onForgotPasswordButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [forgotButton setTitle:NSLocalizedString(@"AWF_LOGIN_FORM_FORGOT_PASSWORD_TITLE", @"Title of the forgot password button on the login form") forState:UIControlStateNormal];
    [forgotButton setTitleColor:[UIColor awfDarkGrayTextColor] forState:UIControlStateNormal];

    [view addSubview:forgotButton];

    // Layout

    NSDictionary *const views = NSDictionaryOfVariableBindings(loginButton, forgotButton);

    [view addSubview:loginButton];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[loginButton]-|" options:0 metrics:nil views:views]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[forgotButton]-|" options:0 metrics:nil views:views]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-17.0-[loginButton(40.0)]-[forgotButton]" options:0 metrics:nil views:views]];
  }
  else {
    NSDictionary *const style = @{@"$default": @{
                                      NSFontAttributeName            : [UIFont helveticaNeueCondensedLightFontOfSize:18.0f],
                                      NSForegroundColorAttributeName : [UIColor blackColor]},
                                  @"strong": @{
                                      NSFontAttributeName            : [UIFont helveticaNeueCondensedMediumFontOfSize:18.0f]}
                                  };

    NSString *markup = NSLocalizedString(@"AWF_LOGIN_FORM_SIGN_UP_BUTTON_TITLE", @"Title of the sign up button on the login form");
    NSAttributedString *attributedText = [SLSMarkupParser attributedStringWithMarkup:markup style:style error:NULL];

    UIButton *signupButton = [UIButton autolayoutView];
    signupButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    signupButton.titleLabel.minimumScaleFactor = 0.5f;
    signupButton.titleLabel.numberOfLines = 1;

    [signupButton addTarget:self action:@selector(onSignupButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [signupButton setAttributedTitle:attributedText forState:UIControlStateNormal];
    [signupButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    NSDictionary *const views = NSDictionaryOfVariableBindings(signupButton);

    [view addSubview:signupButton];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[signupButton]-|" options:0 metrics:nil views:views]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20.0-[signupButton]" options:0 metrics:nil views:views]];
  }

  return view;
}

#pragma mark - Form Fields

- (UITextField *)newFormTextField {
  CGRect frame = CGRectMake(100.0f, 12.0f, CGRectGetWidth(self.tableView.bounds) - 100.0f - 20.0f, 22.0f);
  UITextField *textField = [[UITextField alloc] initWithFrame:frame];
  textField.font = [UIFont helveticaNeueCondensedLightFontOfSize:16.0f];
  return textField;
}

- (NSArray *)fields {
  if (!_fields) {
    NSMutableArray *fields = [NSMutableArray array];

    UITextField *email = [self newFormTextField];
    email.autocapitalizationType = UITextAutocapitalizationTypeNone;
    email.keyboardType = UIKeyboardTypeEmailAddress;
    email.rightViewMode = UITextFieldViewModeWhileEditing;
    [fields addObject:email];

    UITextField *password = [self newFormTextField];
    password.secureTextEntry = YES;
    password.rightViewMode = UITextFieldViewModeWhileEditing;
    [fields addObject:password];

    _fields = fields;
  }

  return _fields;
}

- (NSString *)email {
  return [self.fields[0] text];
}

- (NSString *)password {
  return [self.fields[1] text];
}

#pragma mark - Actions

- (void)onForgotPasswordButtonTouchUpInside:(id)sender {

}

- (void)onLoginButtonTouchUpInside:(id)sender {
  [[[AWFSession sharedSession] openSessionWithEmail:self.email password:self.password]
   subscribeError:^(NSError *error) {
     [self showNotificationWithTitle:error.localizedDescription notificationType:AZNotificationTypeError];
     ErrorLog(error.localizedDescription);
   }
   completed:^{
     [self dismissViewControllerAnimated:YES completion:NULL];
   }];
}

- (void)onSignupButtonTouchUpInside:(id)sender {
  AWFSignupViewController *vc = [[AWFSignupViewController alloc] initWithStyle:UITableViewStyleGrouped];
  [self.navigationController pushViewController:vc animated:YES];
}

@end
