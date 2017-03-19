//
//  AnimationHeartView.m
//  qianchuo
//
//  Created by 木头 on 16/5/7.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "AnimationHeartView.h"

@interface AnimationHeartView () <CAAnimationDelegate>
@property (nonatomic , assign) long mCurrentFarme;
@property (nonatomic , strong) NSTimer* mAnimationTimer;
@property (nonatomic , strong) UIImageView* mHeartImageView;

@end


#define const_arrow_offset_rate 0.7

@implementation AnimationHeartView

static UIImage* gWaveFrameImage;
static UIImage* gBoatFrameImage;
static UIImage* gShadowFrameImage;
static NSArray<UIImage *>* gHeartFramesArray;              //心形帧图片


+ (void)initialize {
    // 3
    NSMutableArray* imagesArr = [NSMutableArray array];
    UIImage* sourceImage = [UIImage imageNamed:@"gift_heart"];
    CGSize sourceSize = sourceImage.size;
    long imagesNum = 22;
    for (int i = 0; i < imagesNum; ++i) {
        CGImageRef cgimage = CGImageCreateWithImageInRect(sourceImage.CGImage, CGRectMake(i * sourceSize.width / imagesNum, 0, sourceSize.width / imagesNum, sourceSize.height));
        UIImage* tmp = [UIImage imageWithCGImage:cgimage];
        CGImageRelease(cgimage);
        if (tmp) {
            [imagesArr addObject:tmp];
        }
    }
    gHeartFramesArray = imagesArr;
}

- (void)playHeart {
    self.mHeartImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:self.mHeartImageView];
    
    self.mAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:0.08 target:self selector:@selector(onPlayNextHeart) userInfo:nil repeats:YES];
    self.mCurrentFarme = 0;
}

- (void)onPlayNextHeart {
    if (self.mCurrentFarme >= gHeartFramesArray.count - 2) {
        [self.mAnimationTimer invalidate];
        self.mAnimationTimer = nil;
        //心形放大
        [UIView animateWithDuration:3.0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
             
            self.mHeartImageView.transform = CGAffineTransformMakeScale(1.5, 1.5);
        } completion:^(BOOL finished) {
            const float defaultHeight = CGRectGetHeight(self.mHeartImageView.bounds) * const_arrow_offset_rate;
            UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.mHeartImageView.bounds), CGRectGetHeight(self.mHeartImageView.bounds))];
            imageView.center = CGPointMake(-CGRectGetWidth(self.mHeartImageView.bounds), defaultHeight);
            [self addSubview:imageView];
            [imageView setImage:gHeartFramesArray[gHeartFramesArray.count - 2]];
            
            CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            UIBezierPath* path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(-CGRectGetWidth(imageView.bounds) / 2, defaultHeight)];
            [path addCurveToPoint:CGPointMake(CGRectGetWidth(self.bounds) * 3 / 2, defaultHeight) controlPoint1:CGPointMake(100, defaultHeight - 10) controlPoint2:CGPointMake(150, defaultHeight - 10)];
            // 测试曲线用
            //            UIGraphicsBeginImageContext(self.bounds.size);
            //            [path stroke];
            //            UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
            //            UIImageView* testView = [[UIImageView alloc] initWithFrame:self.bounds];
            //            [testView setImage:image];
            //            [self addSubview:testView];
            //            UIGraphicsEndImageContext();
            
            animation.path = path.CGPath;
            animation.fillMode              = kCAFillModeForwards;
            animation.removedOnCompletion   = NO;
            animation.duration              = 0.8;
            animation.timingFunction        = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            animation.delegate              = self;
            [animation setValue:@"heartArrowFly" forKey:@"id"];
            [animation setValue:imageView forKey:@"object"];
            [imageView.layer addAnimation:animation forKey:@"position"];
        }];
    }
    else {
        [self.mHeartImageView setImage:gHeartFramesArray[self.mCurrentFarme]];
        ++self.mCurrentFarme;
    }
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSString* identifer = [anim valueForKey:@"id"];
    if ([identifer isEqualToString:@"heartArrowFly"]) {
        UIImageView* imageView = [anim valueForKey:@"object"];
        
        [UIView animateWithDuration:1.0 animations:^{
             
            self.mHeartImageView.alpha = 0;
        } completion:^(BOOL finished) {
             
            self.mHeartImageView.image = nil;
        }];
        
        [imageView setImage:nil];
    }
}


- (void)dealloc {
    NSLog(@"gift dealloc %@", self);
}


@end
