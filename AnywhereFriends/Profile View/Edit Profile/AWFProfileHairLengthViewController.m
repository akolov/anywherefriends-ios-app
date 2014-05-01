//
//  AWFProfileHairLengthViewController.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 01/05/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "AWFConfig.h"
#import "AWFProfileHairLengthViewController.h"

#import <AXKCollectionViewTools/AXKCollectionViewTools.h>

#import "AWFGender.h"
#import "AWFHairLengthFormatter.h"
#import "AWFPerson.h"
#import "AWFSession.h"

@interface AWFProfileHairLengthViewController ()

@property (nonatomic, strong) AWFHairLengthFormatter *formatter;
@property (nonatomic, strong) NSArray *hairLengths;

@end

@implementation AWFProfileHairLengthViewController

- (instancetype)init {
  return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.title = NSLocalizedString(@"AWF_HAIR_LENGTH", nil);
  self.formatter = [[AWFHairLengthFormatter alloc] init];
  self.hairLengths = @[@(AWFHairLengthShort), @(AWFHairLengthMedium), @(AWFHairLengthLong)];
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
  return [self.hairLengths count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell reuseIdentifier]
                                                          forIndexPath:indexPath];
  cell.textLabel.text = [[self.formatter stringForObjectValue:self.hairLengths[indexPath.row]] capitalizedString];

  AWFHairLength hairLength = [self.hairLengths[indexPath.row] unsignedIntegerValue];
  if ([[AWFSession sharedSession] currentUser].hairLengthValue == hairLength) {
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
  me.hairLength = self.hairLengths[indexPath.row];

  NSError *error;
  if (![me.managedObjectContext save:&error]) {
    ErrorLog(error.localizedDescription);
  }

  [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}

@end
