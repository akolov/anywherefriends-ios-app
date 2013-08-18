//
//  AWFPhotoCollectionViewCell.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/18/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

#import "AWFPhotoCollectionViewCell.h"


@interface AWFPhotoCollectionViewCell ()

@property (nonatomic, weak) UIImageView *imageView;

@end


@implementation AWFPhotoCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    self.imageView = imageView;
    [self addSubview:imageView];
  }
  return self;
}

@end
