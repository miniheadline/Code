//
//  ViewController.m
//  MiniHeadline
//
//  Created by Booooby on 2019/4/20.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import "ViewController.h"
#import "FirstPageViewController.h"
#import "VideoPageViewController.h"
#import "PersonalPageViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    FirstPageViewController *firstPageVC = [[FirstPageViewController alloc] init];
    [self setTabBarItem:firstPageVC.tabBarItem title:@"首页" titleSize:10.0 titleFontName:@"HeiTi SC" selectedImage:@"mainpage_selected" selectedTitleColor:[UIColor redColor] normalImage:@"mainpage_unselected" normalTitleColor:[UIColor blackColor]];
    VideoPageViewController *videoPageVC = [[VideoPageViewController alloc] init];
    [self setTabBarItem:videoPageVC.tabBarItem title:@"视频" titleSize:10.0 titleFontName:@"HeiTi SC" selectedImage:@"video_selected" selectedTitleColor:[UIColor redColor] normalImage:@"video_unselected" normalTitleColor:[UIColor blackColor]];
    PersonalPageViewController *personalPageVC = [[PersonalPageViewController alloc] init];
    [self setTabBarItem:personalPageVC.tabBarItem title:@"我的" titleSize:10.0 titleFontName:@"HeiTi SC" selectedImage:@"personal_selected" selectedTitleColor:[UIColor redColor] normalImage:@"personal_unselected" normalTitleColor:[UIColor blackColor]];
    
    //    UINavigationController *firstPageNV = [[UINavigationController alloc] initWithRootViewController:firstPageVC];
    //    UINavigationController *videoPageNV = [[UINavigationController alloc] initWithRootViewController:videoPageVC];
    //    UINavigationController *personalPageNV = [[UINavigationController alloc] initWithRootViewController:personalPageVC];
    //
    //    self.viewControllers = @[firstPageVC, videoPageVC, personalPageVC];
    
    [self addChildViewController:firstPageVC];
    [self addChildViewController:videoPageVC];
    [self addChildViewController:personalPageVC];
}

- (void)setTabBarItem:(UITabBarItem *)tabbarItem title:(NSString *)title titleSize:(CGFloat)size titleFontName:(NSString *)fontName selectedImage:(NSString *)selectedImage selectedTitleColor:(UIColor *)selectColor normalImage:(NSString *)unselectedImage normalTitleColor:(UIColor *)unselectColor {
    
    // 设置图片
    tabbarItem = [tabbarItem initWithTitle:title
                                     image:[[UIImage imageNamed:unselectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                             selectedImage:[[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    // 未选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:unselectColor,
                        NSFontAttributeName:[UIFont fontWithName:fontName size:size]} forState:UIControlStateNormal];
    
    // 选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:selectColor,
                        NSFontAttributeName:[UIFont fontWithName:fontName size:size]} forState:UIControlStateSelected];
}


@end
