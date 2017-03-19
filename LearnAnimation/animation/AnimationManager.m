//
//  AnimationManager.m
//  LearnAnimation
//
//  Created by 木头 on 16/5/5.
//  Copyright © 2016年 木头. All rights reserved.
//

#import "AnimationManager.h"
#import "AnimationBoatView.h"
#import "AnimationFireworksView.h"


@interface AnimationManager ()

/**
 待播放的礼物动画
 */
@property (nonatomic, strong)NSMutableArray<NSDictionary *>  *luxuryArray;

/**
 当前是否在播放端动画
 */
@property (nonatomic, assign)BOOL            isShowAnimation;

@end

@implementation AnimationManager


#pragma mark - init


+ (instancetype)instance {
    static id test;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        test = [[[self class] alloc] init];
    });
    return test;
}

- (void)addAnimationWithID:(int)gift_id {
    NSDictionary *dict = @{@"gift_id":@(gift_id), @"nickname":@"木头"};
    NSLog(@"add a gift with id %d", gift_id);
    [self addLuxuryDict:dict];
}

#pragma mark - animation


- (void)addLuxuryDict:(NSDictionary *)luxuryDict
{
    if (!_luxuryArray) {
        _luxuryArray = [NSMutableArray array];
    }
    [_luxuryArray addObject:luxuryDict];
    [self showAnimation];
}

- (void)OnAnimationComplete {
    NSLog(@"gift animation call back");
    self.isShowAnimation = NO;
    [self showAnimation];
}

- (void) showAnimation
{
    if (self.isShowAnimation) {
        return;
    }
    if ([AnimationManager instance].luxuryArray && [AnimationManager instance].luxuryArray.count > 0) {
        self.isShowAnimation = YES;
        
        NSDictionary *luxuryDict = [[AnimationManager instance].luxuryArray objectAtIndex:0];
        [[AnimationManager instance].luxuryArray removeObjectAtIndex:0];
        if ([luxuryDict[@"gift_id"] intValue] == GIFT_FIREWORKS) {
            if (_livingView) {
                AnimationFireworksView* fireworksView = [[AnimationFireworksView alloc] initWithFrame:CGRectMake(ScreenWidth / 2 - const_fireworks_height / 2, ScreenHeight * (1 - 1.0 / 5) - const_fireworks_height , const_fireworks_height, const_fireworks_height)];
                fireworksView.mNickName = luxuryDict[@"nickname"];
                [_livingView addSubview:fireworksView];
            }
        } else if ([luxuryDict[@"gift_id"] intValue] == GIFT_BOAT){
            if (_livingView) {
                AnimationBoatView* boatView = [[AnimationBoatView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
                boatView.userInteractionEnabled = NO;
                boatView.mNickName = luxuryDict[@"nickname"];
                [_livingView addSubview:boatView];
            }
        }
    } else {
        _isShowAnimation = NO;
    }
}


@end
