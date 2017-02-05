//
//  ViewController.m
//  LearnAnimation
//
//  Created by 林伟池 on 16/5/4.
//  Copyright © 2016年 林伟池. All rights reserved.
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
    [AnimationManager instance].livingView = self.view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onKeyFrameAnimation:(id)sender {
    [[AnimationManager instance] addAnimationWithID:arc4random_uniform(3)];
}


@end
