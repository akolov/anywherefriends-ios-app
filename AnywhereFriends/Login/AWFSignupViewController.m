//
//  AWFSignupViewController.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/7/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

#import "AWFConfig.h"
#import "AWFSignupViewController.h"

#import "AZNotification.h"
#import <AXKCollectionViewTools/AXKCollectionViewTools.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "AWFGenderPicker.h"
#import "AWFLoginFormViewCell.h"
#import "AWFNavigationTitleView.h"
#import "AWFSession.h"
#import "AWFValueTransformers.h"
#import "UIImage+CustomBackgrounds.h"

@interface AWFSignupViewController ()

@property (nonatomic, strong) NSArray *fields;

- (UIView *)tableFooterView;

- (UITextField *)newFormTextField;
- (AWFGenderPicker *)newGenderPicker;

- (NSString *)emailFieldValue;
- (NSString *)passwordFieldValue;
- (NSString *)firstNameFieldValue;
- (NSString *)lastNameFieldValue;
- (NSString *)genderFieldValue;

- (void)onSignupButtonTouchUpInside:(id)sender;

@end

@implementation AWFSignupViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.navigationController.navigationBarHidden = NO;
  self.title = NSLocalizedString(@"AWF_LOGIN_FORM_SIGN_UP_TITLE", nil);

  self.tableView.showsHorizontalScrollIndicator = NO;
  self.tableView.showsVerticalScrollIndicator = NO;
  self.tableView.tableFooterView = [self tableFooterView];
  self.view.backgroundColor = [UIColor awfDefaultBackgroundColor];

  [self.tableView registerClass:[AWFLoginFormViewCell class]
         forCellReuseIdentifier:[AWFLoginFormViewCell reuseIdentifier]];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
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

  UIView *view = self.fields[indexPath.row];
  cell.field = view;

  switch (indexPath.row) {
    case 0:
      cell.textLabel.text = NSLocalizedString(@"AWF_LOGIN_FORM_EMAIL_TITLE", nil);
      [(UITextField *)view setPlaceholder:NSLocalizedString(@"AWF_LOGIN_FORM_EMAIL_PLACEHOLDER", nil)];
      break;
    case 1:
      cell.textLabel.text = NSLocalizedString(@"AWF_LOGIN_FORM_PASSWORD_TITLE", nil);
      [(UITextField *)view setPlaceholder:NSLocalizedString(@"AWF_LOGIN_FORM_PASSWORD_PLACEHOLDER", nil)];
      break;
    case 2:
      cell.textLabel.text = NSLocalizedString(@"AWF_LOGIN_FORM_FIRST_NAME_TITLE", nil);
      [(UITextField *)view setPlaceholder:NSLocalizedString(@"AWF_LOGIN_FORM_FIRST_NAME_PLACEHOLDER", nil)];
      break;
    case 3:
      cell.textLabel.text = NSLocalizedString(@"AWF_LOGIN_FORM_LAST_NAME_TITLE", nil);
      [(UITextField *)view setPlaceholder:NSLocalizedString(@"AWF_LOGIN_FORM_LAST_NAME_PLACEHOLDER", nil)];
      break;
    case 4:
      cell.textLabel.text = NSLocalizedString(@"AWF_LOGIN_FORM_GENDER_TITLE", nil);
      break;
  }

  return cell;
}

#pragma mark - Table Footer

- (UIView *)tableFooterView {
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 50.0f)];

  UIButton *signupButton = [UIButton autolayoutView];
  signupButton.backgroundColor = nil;
  signupButton.frame = CGRectMake(10.0f, 0, 300.0f, 44.0f);
  signupButton.layer.cornerRadius = 2.0f;
  signupButton.titleLabel.font = [UIFont helveticaNeueCondensedMediumFontOfSize:16.0f];
  signupButton.titleLabel.layer.shadowColor = [UIColor whiteColor].CGColor;
  signupButton.titleLabel.layer.shadowOffset = CGSizeMake(0, 1.0f);
  signupButton.titleLabel.layer.shadowOpacity = 1.0f;
  signupButton.titleLabel.layer.shadowRadius = 0;

  [signupButton setTitle:NSLocalizedString(@"AWF_LOGIN_FORM_SIGNUP_BUTTON_TITLE", @"Title of the signup button") forState:UIControlStateNormal];
  [signupButton setTitleColor:[UIColor awfBlueTextColor] forState:UIControlStateNormal];
  [signupButton addTarget:self action:@selector(onSignupButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];

  NSDictionary *const options = @{UIImageGradientColors: @[[UIColor colorWithDecimalWhite:231.0f alpha:1.0f], [UIColor whiteColor]],
                                  UIImageBottomStrokeColor: [UIColor whiteColor],
                                  UIImageStrokeColor: [UIColor colorWithDecimalWhite:190.0f alpha:1.0f],
                                  UIImageStrokeWidth: @(1.2f)};

  UIImage *normalImage = [UIImage normalPushImageWithSize:CGSizeMake(10.0f, 45.0f) gradient:@[[UIColor whiteColor], [UIColor colorWithWhite:0.95f alpha:1.0f]] backgroundColor:[UIColor awfDefaultBackgroundColor] cornerRadius:3.0f];
  UIImage *highlightedImage = [UIImage buttonImageWithSize:CGSizeMake(10.0f, 45.0f) options:options cornerRadius:3.0f];

  [signupButton setBackgroundImage:normalImage forState:UIControlStateNormal];
  [signupButton setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];

  NSDictionary *const views = NSDictionaryOfVariableBindings(signupButton);

  [view addSubview:signupButton];
  [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[signupButton]-|" options:0 metrics:nil views:views]];
  [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[signupButton(40.0)]" options:0 metrics:nil views:views]];

  return view;
}

#pragma mark - Form Fields

- (UITextField *)newFormTextField {
  CGRect frame = CGRectMake(100.0f, 12.0f, CGRectGetWidth(self.tableView.bounds) - 100.0f - 20.0f, 22.0f);
  UITextField *textField = [[UITextField alloc] initWithFrame:frame];
  textField.font = [UIFont helveticaNeueCondensedLightFontOfSize:16.0f];
  return textField;
}

- (AWFGenderPicker *)newGenderPicker {
  CGRect frame = CGRectMake(100.0f, 12.0f, CGRectGetWidth(self.tableView.bounds) - 100.0f - 20.0f, 22.0f);
  AWFGenderPicker *picker = [[AWFGenderPicker alloc] initWithFrame:frame];
  return picker;
}

- (NSArray *)fields {
  if (!_fields) {
    NSMutableArray *fields = [NSMutableArray array];

    UITextField *email = [self newFormTextField];
    email.text = self.email;
    email.autocapitalizationType = UITextAutocapitalizationTypeNone;
    email.keyboardType = UIKeyboardTypeEmailAddress;
    [fields addObject:email];

    UITextField *password = [self newFormTextField];
    password.secureTextEntry = YES;
    [fields addObject:password];

    UITextField *firstName = [self newFormTextField];
    firstName.text = self.firstName;
    firstName.autocapitalizationType = UITextAutocapitalizationTypeWords;
    [fields addObject:firstName];

    UITextField *lastName = [self newFormTextField];
    lastName.text = self.lastName;
    lastName.autocapitalizationType = UITextAutocapitalizationTypeWords;
    [fields addObject:lastName];

    AWFGenderPicker *genderPicker = [self newGenderPicker];
    genderPicker.gender = self.gender;
    [fields addObject:genderPicker];

    _fields = fields;
  }

  return _fields;
}

- (NSString *)emailFieldValue {
  return [self.fields[0] text];
}

- (NSString *)passwordFieldValue {
  return [self.fields[1] text];
}

- (NSString *)firstNameFieldValue {
  return [self.fields[2] text];
}

- (NSString *)lastNameFieldValue {
  return [self.fields[3] text];
}

- (NSString *)genderFieldValue {
  return [[NSValueTransformer valueTransformerForName:AWFGenderValueTransformerName]
          reverseTransformedValue:@([(AWFGenderPicker *)self.fields[4] gender])];
}

#pragma mark - Actions

- (void)onSignupButtonTouchUpInside:(id)sender {
  @weakify(self);
  [[[AWFSession sharedSession] createUserWithEmail:self.emailFieldValue
                                          password:self.passwordFieldValue
                                         firstName:self.firstNameFieldValue
                                          lastName:self.lastNameFieldValue
                                            gender:self.genderFieldValue]
   subscribeError:^(NSError *error) {
     @strongify(self);
     [self showNotificationWithTitle:error.localizedDescription notificationType:AZNotificationTypeError];
     ErrorLog(error.localizedDescription);
   }
   completed:^{
     @strongify(self);
     [self dismissViewControllerAnimated:YES completion:NULL];
   }];
}

@end
