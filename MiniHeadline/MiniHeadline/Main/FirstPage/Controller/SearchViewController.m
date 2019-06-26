//
//  SearchViewController.m
//  MiniHeadline
//
//  Created by Booooby on 2019/4/24.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()<UISearchBarDelegate>

@property (nonatomic, strong) UIView *searchBackgroundView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UILabel *cancelLabel;
@property (nonatomic, strong) UILabel *recommendLabel;
@property (nonatomic, strong) UILabel *historyLabel;

@end

@implementation SearchViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addSubViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 隐藏navigationBar
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 获取第一响应，调出键盘
    if (!_searchBar.isFirstResponder) {
        [self.searchBar becomeFirstResponder];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // 放弃第一响应
    [self.searchBar resignFirstResponder];
    
    // 隐藏navigationBar
    self.navigationController.navigationBar.hidden = YES;
}


#pragma mark - Init

- (void)addSubViews {
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 获取屏幕尺寸（包括状态栏）
    CGRect screenBound = [UIScreen mainScreen].bounds;
    // 获取状态栏尺寸
    CGRect statusBound = [[UIApplication sharedApplication] statusBarFrame];
    
    // 用来放searchBar的View
    self.searchBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenBound.size.width, statusBound.size.height + 50)];
    self.searchBackgroundView.backgroundColor = [UIColor redColor]; // 背景颜色
    // 创建searchBar
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, statusBound.size.height, screenBound.size.width - 50, 50)];
    self.searchBar.placeholder = @"搜索内容"; // 默认提示文字
    // 去掉searchBar默认的灰色背景
    for (UIView *view in self.searchBar.subviews) {
        // iOS 7.0之前
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            view.alpha = 0.0f;  // 将背景设为透明
            break;
        }
        // iOS 7.0以及iOS 7.0以后
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            [view.subviews objectAtIndex:0].alpha = 0.0f;
            break;
        }
    }
    // 取消按钮
    self.cancelLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenBound.size.width - 50, statusBound.size.height, 40, 50)];
    self.cancelLabel.text = @"取消";
    self.cancelLabel.textColor = [UIColor whiteColor];
    self.cancelLabel.textAlignment = NSTextAlignmentCenter;
    // 添加点击手势
    self.cancelLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelSingleTap:)];
    [self.cancelLabel addGestureRecognizer:singleTap];
    
    [self.searchBackgroundView addSubview:self.searchBar];
    [self.searchBackgroundView addSubview:self.cancelLabel];
    [self.view addSubview:self.searchBackgroundView];
    
    // 推荐
    self.recommendLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.searchBackgroundView.frame.size.height, screenBound.size.width, 100)];
    self.recommendLabel.text = @"推荐";
    self.recommendLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.recommendLabel];
    
    // 历史记录
    self.historyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.searchBackgroundView.frame.size.height + self.recommendLabel.frame.size.height, screenBound.size.width, 100)];
    self.historyLabel.text = @"搜索历史";
    self.historyLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.historyLabel];
}


#pragma mark - TapGesture

- (void)cancelSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    [self.navigationController popViewControllerAnimated:NO];
    NSLog(@"cancelSingleTap");
}


#pragma mark - TouchEvent

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"touch");
    [self.searchBar resignFirstResponder];
}


#pragma mark - UISearchBarDelegate

// 将要开始编辑时的回调，返回为NO，则不能编辑
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return YES;
}

// 已经开始编辑时的回调
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
}

// 搜索按钮点击的回调
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"SearchButton");
}

// 取消按钮点击的回调
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

// 已经结束编辑的回调
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
}

// 编辑文字改变的回调
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    //    NSString *inputStr = searchText;
    //    [self.results removeAllObjects];
    //    for (ElderModel *model in self.dataArray) {
    //        if ([model.name.lowercaseString rangeOfString:inputStr.lowercaseString].location != NSNotFound) {
    //            [self.results addObject:model];
    //        }
    //    }
    //    [self.tableView reloadData];
}

@end
