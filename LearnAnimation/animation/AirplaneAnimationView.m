//
//  AirplaneAnimationView.m
//  qianchuo
//
//  Created by 林伟池 on 16/5/12.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "AirplaneAnimationView.h"
#import "AnimationManager.h"

@interface AirplaneAnimationView ()
@property (nonatomic , strong) UIView* mPlaneView;
@end


@implementation AirplaneAnimationView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.mPlaneView = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:nil options:nil] lastObject];
    [self addSubview:self.mPlaneView];
    [self startAnimation];
    self.userInteractionEnabled = NO;
    return self;
}

- (void)setMNickName:(NSString *)mNickName {
    UILabel* nameLabel = [[UILabel alloc] init];
    nameLabel.text = mNickName;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.shadowColor = [UIColor redColor];
    nameLabel.frame = CGRectMake(120, -30, 0, 0);
    [nameLabel sizeToFit];
    [self.mPlaneView addSubview:nameLabel];
}


- (void)startAnimation {
    [self.mPlaneView setFrame:CGRectMake(ScreenWidth, 0, CGRectGetWidth(self.mPlaneView.bounds), CGRectGetHeight(self.mPlaneView.bounds))];
    [UIView animateWithDuration:2.0 animations:^{
        self.mPlaneView.center = CGPointMake(ScreenWidth / 2, ScreenHeight / 2);
    } completion:^(BOOL finished) {
        // 导弹
        [self playMissileEffectWithMissileView:[self.mPlaneView viewWithTag:10] MissileFireView:[self.mPlaneView viewWithTag:11]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self playMissileEffectWithMissileView:[self.mPlaneView viewWithTag:20] MissileFireView:[self.mPlaneView viewWithTag:21]];
        });
        
        //飞机飞走 不能使用delay方式不行的，动画会冲突
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[self.mPlaneView viewWithTag:10] setHidden:YES];
            [[self.mPlaneView viewWithTag:20] setHidden:YES];
            [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.mPlaneView.center = CGPointMake(-200, ScreenHeight / 2 + 200);
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
                [AnimationManager instance].isShowAnimation = NO;
                [[AnimationManager instance] showLuxuryAnimation];
            }];
        });
    }];
}

- (void)dealloc
{
    NSLog(@"gift dealloc %@",NSStringFromClass(self.class));
}


- (void)playMissileEffectWithMissileView:(UIView *)missileView MissileFireView:(UIView *)missileFireView {

    [UIView animateWithDuration:2.0 animations:^{
        missileView.center = CGPointMake(missileView.center.x, missileView.center.y + 50);
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            missileFireView.alpha = 1;
        } completion:^(BOOL finished) {
        }];
        
        [UIView animateWithDuration:2.0 animations:^{
            [missileView setFrame:CGRectMake(missileView.frame.origin.x - ScreenWidth / 2 - 100, missileView.frame.origin.y + 100, CGRectGetWidth(missileView.bounds), CGRectGetHeight(missileView.bounds))];
        } completion:^(BOOL finished) {
            [missileView setHidden:YES];
//            [missileView removeFromSuperview]; 添加后会产生bug
        }];
    }];
    
}

@end
