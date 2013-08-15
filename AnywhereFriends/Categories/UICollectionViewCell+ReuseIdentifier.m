//
//  UICollectionViewCell+ReuseIdentifier.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/15/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

#import "UICollectionViewCell+ReuseIdentifier.h"

@implementation UICollectionViewCell (ReuseIdentifier)

+ (NSString *)reuseIdentifier {
  return NSStringFromClass([self class]);
}

@end
