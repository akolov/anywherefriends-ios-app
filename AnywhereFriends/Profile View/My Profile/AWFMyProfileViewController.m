//
//  AWFMyProfileViewController.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 15/03/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "AWFConfig.h"
#import "AWFMyProfileViewController.h"

#import "AZNotification.h"
#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Slash/Slash.h>

#import "AWFDatePickerViewCell.h"
#import "AWFLabelButton.h"
#import "AWFMapViewController.h"
#import "AWFPerson.h"
#import "AWFProfileDataSource.h"
#import "AWFProfileHeaderView.h"
#import "AWFSession.h"

@interface AWFMyProfileViewController ()

- (void)didTapLogoutButton:(id)sender;

@end

@implementation AWFMyProfileViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.dataSource.ownProfile = YES;

  self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Log out" style:UIBarButtonItemStylePlain
                                    target:self action:@selector(didTapLogoutButton:)];
  self.navigationItem.rightBarButtonItem = self.editButtonItem;
  self.tableView.allowsSelectionDuringEditing = YES;

  @weakify(self);
  [[[AWFSession sharedSession] getUserSelf]
   subscribeNext:^(AWFPerson *person) {
     @strongify(self);
     self.personID = person.personID;
   }
   error:^(NSError *error) {
     @strongify(self);
     [self showNotificationWithTitle:error.localizedDescription notificationType:AZNotificationTypeError];
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

- (NSString *)title {
  return NSLocalizedString(@"AWF_ME_VIEW_CONTROLLER_TITLE", nil);
}

- (void)setTitle:(NSString *)title {
  self.shownTitle = title;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
  self.dataSource.editing = editing;

  if (!editing) {
    @weakify(self);
    [[[AWFSession sharedSession] updateUserSelf] subscribeError:^(NSError *error) {
      @strongify(self);
      [self showNotificationWithTitle:error.localizedDescription notificationType:AZNotificationTypeError];
      ErrorLog(error.localizedDescription);
    }];
  }

  [super setEditing:editing animated:animated];

  if (animated) {
    [UIView animateWithDuration:0.25f animations:^{
      self.tableView.backgroundColor = editing ? [UIColor whiteColor] : [UIColor blackColor];
      [self.tableView reloadData];
    }];
  }
  else {
    self.tableView.backgroundColor = editing ? [UIColor whiteColor] : [UIColor blackColor];
    [self.tableView reloadData];
  }
}

#pragma mark - Actions

- (void)didTapLogoutButton:(id)sender {
  @weakify(self);
  [[[AWFSession sharedSession] closeSession] subscribeError:^(NSError *error) {
    @strongify(self);
    [self showNotificationWithTitle:error.localizedDescription notificationType:AZNotificationTypeError];
    ErrorLog(error.localizedDescription);
  } completed:^{
    [[NSNotificationCenter defaultCenter] postNotificationName:AWFLoginRequiredNotification object:nil];
  }];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (!self.isEditing && indexPath.section == 0 && indexPath.row == 0) {
    AWFMapViewController *vc = [[AWFMapViewController alloc] initWithPerson:self.person];
    [self.navigationController pushViewController:vc animated:YES];
  }
}

@end
