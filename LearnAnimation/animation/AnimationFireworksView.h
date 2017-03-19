//
//  AnimationFireworksView.h
//  LearnAnimation
//
//  Created by 木头 on 16/5/4.
//  Copyright © 2016年 木头. All rights reserved.
//

#import <UIKit/UIKit.h>

#define const_fireworks_height 250

@interface AnimationFireworksView : UIView

@property (nonatomic , strong) NSString* mNickName;

+ (void)reset;
+ (void)initImage;


@end
