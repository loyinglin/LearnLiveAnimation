//
//  AnimationBoatView.m
//  LearnAnimation
//
//  Created by 木头 on 16/5/5.
//  Copyright © 2016年 木头. All rights reserved.
//

#import "AnimationBoatView.h"
#import "AnimationHeartView.h"
#import "AnimationManager.h"

@interface AnimationBoatView ()
@property (nonatomic , strong) UIImageView* mWaveLeftImageView;
@property (nonatomic , strong) UIImageView* mWaveRightImageView;
@property (nonatomic , strong) UIScrollView* mScrollView;

@property (nonatomic , strong) UIView* mBoatView;
@property (nonatomic , strong) UIImageView* mBoatImageView;
@property (nonatomic , strong) UIImageView* mShadowImageView;

@property (nonatomic , readonly) float mBoatHeight;
@property (nonatomic , readonly) float mBoatWidth;
@property (nonatomic , readonly) float mBoatHeightOffset;

@end




@implementation AnimationBoatView


static UIImage* gWaveFrameImage;
static UIImage* gBoatFrameImage;
static UIImage* gShadowFrameImage;
static NSArray<UIImage *>* gHeartFramesArray;              //心形帧图片

#define const_position_boat_x 1538
#define const_shadow_height_rate 1.0
#define const_boat_width 622
#define const_boat_height 380
#define const_wave_height 200
#define const_boat_position_y_offset 220

+ (void)reset {
    gWaveFrameImage = nil;
    gBoatFrameImage = nil;
    gShadowFrameImage = nil;
    gHeartFramesArray = nil;
}

+ (void)initImage {
    
}

+ (void)initialize {
    UIImage* sourceImage = [UIImage imageNamed:@"gift_boat"];
    CGSize sourceSize = sourceImage.size;
    CGImageRef cgimage = CGImageCreateWithImageInRect(sourceImage.CGImage,
                                                      CGRectMake(0, 0, const_position_boat_x, sourceSize.height));
    gWaveFrameImage = [UIImage imageWithCGImage:cgimage];
    CGImageRelease(cgimage);
    
    cgimage = CGImageCreateWithImageInRect(sourceImage.CGImage,
                                           CGRectMake(const_position_boat_x, 0, const_boat_width, const_boat_height));
    gBoatFrameImage = [UIImage imageWithCGImage:cgimage];
    CGImageRelease(cgimage);
    
    cgimage = CGImageCreateWithImageInRect(sourceImage.CGImage,
                                           CGRectMake(const_position_boat_x + const_boat_width, 0, sourceSize.width - const_position_boat_x - const_boat_width, sourceSize.height));
    gShadowFrameImage = [UIImage imageWithCGImage:cgimage];
    CGImageRelease(cgimage);
    
    // 3
    NSMutableArray* imagesArr = [NSMutableArray array];
    sourceImage = [UIImage imageNamed:@"gift_heart"];
    sourceSize = sourceImage.size;
    long imagesNum = 22;
    for (int i = 0; i < imagesNum; ++i) {
        CGImageRef cgimage = CGImageCreateWithImageInRect(sourceImage.CGImage, CGRectMake(i * sourceSize.width / imagesNum, 0, sourceSize.width / imagesNum, sourceSize.height));
        UIImage* tmp = [UIImage imageWithCGImage:cgimage];
        
        if (tmp) {
            [imagesArr addObject:tmp];
        }
    }
    gHeartFramesArray = imagesArr;
}

- (void)dealloc {
    NSLog(@"dealloc %@",NSStringFromClass(self.class));
}


- (instancetype)init {
    self = [super init];
    [self customInit];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self customInit];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self customInit];
    return self;
}

- (void)customInit {
    if (self.mScrollView) {
        [self.mScrollView removeFromSuperview];
    }
    self.mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - const_wave_height, CGRectGetWidth(self.bounds), const_wave_height)];
    [self addSubview:self.mScrollView];
    
    if (self.mWaveLeftImageView) {
        [self.mWaveLeftImageView removeFromSuperview];
    }
    self.mWaveLeftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, const_position_boat_x, const_wave_height)];
    [self.mScrollView addSubview:self.mWaveLeftImageView];
    
    if (self.mWaveRightImageView) {
        [self.mWaveRightImageView removeFromSuperview];
    }
    self.mWaveRightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, const_position_boat_x, const_wave_height)];
    [self.mScrollView addSubview:self.mWaveRightImageView];
    
    if (self.mBoatView) {
        [self.mBoatView removeFromSuperview];
    }
    self.mBoatView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.mBoatWidth, self.mBoatHeight)];
    [self addSubview:self.mBoatView];
    
    if (self.mBoatImageView) {
        [self.mBoatImageView removeFromSuperview];
    }
    self.mBoatImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.mBoatView.bounds), CGRectGetHeight(self.mBoatView.bounds))];
    self.mBoatImageView.transform = CGAffineTransformMakeRotation(-M_PI / 18);
    [self.mBoatView addSubview:self.mBoatImageView];
    
    if (self.mShadowImageView) {
        [self.mShadowImageView removeFromSuperview];
    }
    self.mShadowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.mBoatImageView.bounds) * const_shadow_height_rate, CGRectGetWidth(self.mBoatImageView.bounds), CGRectGetHeight(self.mBoatImageView.bounds))];
    [self.mBoatView addSubview:self.mShadowImageView];
    
     
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         
        [self startAnimation];
    });
}

- (void)setMNickName:(NSString *)mNickName {
    UILabel* nameLabel = [[UILabel alloc] init];
    nameLabel.text = mNickName;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.shadowColor = [UIColor yellowColor];
    nameLabel.frame = CGRectMake(50, -30, 0, 0);
    [nameLabel sizeToFit];
    [self.mBoatView addSubview:nameLabel];
}

- (float)mBoatWidth {
    return const_boat_width / 3;
}

- (float)mBoatHeight {
    return const_boat_height / 3;
}


- (void)startAnimation {
    self.alpha = 0;
    [self play];
    [UIView animateWithDuration:1.0 animations:^{
        self.alpha = 1;
    }];
}

- (void)play {
    [self.mWaveLeftImageView setImage:gWaveFrameImage];
    [self.mWaveRightImageView setImage:gWaveFrameImage];
    
    CGRect frame = self.mWaveLeftImageView.frame;
    frame.origin.x = self.mScrollView.frame.size.width - frame.size.width;
    [self.mWaveRightImageView setFrame:frame];
    
    //boat
    [self.mBoatImageView setImage:gBoatFrameImage];
    [self.mShadowImageView setImage:gShadowFrameImage];
    
     
    [UIView animateWithDuration:16.0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
         
        CGRect frame = self.mWaveLeftImageView.frame;
        frame.origin.x = self.mScrollView.frame.size.width - frame.size.width;
        [self.mWaveLeftImageView setFrame:frame];
        
        frame.origin.x = 0;
        [self.mWaveRightImageView setFrame:frame];
        
    } completion:^(BOOL finished) {
         
        CGRect frame = self.mWaveLeftImageView.frame;
        frame.origin.x = 0;
        [self.mWaveLeftImageView setFrame:frame];
        
        frame.origin.x = self.mScrollView.frame.size.width - frame.size.width;
        [self.mWaveRightImageView setFrame:frame];
    }];
    
    self.mBoatView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    
    const float defaultHeight = CGRectGetHeight(self.bounds) - const_boat_position_y_offset;
    self.mBoatView.center = CGPointMake(0, defaultHeight);
    [UIView animateWithDuration:2.0 animations:^{
        // 入场放大
         
        self.mBoatView.transform = CGAffineTransformIdentity;

        self.mBoatView.center = CGPointMake(self.mBoatWidth / 4, defaultHeight);
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:4.0 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            // 行驶到中间
             
            self.mBoatView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2 , defaultHeight);
        } completion:^(BOOL finished) {
             
            // 添加心形动画
            AnimationHeartView* heartView = [[AnimationHeartView alloc] initWithFrame:CGRectMake(0, 0,const_heart_default_size, const_heart_default_size)];
            heartView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 4);
            [self addSubview:heartView];
            [heartView playHeart];
            
            [UIView animateWithDuration:4.0 delay:const_heart_time options:UIViewAnimationOptionCurveEaseIn animations:^{
                // 停顿三秒后向右边
                self.mBoatView.center = CGPointMake(CGRectGetWidth(self.bounds) + self.mBoatWidth, defaultHeight);
            } completion:^(BOOL finished) {
                [self endAnimation];
            }];
            
        }];
    }];
}

- (void)endAnimation {
    [UIView animateWithDuration:1.0 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [[AnimationManager instance] OnAnimationComplete];
    }];
}


@end
