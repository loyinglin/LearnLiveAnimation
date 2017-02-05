//
//  AnimationFireworksView.h
//  LearnAnimation
//
//  Created by 林伟池 on 16/5/4.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import <UIKit/UIKit.h>

#define const_fireworks_height 250

@interface AnimationFireworksView : UIView

@property (nonatomic , strong) NSString* mNickName;

+ (void)reset;
+ (void)initImage;


@end
