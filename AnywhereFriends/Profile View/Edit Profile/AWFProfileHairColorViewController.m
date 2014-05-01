//
//  AWFProfileHairColorViewController.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 01/05/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "AWFConfig.h"
#import "AWFProfileHairColorViewController.h"

#import <AXKCollectionViewTools/AXKCollectionViewTools.h>

#import "AWFGender.h"
#import "AWFHairColorFormatter.h"
#import "AWFPerson.h"
#import "AWFSession.h"

@interface AWFProfileHairColorViewController ()

@property (nonatomic, strong) AWFHairColorFormatter *formatter;
@property (nonatomic, strong) NSArray *hairColors;

@end

@implementation AWFProfileHairColorViewController

- (instancetype)init {
  return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.title = NSLocalizedString(@"AWF_HAIR_COLOR", nil);
  self.formatter = [[AWFHairColorFormatter alloc] init];
  self.hairColors = @[@(AWFHairColorAuburn),
                      @(AWFHairColorBlack),
                      @(AWFHairColorBlond),
                      @(AWFHairColorBrown),
                      @(AWFHairColorChestnut),
                      @(AWFHairColorGray),
                      @(AWFHairColorRed),
                      @(AWFHairColorWhite)];
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
  return [self.hairColors count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell reuseIdentifier]
                                                          forIndexPath:indexPath];
  cell.textLabel.text = [[self.formatter stringForObjectValue:self.hairColors[indexPath.row]] capitalizedString];

  AWFHairColor hairColor = [self.hairColors[indexPath.row] unsignedIntegerValue];
  if ([[AWFSession sharedSession] currentUser].hairColorValue == hairColor) {
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
  me.hairColor = self.hairColors[indexPath.row];

  NSError *error;
  if (![me.managedObjectContext save:&error]) {
    ErrorLog(error.localizedDescription);
  }

  [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}

@end
