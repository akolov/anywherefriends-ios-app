//
//  AWFProfileTableViewCell.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/18/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

#import "AWFProfileTableViewCell.h"

@implementation AWFProfileTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
  if (self) {
    self.backgroundColor = [UIColor blackColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.textLabel.font = [UIFont helveticaNeueFontOfSize:12.0f];
    self.textLabel.textColor = [UIColor lightGrayColor];

    self.detailTextLabel.font = [UIFont helveticaNeueFontOfSize:18.0f];
    self.detailTextLabel.textColor = [UIColor whiteColor];
  }
  return self;
}

@end
