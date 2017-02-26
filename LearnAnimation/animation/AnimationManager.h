//
//  AnimationManager.h
//  LearnAnimation
//
//  Created by 林伟池 on 16/5/5.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
// 烟花
// 轮船
// 飞机
typedef NS_ENUM(NSUInteger, GIFT_TYPE) {
    FIREWORKS_GIFT = 1,
    SHIP_GIFT = 2,
    AIRPLANE_GIFT = 3,
};


#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width


@interface AnimationManager : NSObject


/**
 当前是否在播放端动画
 */
@property (nonatomic, assign)BOOL            isShowAnimation;

/**
 待播放的礼物动画
 */
@property (nonatomic, strong)NSMutableArray<NSDictionary *>  *luxuryArray;

@property (nonatomic, strong)UIView          *livingView;

+ (instancetype)instance;


/**
 启用动画显示
 */
- (void)showLuxuryAnimation;


/**
 增加一个新的礼物动画

 @param gift_id 礼物id
 */
- (void)addAnimationWithID:(int)gift_id;

@end
