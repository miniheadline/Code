//
//  VideoPageViewController.m
//  MiniHeadline
//
//  Created by Booooby on 2019/4/20.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import "VideoPageViewController.h"

@interface VideoPageViewController ()

@end

@implementation VideoPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addSubViews];
}

- (void)addSubViews {
    // 获取屏幕尺寸（包括状态栏）
    CGRect screenBound = [UIScreen mainScreen].bounds;
    // 获取状态栏尺寸
    CGRect statusBound = [[UIApplication sharedApplication] statusBarFrame];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenBound.size.width, 100)];
    label.text = @"VideoPage";
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
}

@end
