//
//  AnimationManager.h
//  LearnAnimation
//
//  Created by 木头 on 16/5/5.
//  Copyright © 2016年 木头. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



typedef NS_ENUM(NSUInteger, GIFT_TYPE) {
    GIFT_FIREWORKS = 0, // 烟花
    GIFT_BOAT = 1, // 轮船
    GIFT_COUNT,
};




@interface AnimationManager : NSObject

/**
 直播间内视图
 */
@property (nonatomic, strong)UIView          *livingView;


+ (instancetype)instance;


/**
 动画回调
 */
- (void)OnAnimationComplete;


/**
 增加一个新的礼物动画

 @param gift_id 礼物id
 */
- (void)addAnimationWithID:(int)gift_id;

@end
