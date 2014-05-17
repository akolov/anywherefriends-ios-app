//
//  AWFOtherProfileViewController.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 17/05/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "AWFConfig.h"
#import "AWFOtherProfileViewController.h"

#import <AXKCollectionViewTools/AXKCollectionViewTools.h>
#import <FormatterKit/TTTTimeIntervalFormatter.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Slash/Slash.h>

#import "AWFAppDelegate.h"
#import "AWFProfileHeaderView.h"
#import "AWFPhotoCollectionViewCell.h"
#import "AWFLabelButton.h"
#import "AWFMapViewController.h"
#import "AWFSession.h"

@interface AWFOtherProfileViewController ()

@property (nonatomic, strong) TTTTimeIntervalFormatter *timeFormatter;

- (void)didTapFriendButton:(id)sender;
- (void)didTapSendMessageButton:(id)sender;
- (void)didTapLocationButton:(id)sender;

- (void)reloadHeaderView;

@end

@implementation AWFOtherProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  // Header View

  self.headerView = [[AWFProfileHeaderView alloc] init];
  self.headerView.descriptionLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.tableView.bounds);
  self.headerView.photoCollectionView.dataSource = self;
  self.headerView.photoCollectionView.delegate = self;

  [self.headerView.friendButton addTarget:self
                                   action:@selector(didTapFriendButton:)
                         forControlEvents:UIControlEventTouchUpInside];
  [self.headerView.messageButton addTarget:self
                                    action:@selector(didTapSendMessageButton:)
                          forControlEvents:UIControlEventTouchUpInside];
  [self.headerView.locationButton addTarget:self
                                     action:@selector(didTapLocationButton:)
                           forControlEvents:UIControlEventTouchUpInside];

  [self reloadHeaderView];

  self.tableView.tableHeaderView = self.headerView;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)didTapFriendButton:(id)sender {
  [[[AWFSession sharedSession] friendUser:self.person]
   subscribeError:^(NSError *error) { ErrorLog(error.localizedDescription); }
   completed:^{ [self.headerView setFriendshipStatus:AWFFriendshipStatusPending]; }];
}

- (void)didTapSendMessageButton:(id)sender {
  AWFAppDelegate *appDelegate = (AWFAppDelegate *)[UIApplication sharedApplication].delegate;
  appDelegate.tabBarController.selectedIndex = 2;
}

- (void)didTapLocationButton:(id)sender {
  AWFMapViewController *vc = [[AWFMapViewController alloc] initWithPerson:self.person];
  [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Properties

- (TTTTimeIntervalFormatter *)timeFormatter {
  if (!_timeFormatter) {
    _timeFormatter = [[TTTTimeIntervalFormatter alloc] init];
  }
  return _timeFormatter;
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
                              }
                          , @"em" : @{
                              NSFontAttributeName : [UIFont helveticaNeueFontOfSize:10.0f],
                              NSForegroundColorAttributeName : [UIColor grayColor]
                              }
                          }
  ;

  NSString *lastUpdated, *markup;
  if (self.person.locationUpdated) {
    lastUpdated = [self.timeFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:self.person.locationUpdated];
    markup = [NSString stringWithFormat:@"%@\n<em>%2.f m from you — %@</em>", self.person.locationName,
              self.person.locationDistanceValue, lastUpdated];
  } else {
    markup = [NSString
              stringWithFormat:@"%@\n<em>%2.f m from you</em>", self.person.locationName, self.person.locationDistanceValue];
  }

  self.headerView.locationLabel.attributedText =
  [SLSMarkupParser attributedStringWithMarkup:markup style:style error:NULL];
  self.headerView.descriptionLabel.text = self.person.bio;
  [self.headerView setFriendshipStatus:self.person.friendshipValue];

  CGRect bounds;
  bounds.size.width = CGRectGetWidth(self.tableView.bounds);
  bounds.size.height = [self.headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
  
  self.headerView.bounds = bounds;
  
  [self.headerView setNeedsLayout];
  [self.headerView layoutIfNeeded];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  AWFPhotoCollectionViewCell *cell =
  [collectionView dequeueReusableCellWithReuseIdentifier:[AWFPhotoCollectionViewCell reuseIdentifier]
                                            forIndexPath:indexPath];
  cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"Jasmin_t%ld.jpg", (long)indexPath.row]];
  return cell;
}

@end
