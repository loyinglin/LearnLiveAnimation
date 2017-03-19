//
//  ViewController.m
//  LearnAnimation
//
//  Created by 木头 on 16/5/4.
//  Copyright © 2016年 木头. All rights reserved.
//

#import "ViewController.h"
#import "AnimationFireworksView.h"
#import "AnimationBoatView.h"
#import "AnimationManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [AnimationManager instance].livingView = self.view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onKeyFrameAnimation:(id)sender {
//    [[AnimationManager instance] addAnimationWithID:arc4random_uniform(GIFT_COUNT)];
    static int index = 0;
    [[AnimationManager instance] addAnimationWithID:index++ % GIFT_COUNT];
}


@end
