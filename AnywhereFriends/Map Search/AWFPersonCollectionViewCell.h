//
//  AWFPersonCollectionViewCell.h
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/15/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AWFPersonCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak, readonly) UIImageView *imageView;
@property (nonatomic, weak, readonly) UILabel *nameLabel;
@property (nonatomic, weak, readonly) UILabel *distanceLabel;

@end
