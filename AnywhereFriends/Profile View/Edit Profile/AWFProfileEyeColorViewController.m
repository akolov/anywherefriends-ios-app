//
//  AWFProfileEyeColorViewController.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 01/05/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "AWFConfig.h"
#import "AWFProfileEyeColorViewController.h"

#import <AXKCollectionViewTools/AXKCollectionViewTools.h>

#import "AWFGender.h"
#import "AWFEyeColorFormatter.h"
#import "AWFPerson.h"
#import "AWFSession.h"

@interface AWFProfileEyeColorViewController ()

@property (nonatomic, strong) AWFEyeColorFormatter *formatter;
@property (nonatomic, strong) NSArray *eyeColors;

@end

@implementation AWFProfileEyeColorViewController

- (instancetype)init {
  return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.title = NSLocalizedString(@"AWF_EYE_COLOR", nil);
  self.formatter = [[AWFEyeColorFormatter alloc] init];
  self.eyeColors = @[@(AWFEyeColorAmber),
                     @(AWFEyeColorBlue),
                     @(AWFEyeColorBrown),
                     @(AWFEyeColorGray),
                     @(AWFEyeColorGreen),
                     @(AWFEyeColorHazel),
                     @(AWFEyeColorRed),
                     @(AWFEyeColorViolet)];
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
  return [self.eyeColors count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell reuseIdentifier]
                                                          forIndexPath:indexPath];
  cell.textLabel.text = [[self.formatter stringForObjectValue:self.eyeColors[indexPath.row]] capitalizedString];

  AWFEyeColor eyeColor = [self.eyeColors[indexPath.row] unsignedIntegerValue];
  if ([[AWFSession sharedSession] currentUser].eyeColorValue == eyeColor) {
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
  me.eyeColor = self.eyeColors[indexPath.row];

  NSError *error;
  if (![me.managedObjectContext save:&error]) {
    ErrorLog(error.localizedDescription);
  }

  [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}

@end
