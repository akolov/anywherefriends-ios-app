//
//  AWFNearbyViewController.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/15/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

#import "AWFNearbyViewController.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "UIBezierPath+MenuGlyph.h"
#import "UIBezierPath+MessagesGlyph.h"

#import "AWFIconButton.h"
#import "AWFLabelButton.h"
#import "AWFNavigationTitleView.h"
#import "AWFPersonCollectionViewCell.h"
#import "AWFProfileViewController.h"


static CGFloat const kHeaderHeight = 164.0f;
static CGFloat const kButtonBarHeight = 44.0f;


@interface AWFNearbyViewController ()

@property (nonatomic, strong) NSArray *temporaryData;

@end


@implementation AWFNearbyViewController

- (id)init {
  UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
  layout.itemSize = CGSizeMake(104.0f, 104.0f);
  layout.minimumInteritemSpacing = 2.0f;
  layout.minimumLineSpacing = 2.0f;
  layout.sectionInset = UIEdgeInsetsMake(2.0f, 2.0f, 2.0f, 2.0f);
  return [super initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.navigationController.navigationBar.translucent = YES;
  self.navigationItem.titleView = [AWFNavigationTitleView navigationTitleView];

  UIBezierPath *menuIcon = [UIBezierPath menuGlyph];

  AWFIconButton *menuButton = [[AWFIconButton alloc] initWithFrame:CGRectMake(0, 0, menuIcon.bounds.size.width, menuIcon.bounds.size.height)];
  menuButton.icon.path = menuIcon;
  [menuButton setIconColor:[UIColor colorWithWhite:1.0f alpha:0.7f] forState:UIControlStateNormal];

  UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
  self.navigationItem.leftBarButtonItem = leftBarButtonItem;

  UIBezierPath *messagesIcon = [UIBezierPath messagesGlyph];
  [messagesIcon applyTransform:CGAffineTransformMakeScale(1.3f, 1.3f)];

  AWFIconButton *messagesButton = [[AWFIconButton alloc] initWithFrame:CGRectMake(0, 0, messagesIcon.bounds.size.width, messagesIcon.bounds.size.height)];
  messagesButton.icon.path = messagesIcon;
  [messagesButton setIconColor:[UIColor colorWithWhite:1.0f alpha:0.7f] forState:UIControlStateNormal];

  UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:messagesButton];
  self.navigationItem.rightBarButtonItem = rightBarButtonItem;

  // Set up collection view

  self.collectionView.backgroundColor = nil;
  self.collectionView.contentInset = UIEdgeInsetsMake(kHeaderHeight + kButtonBarHeight, 0, 0, 0);
  self.collectionView.opaque = NO;
  [self.collectionView registerClass:[AWFPersonCollectionViewCell class] forCellWithReuseIdentifier:[AWFPersonCollectionViewCell reuseIdentifier]];

  // Set up map view

  CGRect mapFrame = self.view.bounds;
  mapFrame.size.height = kHeaderHeight + self.navigationController.navigationBar.bounds.size.height;

  MKMapView *mapView = [MKMapView autolayoutView];
  mapView.showsUserLocation = YES;

  [self.view insertSubview:mapView atIndex:0];
  self.mapView = mapView;

  // Set up button bar

  UIToolbar *buttonBar = [UIToolbar autolayoutView];
  buttonBar.barStyle = UIBarStyleBlackTranslucent;
  [self.view insertSubview:buttonBar aboveSubview:self.collectionView];

  // Set up buttons

  UIImage *selectedBackground = [UIGraphicsContextWithOptions(CGSizeMake(3.0f, 5.0f), NO, 0, ^(CGRect rect, CGContextRef context) {
    [[UIColor awfPinkColor] setFill];
    CGContextFillRect(context, CGRectMake(0, 0, 3.0f, 4.0f));
  }) resizableImageWithCapInsets:UIEdgeInsetsMake(4.0f, 1.0f, 0, 1.0f)];

  AWFLabelButton *nearbyButton = [AWFLabelButton autolayoutView];
  nearbyButton.selected = YES;
  nearbyButton.titleLabel.font = [UIFont helveticaNeueLightFontOfSize:18.0f];
  nearbyButton.titleLabel.text = NSLocalizedString(@"AWF_HOME_BUTTON_BAR_NEARBY_TITLE", @"Title for the Nearby button on the home view button bar");
  [nearbyButton setBackgroundImage:selectedBackground forState:UIControlStateSelected];
  [nearbyButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.6f] forState:UIControlStateNormal];
  [nearbyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
  [nearbyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];

  AWFLabelButton *friendsButton = [AWFLabelButton autolayoutView];
  friendsButton.titleLabel.font = [UIFont helveticaNeueLightFontOfSize:18.0f];
  friendsButton.titleLabel.text = NSLocalizedString(@"AWF_HOME_BUTTON_BAR_FRIENDS_TITLE", @"Title for the Friends button on the home view button bar");
  [friendsButton setBackgroundImage:selectedBackground forState:UIControlStateSelected];
  [friendsButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.6f] forState:UIControlStateNormal];
  [friendsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
  [friendsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];

  AWFLabelButton *searchesButton = [AWFLabelButton autolayoutView];
  searchesButton.titleLabel.font = [UIFont helveticaNeueLightFontOfSize:18.0f];
  searchesButton.titleLabel.text = NSLocalizedString(@"AWF_HOME_BUTTON_BAR_SEARCHES_TITLE", @"Title for the Searches button on the home view button bar");
  searchesButton.titleLabel.textColor = [UIColor whiteColor];
  [searchesButton setBackgroundImage:selectedBackground forState:UIControlStateSelected];
  [searchesButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.6f] forState:UIControlStateNormal];
  [searchesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
  [searchesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];

  buttonBar.items = @[[[UIBarButtonItem alloc] initWithCustomView:nearbyButton],
                      [[UIBarButtonItem alloc] initWithCustomView:friendsButton],
                      [[UIBarButtonItem alloc] initWithCustomView:searchesButton]];

  NSDictionary *const buttonBarViews = NSDictionaryOfVariableBindings(nearbyButton, friendsButton, searchesButton);
  [buttonBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[nearbyButton][friendsButton(==nearbyButton)][searchesButton(==nearbyButton)]|" options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:nil views:buttonBarViews]];
  [buttonBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[nearbyButton]|" options:0 metrics:nil views:buttonBarViews]];

  // Set up layout

  NSDictionary *const views = NSDictionaryOfVariableBindings(buttonBar, mapView);
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[mapView]|" options:0 metrics:nil views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[buttonBar]|" options:0 metrics:nil views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[mapView]" options:0 metrics:nil views:views]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:buttonBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:kButtonBarHeight]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:buttonBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:mapView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0]];

  NSLayoutConstraint *headerHeightConstraint = [NSLayoutConstraint constraintWithItem:mapView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:kHeaderHeight];
  [self.view addConstraint:headerHeightConstraint];

  RAC(headerHeightConstraint, constant) = [[RACAble(self.collectionView.contentOffset)
                                            filter:^BOOL(id value) {
                                              return [value CGPointValue].y <= 0;
                                            }]
                                           map:^id(id value) {
                                             return @(-[value CGPointValue].y);
                                           }];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.mapView setUserTrackingMode:MKUserTrackingModeFollow];
}

#pragma mark - UICollectionView data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return self.temporaryData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  AWFPersonCollectionViewCell *cell = (AWFPersonCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:[AWFPersonCollectionViewCell reuseIdentifier] forIndexPath:indexPath];

  NSString *name = self.temporaryData[indexPath.row];
  cell.imageView.image = [UIImage imageNamed:[name stringByAppendingString:@".jpg"]];
  cell.label.text = name;
  return cell;
}

#pragma mark - UICollectionView delegate methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  AWFProfileViewController *vc = [[AWFProfileViewController alloc] init];
  [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Private methods

- (NSArray *)temporaryData {
  if (!_temporaryData) {
    _temporaryData = @[
                       @"Marissa",   // 1
                       @"Lorenza",   // 2
                       @"Matze",     // 3
                       @"Veronica",  // 4
                       @"Jacky",     // 5
                       @"Marine",    // 6
                       @"Victoria",  // 7
                       @"Alessio",   // 8
                       @"Ajda",      // 9
                       @"Andrea",    // 10
                       @"Carrie",    // 11
                       @"Damien",    // 12
                       @"Ebba",      // 13
                       @"Emilia",    // 14
                       @"Kenza",     // 15
                       @"Kristina",  // 16
                       @"Lauren",    // 17
                       @"Marie",     // 18
                       @"Max",       // 19
                       @"Michael",   // 20
                       @"Olivia",    // 21
                       ];
  }
  return _temporaryData;
}

@end
