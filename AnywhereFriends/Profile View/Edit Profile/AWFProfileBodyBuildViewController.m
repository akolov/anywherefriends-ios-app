//
//  AWFProfileBodyBuildViewController.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 01/05/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "AWFConfig.h"
#import "AWFProfileBodyBuildViewController.h"

#import <AXKCollectionViewTools/AXKCollectionViewTools.h>

#import "AWFGender.h"
#import "AWFBodyBuildFormatter.h"
#import "AWFPerson.h"
#import "AWFSession.h"

@interface AWFProfileBodyBuildViewController ()

@property (nonatomic, strong) AWFBodyBuildFormatter *formatter;
@property (nonatomic, strong) NSArray *bodyBuilds;

@end

@implementation AWFProfileBodyBuildViewController

- (instancetype)init {
  return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.title = NSLocalizedString(@"AWF_BODY_BUILD", nil);
  self.formatter = [[AWFBodyBuildFormatter alloc] init];
  self.bodyBuilds = @[@(AWFBodyBuildSlim), @(AWFBodyBuildAverage), @(AWFBodyBuildAthletic), @(AWFBodyBuildExtraPounds)];
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
  return [self.bodyBuilds count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell reuseIdentifier]
                                                          forIndexPath:indexPath];
  cell.textLabel.text = [[self.formatter stringForObjectValue:self.bodyBuilds[indexPath.row]] capitalizedString];

  AWFBodyBuild bodyBuild = [self.bodyBuilds[indexPath.row] unsignedIntegerValue];
  if ([[AWFSession sharedSession] currentUser].bodyBuildValue == bodyBuild) {
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
  me.bodyBuild = self.bodyBuilds[indexPath.row];

  NSError *error;
  if (![me.managedObjectContext save:&error]) {
    ErrorLog(error.localizedDescription);
  }

  [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}

@end
