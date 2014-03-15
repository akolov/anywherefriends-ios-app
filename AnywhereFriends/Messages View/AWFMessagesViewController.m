//
//  AWFMessagesViewController.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 15/03/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "AWFConfig.h"
#import "AWFMessagesViewController.h"

#import <AXKCollectionViewTools/AXKCollectionViewTools.h>
#import <FormatterKit/TTTTimeIntervalFormatter.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "AWFMessagesViewCell.h"
#import "AWFNavigationTitleView.h"
#import "AWFPerson.h"
#import "AWFSession.h"

@interface AWFMessagesViewController ()

@property (nonatomic, strong) NSArray *people;
@property (nonatomic, strong) TTTTimeIntervalFormatter *formatter;

- (void)getConversations;

@end

@implementation AWFMessagesViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.navigationItem.titleView = [AWFNavigationTitleView navigationTitleView];
  self.navigationItem.rightBarButtonItem = self.editButtonItem;

  self.formatter = [[TTTTimeIntervalFormatter alloc] init];

  [self.tableView registerClassForCellReuse:[AWFMessagesViewCell class]];

  [self getConversations];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
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

- (void)getConversations {
  @weakify(self);
  //  [[[AWFSession sharedSession] getActivity]
  //   subscribeNext:^(NSArray *people) {
  //     @strongify(self);
  //     self.people = people;
  //   }
  //   error:^(NSError *error) {
  //     ErrorLog(error.localizedDescription);
  //   }];

  [[[AWFSession sharedSession] getUsersAtCoordinate:CLLocationCoordinate2DMake(48.136767, 11.576843)
                                         withRadius:20000.0
                                         pageNumber:0
                                           pageSize:20]
   subscribeNext:^(NSArray *people) {
     @strongify(self);
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
  AWFMessagesViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[AWFMessagesViewCell reuseIdentifier]
                                                              forIndexPath:indexPath];
  AWFPerson *person = self.people[indexPath.row];
  cell.imageView.image = nil;
  cell.nameLabel.text = person.fullName;
  cell.lastMessageLabel.text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut convallis porta erat, quis tincidunt magna consectetur sed. Proin fermentum tristique nibh, in lobortis purus luctus sed. Vestibulum quis quam eu nunc volutpat vehicula sed ut velit. Nullam sed lorem vitae est dignissim fermentum.";
  cell.timeLabel.text = [self.formatter stringForTimeIntervalFromDate:[NSDate date] toDate:person.location.timestamp];
  cell.placeholderView.text = person.abbreviatedName;

  return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
  }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 70.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//  AWFProfileViewController *vc = [[AWFProfileViewController alloc] initWithPerson:self.people[indexPath.row]];
//  [self.navigationController pushViewController:vc animated:YES];
}

@end
