//
//  AWFProfileGenderViewController.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 01/05/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "AWFConfig.h"
#import "AWFProfileGenderViewController.h"

#import <AXKCollectionViewTools/AXKCollectionViewTools.h>

#import "AWFGender.h"
#import "AWFGenderFormatter.h"
#import "AWFPerson.h"
#import "AWFSession.h"

@interface AWFProfileGenderViewController ()

@property (nonatomic, strong) NSArray *genders;
@property (nonatomic, strong) AWFGenderFormatter *formatter;

@end

@implementation AWFProfileGenderViewController

- (instancetype)init {
  return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.title = NSLocalizedString(@"AWF_GENDER", nil);
  self.genders = @[@(AWFGenderFemale), @(AWFGenderMale)];
  self.formatter = [[AWFGenderFormatter alloc] init];
  [self.tableView registerClassForCellReuse:[UITableViewCell class]];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.genders count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell reuseIdentifier]
                                                          forIndexPath:indexPath];
  cell.textLabel.text = [[self.formatter stringForObjectValue:self.genders[indexPath.row]] capitalizedString];

  AWFGender gender = [self.genders[indexPath.row] unsignedIntegerValue];
  if ([[AWFSession sharedSession] currentUser].genderValue == gender) {
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
  }
  else {
    cell.accessoryType = UITableViewCellAccessoryNone;
  }

  return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  AWFPerson *me = [[AWFSession sharedSession] currentUser];
  me.gender = self.genders[indexPath.row];

  NSError *error;
  if (![me.managedObjectContext save:&error]) {
    ErrorLog(error.localizedDescription);
  }

  [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}

@end
