//
//  AnimationManager.h
//  LearnAnimation
//
//  Created by 林伟池 on 16/5/5.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define FIREWORKS_GIFT          0           // 烟花
#define SHIP_GIFT               1           // 轮船
#define AIRPLANE_GIFT           2           // 飞机

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width


@interface AnimationManager : NSObject

@property (nonatomic, assign)BOOL            isShowAnimation;

@property (nonatomic, strong)NSMutableArray<NSDictionary *>  *luxuryArray;

@property (nonatomic, strong)UIView          *livingView;

+ (instancetype)instance;

- (void)showLuxuryAnimation;

- (void)addAnimationWithID:(int)gift_id;

@end
