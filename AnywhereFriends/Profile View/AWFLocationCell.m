//
//  AWFLocationCell.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 18/05/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "AWFConfig.h"
#import "AWFLocationCell.h"

@interface AWFLocationCell ()

@property (nonatomic, assign) BOOL didUpdateConstraints;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;

@end

@implementation AWFLocationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.titleLabel = [UILabel autolayoutView];
    self.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:self.titleLabel];

    self.subtitleLabel = [UILabel autolayoutView];
    self.subtitleLabel.font = [UIFont systemFontOfSize:12.0f];
    self.subtitleLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.subtitleLabel];

    [self pin:@"V:|[titleLabel][subtitleLabel]|" options:0 owner:self];
    [self pin:@"H:|-(15.0)-[titleLabel]-(>=15.0)-|" options:0 owner:self];
    [self pin:@"H:|-(15.0)-[subtitleLabel]-(>=15.0)-|" options:0 owner:self];
  }
  return self;
}

- (UILabel *)textLabel {
  return self.titleLabel;
}

- (UILabel *)detailTextLabel {
  return self.subtitleLabel;
}

@end
