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
#import "AWFProfileBodyBuildViewController.h"
#import "AWFProfileEyeColorViewController.h"
#import "AWFProfileGenderViewController.h"
#import "AWFProfileHairColorViewController.h"
#import "AWFProfileHairLengthViewController.h"
#import "AWFSession.h"

@implementation AWFMyProfileViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.navigationItem.rightBarButtonItem = self.editButtonItem;
  self.tableView.allowsSelectionDuringEditing = YES;

  @weakify(self);
  [[[AWFSession sharedSession] getUserSelf]
   subscribeNext:^(AWFPerson *person) {
     @strongify(self);
     self.personID = person.personID;
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

- (NSString *)title {
  return NSLocalizedString(@"AWF_ME_VIEW_CONTROLLER_TITLE", nil);
}

- (void)setTitle:(NSString *)title {
  self.shownTitle = title;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
  [super setEditing:editing animated:animated];
  [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (!self.isEditing) {
    cell.accessoryType = UITableViewCellAccessoryNone;
  }
  else if (indexPath.section != 0 || indexPath.row != 1) {
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (!self.isEditing) {
    return;
  }

  switch (indexPath.section) {
    case 0: {
      switch (indexPath.row) {
        case 0: {
          AWFProfileGenderViewController *vc = [[AWFProfileGenderViewController alloc] init];
          [self.navigationController pushViewController:vc animated:YES];
        }
          break;

        default:
          break;
      }
    }
      break;
    case 1: {
      switch (indexPath.row) {
        case 2: {
          AWFProfileBodyBuildViewController *vc = [[AWFProfileBodyBuildViewController alloc] init];
          [self.navigationController pushViewController:vc animated:YES];
        }
          break;

        case 3: {
          AWFProfileHairLengthViewController *vc = [[AWFProfileHairLengthViewController alloc] init];
          [self.navigationController pushViewController:vc animated:YES];
        }
          break;

        case 4: {
          AWFProfileHairColorViewController *vc = [[AWFProfileHairColorViewController alloc] init];
          [self.navigationController pushViewController:vc animated:YES];
        }
          break;

        case 5: {
          AWFProfileEyeColorViewController *vc = [[AWFProfileEyeColorViewController alloc] init];
          [self.navigationController pushViewController:vc animated:YES];
        }
          break;
          
        default:
          break;
      }
    }

    default:
      break;
  }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  return NO;
}

@end
