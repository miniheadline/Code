//
//  PersonalPageViewController.m
//  MiniHeadline
//
//  Created by Booooby on 2019/4/20.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import "PersonalPageViewController.h"

@interface PersonalPageViewController ()

@end

@implementation PersonalPageViewController

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
    label.text = @"PersonalPage";
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
}

@end
