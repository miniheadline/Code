//
//  FirstPageViewController.m
//  MiniHeadline
//
//  Created by Booooby on 2019/4/20.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import "FirstPageViewController.h"
#import "SearchViewController.h"
#import "NewsDetailViewController.h"
#import "SingleImageTableViewCell.h"
#import "NewsModel.h"
#import "UIColor+Hex.h"

@interface FirstPageViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *searchBackgroundView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIImageView *publishImageView;
@property (nonatomic, strong) UILabel *publishLabel;
@property (nonatomic, strong) UITableView *publishTableView;
@property (nonatomic, strong) UIScrollView *tagScrollView;
@property (nonatomic, strong) UIView *horizontalLine;
@property (nonatomic, strong) UITableView *newsTableView;

@property (nonatomic, copy) NSMutableArray *tableDataArray;
@property (nonatomic, copy) NSArray *publishChoiceArray;

@property (nonatomic) BOOL clickOnce;

@end

@implementation FirstPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addSubViews];
    
    self.clickOnce = NO;
}

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
    // 点击输入框时跳转到另一个页面
    for (UIView *view in self.searchBar.subviews) {
        UITapGestureRecognizer *search = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchSingleTap:)];
        // iOS 7.0之前
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
            view.userInteractionEnabled = YES;
            [view addGestureRecognizer:search];
            break;
        }
        // iOS 7.0以及iOS 7.0以后
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            [view.subviews objectAtIndex:1].userInteractionEnabled = YES;
            [[view.subviews objectAtIndex:1] addGestureRecognizer:search];
            break;
        }
    }
    [self.searchBackgroundView addSubview:self.searchBar];
    [self.view addSubview:self.searchBackgroundView];
    
    // 发布按钮
    UIImage *image = [UIImage imageNamed:@"camera.png"];
    self.publishImageView = [[UIImageView alloc] initWithImage:image];
    self.publishImageView.frame = CGRectMake(screenBound.size.width - 45, statusBound.size.height, 30, 30);
    [self.searchBackgroundView addSubview:self.publishImageView];
    // 图片添加点击事件
    self.publishImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *publish = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(publishSingleTap:)];
    publish.cancelsTouchesInView = NO;
    [self.publishImageView addGestureRecognizer:publish];
    // 发布选项下拉菜单
    self.publishChoiceArray = @[@"发图文", @"拍小视频", @"发视频", @"提问", @"开直播", @"爆料"];
    self.publishTableView = [[UITableView alloc] initWithFrame:CGRectMake(screenBound.size.width - 100, self.searchBackgroundView.frame.size.height, 100,    ) style:UITableViewStylePlain];
    self.publishTableView.delegate = self;
    self.publishTableView.dataSource = self;
    self.publishTableView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.publishTableView];
    
    self.publishLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenBound.size.width - 45, statusBound.size.height + 32, 30, 10)];
    self.publishLabel.text = @"发布";
    self.publishLabel.font = [UIFont systemFontOfSize:12];
    self.publishLabel.textColor = [UIColor whiteColor];
    self.publishLabel.textAlignment = NSTextAlignmentCenter;
    [self.searchBackgroundView addSubview:self.publishLabel];
    
    // 滑动标签栏
    self.tagScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.searchBackgroundView.bounds.size.height, screenBound.size.width, 40)];
    self.tagScrollView.backgroundColor = [UIColor whiteColor];
    self.tagScrollView.showsVerticalScrollIndicator = NO; // 不显示纵向拉动条
    self.tagScrollView.showsHorizontalScrollIndicator = NO; // 不显示横向拉动条
    self.tagScrollView.bounces = YES; // 设置反弹效果
    self.tagScrollView.scrollEnabled = YES; // 设置能否滚动
    // 在scrollView中添加label
    NSArray *category = [NSArray arrayWithObjects:@"关注", @"推荐", @"热点", @"娱乐", @"科技", @"数码", @"电影", @"游戏", nil];
    for (int i = 0; i < category.count; i++) {
        UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(60 * i, 0, 60, 40)];
        [tempLabel setFont:[UIFont systemFontOfSize:18]];
        [tempLabel setTextAlignment:NSTextAlignmentCenter];
        [tempLabel setTextColor:[UIColor blackColor]];
        [tempLabel setText:[category objectAtIndex:i]];
        [self.tagScrollView addSubview:tempLabel];
    }
    [self.tagScrollView setContentSize:CGSizeMake(60 * category.count, 40)];
    [self.view addSubview:self.tagScrollView];
    
    // 分割线
    self.horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.searchBackgroundView.bounds.size.height + self.tagScrollView.bounds.size.height, screenBound.size.width, 0.5)];
    self.horizontalLine.backgroundColor = [UIColor colorWithHexString:@"#D9D9D9"];
    [self.view addSubview:self.horizontalLine];
    
    // newsTableView显示主体部分
    self.newsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchBackgroundView.bounds.size.height + self.tagScrollView.bounds.size.height + 1, screenBound.size.width, screenBound.size.height - self.searchBackgroundView.bounds.size.height - self.tagScrollView.bounds.size.height) style:UITableViewStylePlain];
    self.newsTableView.dataSource = self;
    self.newsTableView.delegate = self;
    // tableView分割线
    self.newsTableView.separatorInset = UIEdgeInsetsMake(1, 0, 1, 0);
    self.newsTableView.separatorColor = [UIColor lightGrayColor];
    self.newsTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.newsTableView.rowHeight = UITableViewAutomaticDimension;
    self.newsTableView.estimatedRowHeight = 180;
    [self.view addSubview:self.newsTableView];
}

// 发布按钮点击触发事件
- (void)publishSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"publishSingleTap");
    if (self.clickOnce == NO) {
        [self.view bringSubviewToFront:self.publishTableView];
        self.clickOnce = YES;
    } else {
        [self.view sendSubviewToBack:self.publishTableView];
        self.clickOnce = NO;
    }
}

// 搜索输入框点击触发事件
- (void)searchSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"searchSingleTap");
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:NO];
}


- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES; // 隐藏navigationBar
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO; // 取消隐藏navigationBar
    [super viewWillDisappear:animated];
}

// 懒加载
- (NSMutableArray *)tableDataArray {
    if (_tableDataArray == nil || _tableDataArray == NULL) {
        _tableDataArray = [NSMutableArray array];
        for (int i = 0; i < 20; i++) {
            NewsModel *tempModel = [NewsModel myNewsModel];
            [_tableDataArray addObject:tempModel];
        }
    }
    return _tableDataArray;
}

// 点击其他区域时隐藏下拉菜单（被scrollView searchBar tableView等拦截，需要加拓展）
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"point");
    CGPoint point = [[touches anyObject] locationInView:self.view];
//    point = [self.publishTableView.layer convertPoint:point toLayer:self.publishTableView.layer];
//    if (![self.publishTableView.layer containsPoint:point]) {
//        NSLog(@"click on other position");
//    }
}

#pragma mark - UITableViewDataSource

// 返回表视图中包含的单元格个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.newsTableView])
        return self.tableDataArray.count;
    else
        return self.publishChoiceArray.count;
}

// 创建每一个单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.newsTableView]) {
        SingleImageTableViewCell *cell = [SingleImageTableViewCell cellWithTableView:tableView];
        NewsModel *cellData = self.tableDataArray[indexPath.row];
        cell.cellData = cellData;
        return cell;
    }
    else {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.textLabel.text = self.publishChoiceArray[indexPath.row];
        return cell;
    }
}


#pragma mark - UITableViewDelegate

// 通知委托指定行将要被选中，返回响应行的索引
- (nullable NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"willSelectRowAtIndexPath:%@", indexPath);
    return indexPath;
}

// 通知委托指定行被选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"didSelectRowAtIndexPath:%@", indexPath);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([tableView isEqual:self.newsTableView]) {
        // 跳转
        NewsDetailViewController *newsDetailVC = [[NewsDetailViewController alloc] init];
        [self.navigationController pushViewController:newsDetailVC animated:NO];
    }
}

@end
