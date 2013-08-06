//
//  AWFIconLabelView.h
//  AnywhereFriends
//
//  Created by Alexander Kolov on 8/5/13.
//  Copyright (c) 2013 AnywhereFriends. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AWFShapeView.h"

@interface AWFIconLabelView : UIView

@property (nonatomic, strong, readonly) AWFShapeView *icon;
@property (nonatomic, strong, readonly) UILabel *label;
@property (nonatomic) CGFloat spacing;

@end
