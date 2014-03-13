//
//  AWFViewController.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 13/03/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "AWFViewController.h"
#import "AWFNavigationTitleView.h"

@interface AWFViewController ()

- (void)onSettingsBarButton:(UIBarButtonItem *)button;

@end

@implementation AWFViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.navigationItem.titleView = [AWFNavigationTitleView navigationTitleView];
  self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings"]
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(onSettingsBarButton:)];
}

#pragma mark - Action

- (void)onSettingsBarButton:(UIBarButtonItem *)button {
  [self presentSettingsViewControllerAnimated:YES];
}

#pragma mark - Public Methods

- (void)presentSettingsViewControllerAnimated:(BOOL)animated {

}

@end
