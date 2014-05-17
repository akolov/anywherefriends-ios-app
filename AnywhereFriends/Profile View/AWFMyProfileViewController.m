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
#import <Slash/Slash.h>

#import "AWFLabelButton.h"
#import "AWFMyProfileHeaderView.h"
#import "AWFPerson.h"
#import "AWFProfileBodyBuildViewController.h"
#import "AWFProfileEyeColorViewController.h"
#import "AWFProfileGenderViewController.h"
#import "AWFProfileHairColorViewController.h"
#import "AWFProfileHairLengthViewController.h"
#import "AWFProfileHeaderView.h"
#import "AWFSession.h"

@interface AWFMyProfileViewController ()

@property (nonatomic, strong) AWFMyProfileHeaderView *customProfileHeaderView;

- (void)didTapLogoutButton:(id)sender;

@end

@implementation AWFMyProfileViewController

- (void)viewDidLoad {
  [super viewDidLoad];

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
     ErrorLog(error.localizedDescription);
   }];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Accessors 

- (UIView *)profileHeaderView {
  return self.customProfileHeaderView;
}

- (AWFMyProfileHeaderView *)customProfileHeaderView {
  if (!_customProfileHeaderView) {
    _customProfileHeaderView = [[AWFMyProfileHeaderView alloc] init];
    _customProfileHeaderView.descriptionLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.tableView.bounds);
    _customProfileHeaderView.photoCollectionView.dataSource = self;
    _customProfileHeaderView.photoCollectionView.delegate = self;

    [self reloadHeaderView];
  }

  return _customProfileHeaderView;
}

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

  if (!editing) {
    [[[AWFSession sharedSession] updateUserSelf] subscribeError:^(NSError *error) {
      ErrorLog(error.localizedDescription);
    }];
  }
}

#pragma mark - Actions

- (void)didTapLogoutButton:(id)sender {
  [[[AWFSession sharedSession] closeSession] subscribeError:^(NSError *error) {
    ErrorLog(error.localizedDescription);
  } completed:^{

  }];
}

#pragma mark - Public Methods

- (void)reloadHeaderView {
  NSDictionary *style = @{@"$default": @{
                              NSParagraphStyleAttributeName: ({
                                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                                paragraphStyle.alignment = NSTextAlignmentLeft;
                                paragraphStyle;
                              }),
                              NSFontAttributeName: [UIFont helveticaNeueFontOfSize:14.0f],
                              NSForegroundColorAttributeName: [UIColor whiteColor]
                              },
                          @"em": @{
                              NSFontAttributeName: [UIFont helveticaNeueFontOfSize:10.0f],
                              NSForegroundColorAttributeName: [UIColor grayColor]}
                          };

  NSString *lastUpdated, *markup;
  if (self.person.locationUpdated) {
    markup = [NSString stringWithFormat:@"%@\n<em>%@</em>", self.person.locationName, lastUpdated];
  }
  else {
    markup = self.person.locationName;
  }

  NSError *error;
  NSAttributedString *string = [SLSMarkupParser attributedStringWithMarkup:markup style:style error:NULL];
  if (!string) {
    ErrorLog(error.localizedDescription);
  }

  self.customProfileHeaderView.locationLabel.attributedText = string;
  self.customProfileHeaderView.descriptionLabel.text = self.person.bio;

  CGRect bounds;
  bounds.size.width = CGRectGetWidth(self.tableView.bounds);
  bounds.size.height = [self.customProfileHeaderView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;

  self.customProfileHeaderView.bounds = bounds;

  [self.customProfileHeaderView setNeedsLayout];
  [self.customProfileHeaderView layoutIfNeeded];
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
