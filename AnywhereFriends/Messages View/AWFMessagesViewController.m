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
#import "AWFActivity.h"
#import "AWFPerson.h"
#import "AWFSession.h"

static NSUInteger AWFPageSize = 20;

@interface AWFMessagesViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) TTTTimeIntervalFormatter *formatter;

- (void)getActivity;

@end

@implementation AWFMessagesViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.navigationItem.titleView = [AWFNavigationTitleView navigationTitleView];
  self.navigationItem.rightBarButtonItem = self.editButtonItem;

  self.formatter = [[TTTTimeIntervalFormatter alloc] init];

  [self.tableView registerClassForCellReuse:[AWFMessagesViewCell class]];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self getActivity];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  _fetchedResultsController = nil;
}

#pragma mark - Accessors

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

- (NSFetchedResultsController *)fetchedResultsController {
  if (!_fetchedResultsController) {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[AWFPerson entityName]];
    request.predicate = [NSPredicate predicateWithFormat:@"activitiesCreated.@count != 0"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES],
                                [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES]];
    request.includesPropertyValues = YES;
    request.includesSubentities = YES;
    request.fetchBatchSize = AWFPageSize;

    _fetchedResultsController =
      [[NSFetchedResultsController alloc]
       initWithFetchRequest:request managedObjectContext:[AWFSession managedObjectContext]
       sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate = self;

    NSError *error;
    if (![_fetchedResultsController performFetch:&error]) {
      ErrorLog(error.localizedDescription);
    }
  }

  return _fetchedResultsController;
}

#pragma mark - Private Methods

- (void)getActivity {
  [[[AWFSession sharedSession] getUserSelfActivity]
   subscribeError:^(NSError *error) {
     ErrorLog(error.localizedDescription);
   }];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
  [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return (NSInteger)self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  id <NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[(NSUInteger)section];
  return (NSInteger)sectionInfo.numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  AWFMessagesViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[AWFMessagesViewCell reuseIdentifier]
                                                              forIndexPath:indexPath];
  AWFPerson *person = [self.fetchedResultsController objectAtIndexPath:indexPath];
  NSDate *lastActivityDate = [person.activitiesCreated valueForKeyPath:@"@max.dateCreated"];
  cell.imageView.image = nil;
  cell.nameLabel.text = person.fullName;
  cell.timeLabel.text = [self.formatter stringForTimeIntervalFromDate:[NSDate date] toDate:lastActivityDate];
  cell.placeholderView.text = person.abbreviatedName;
  cell.lastMessageLabel.text =
    [NSString stringWithFormat:NSLocalizedString(@"AWF_FRIENDSHIP_EREQUEST_STRING", nil), person.fullName];
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
