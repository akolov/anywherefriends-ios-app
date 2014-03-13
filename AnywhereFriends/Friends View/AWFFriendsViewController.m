//
//  AWFFriendsViewController.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 13/03/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "AWFFriendsViewController.h"

#import <AXKCollectionViewTools/AXKCollectionViewTools.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "AWFLocationManager.h"
#import "AWFNearbyViewCell.h"
#import "AWFPerson.h"
#import "AWFProfileViewController.h"
#import "AWFSession.h"

@interface AWFFriendsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) id locationObserver;
@property (nonatomic, strong) NSArray *people;

- (void)getFriends;

@end

@implementation AWFFriendsViewController

- (void)dealloc {
  if (self.locationObserver) {
    [[NSNotificationCenter defaultCenter] removeObserver:self.locationObserver];
  }
}

#pragma mark - View Life Cycle

- (void)viewDidLoad {
  [super viewDidLoad];

  self.automaticallyAdjustsScrollViewInsets = NO;

  self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
  self.tableView.backgroundColor = [UIColor whiteColor];
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  self.tableView.opaque = NO;
  self.tableView.rowHeight = 60.0f;
  [self.tableView registerClassForCellReuse:[AWFNearbyViewCell class]];
  [self.view addSubview:self.tableView];

  @weakify(self);
  self.locationObserver =
  [[NSNotificationCenter defaultCenter]
   addObserverForName:AWFLocationManagerDidUpdateLocationsNotification object:nil queue:[NSOperationQueue mainQueue]
   usingBlock:^(NSNotification *note) {
     @strongify(self);
     [self.tableView reloadData];
   }];

  [self getFriends];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

#pragma mark - Accessors

- (void)setPeople:(NSArray *)people {
  _people = people;
  [self.tableView reloadData];
}

#pragma mark - Private Methods

- (void)getFriends {
  [[[AWFSession sharedSession] getUserFriends]
   subscribeNext:^(NSArray *people) {
     self.people = people;
   }
   error:^(NSError *error) {
     ErrorLog(error.localizedDescription);
   }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.people.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  AWFNearbyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[AWFNearbyViewCell reuseIdentifier]
                                                            forIndexPath:indexPath];
  AWFPerson *person = self.people[indexPath.row];
  cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
  cell.placeholderView.text = person.abbreviatedName;
  cell.imageView.image = nil;
  cell.nameLabel.text = person.fullName;
  cell.locationLabel.text = [NSString stringWithFormat:@"%.2f m — %@", person.distance, person.locationName];
  return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  AWFProfileViewController *vc = [[AWFProfileViewController alloc] initWithPerson:self.people[indexPath.row]];
  [self.navigationController pushViewController:vc animated:YES];
}

@end
