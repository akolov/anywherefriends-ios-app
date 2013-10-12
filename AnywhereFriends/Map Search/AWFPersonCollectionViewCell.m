//
//  AWFPersonCollectionViewCell.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/15/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

#import "AWFPersonCollectionViewCell.h"


@interface AWFPersonCollectionViewCell ()

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *distanceLabel;

@end


@implementation AWFPersonCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    CGRect imageFrame = CGRectMake(0, 0, frame.size.width, frame.size.width);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.contentView addSubview:imageView];
    self.imageView = imageView;

    CGRect labelBackgroundFrame = CGRectMake(0, frame.size.height - 20.0f, frame.size.width, 20.0f);
    UIView *labelBackground = [[UIView alloc] initWithFrame:labelBackgroundFrame];
    labelBackground.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    labelBackground.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5f];
    [self.contentView addSubview:labelBackground];

    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectInset(labelBackgroundFrame, 4.0f, 2.0f)];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont helveticaNeueLightFontOfSize:11.0f];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;

//    UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectInset(labelBackgroundFrame, 4.0f, 2.0f)];
//    nameLabel.textColor = [UIColor whiteColor];
//    nameLabel.font = [UIFont helveticaNeueLightFontOfSize:11.0f];
//    [self.contentView addSubview:nameLabel];
//    self.nameLabel = nameLabel;
  }
  return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
