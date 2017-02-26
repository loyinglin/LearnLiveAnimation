//
//  AnimationManager.m
//  LearnAnimation
//
//  Created by 林伟池 on 16/5/5.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "AnimationManager.h"
#import "AnimationBoatView.h"
#import "AnimationFireworksView.h"
#import "AirplaneAnimationView.h"

@interface AnimationManager ()

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
    [self addLuxuryDict:dict];
}

#pragma mark - animation


- (void)addLuxuryDict:(NSDictionary *)luxuryDict
{
    if (!_luxuryArray) {
        _luxuryArray = [NSMutableArray array];
    }
    [_luxuryArray addObject:luxuryDict];
    [self showLuxuryAnimation];
}


- (void) showLuxuryAnimation
{
    if (_isShowAnimation) {
        return;
    }
    if ([AnimationManager instance].luxuryArray && [AnimationManager instance].luxuryArray.count > 0) {
        self.isShowAnimation = YES;
        
        NSDictionary *luxuryDict = [[AnimationManager instance].luxuryArray objectAtIndex:0];
        [[AnimationManager instance].luxuryArray removeObjectAtIndex:0];
        if ([luxuryDict[@"gift_id"] intValue] == FIREWORKS_GIFT) {
            if (_livingView) {
                AnimationFireworksView* fireworksView = [[AnimationFireworksView alloc] initWithFrame:CGRectMake(ScreenWidth / 2 - const_fireworks_height / 2, ScreenHeight * (1 - 1.0 / 5) - const_fireworks_height , const_fireworks_height, const_fireworks_height)];
                fireworksView.mNickName = luxuryDict[@"nickname"];
                [_livingView addSubview:fireworksView];
            }
        } else if([luxuryDict[@"gift_id"] intValue] == AIRPLANE_GIFT) {
            if (_livingView) {
                AirplaneAnimationView* planeView = [[AirplaneAnimationView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
                planeView.mNickName = luxuryDict[@"nickname"];
                [_livingView addSubview:planeView];
            }
        } else if ([luxuryDict[@"gift_id"] intValue] == SHIP_GIFT){
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
