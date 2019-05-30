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
#import "NoImageTableViewCell.h"
#import "SingleImageTableViewCell.h"
#import "MultiImageTableViewCell.h"
#import "NewsModel.h"
#import "UIColor+Hex.h"
#import "FirstPageViewModel.h"
#import "MJRefresh.h"

@interface FirstPageViewController ()<UITableViewDelegate,
                                      UITableViewDataSource,
                                      UIScrollViewDelegate,
                                      NSURLSessionDelegate>

@property (nonatomic, strong) UIView *searchBackgroundView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIImageView *publishImageView;
@property (nonatomic, strong) UILabel *publishLabel;
@property (nonatomic, strong) UITableView *publishTableView;
@property (nonatomic, strong) UIView *publishView;
@property (nonatomic, strong) UIView *tagView;
@property (nonatomic, strong) UIScrollView *tagScrollView;
@property (nonatomic, strong) UIImageView *tagImageView;
@property (nonatomic, strong) UIView *verticalLine;
@property (nonatomic, strong) UIView *horizontalLine;
@property (nonatomic, strong) UITableView *newsTableView;

@property (nonatomic, copy) NSMutableArray *tableDataArray;
@property (nonatomic, copy) NSArray *publishChoiceArray;

@property (nonatomic) BOOL clickOnce;
@property (nonatomic) BOOL isFirstLoading;
@property (nonatomic) BOOL isLoading;

@property (nonatomic) int offset;

@end

@implementation FirstPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initVar];
    
    [self addSubViews];
    
    [self loadMoreData];
}

- (void)initVar {
    self.offset = 0;
    self.isLoading = NO;
    self.isFirstLoading = YES;
}

- (void)setupUpRefresh {
    self.newsTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)setupDownRefresh {
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    self.newsTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
}

- (void)loadNewData {
    NSLog(@"loadNewData");
    self.isLoading = YES;
    FirstPageViewModel *viewModel = [[FirstPageViewModel alloc] init];
    [viewModel getFeedsListWithOffset:self.offset success:^(NSMutableArray * _Nonnull dataArray) {
        NSRange range = NSMakeRange(0, 20);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.tableDataArray insertObjects:dataArray atIndexes:indexSet];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.newsTableView reloadData];
            [self.newsTableView.mj_header endRefreshing];
            self.offset = self.offset + 20;
            self.isLoading = NO;
            NSLog(@"reload tableview");
        });
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"请求失败 error:%@",error.description);
        [self.newsTableView.mj_header endRefreshing];
        self.isLoading = NO;
    }];
}

- (void)loadMoreData {
    NSLog(@"loadMoreData");
    self.isLoading = YES;
    FirstPageViewModel *viewModel = [[FirstPageViewModel alloc] init];
    [viewModel getFeedsListWithOffset:self.offset success:^(NSMutableArray * _Nonnull dataArray) {
        [self.tableDataArray addObjectsFromArray:dataArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.newsTableView reloadData];
            [self.newsTableView.mj_footer endRefreshing];
            self.isLoading = NO;
            self.offset = self.offset + 20;
            if (self.isFirstLoading == YES) {
                // 集成下拉刷新控件
                [self setupDownRefresh];
                // 集成上拉刷新控件
                [self setupUpRefresh];
            }
            NSLog(@"reload tableview");
        });
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"请求失败 error:%@",error.description);
        [self.newsTableView.mj_footer endRefreshing];
        self.isLoading = NO;
    }];
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
    [self.publishImageView addGestureRecognizer:publish];
    // 发布选项下拉菜单
    self.publishView = [[UIView alloc] initWithFrame:CGRectMake(0, statusBound.size.height, screenBound.size.width, screenBound.size.height - statusBound.size.height)];
    self.publishView.backgroundColor = [UIColor whiteColor];
    self.publishView.alpha = 0.1;
    self.publishView.userInteractionEnabled = YES;
    UITapGestureRecognizer *other = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(otherSingleTap:)];
    [self.publishView addGestureRecognizer:other];
    [self.view addSubview:self.publishView];
    [self.view sendSubviewToBack:self.publishView];
    
    self.publishChoiceArray = @[@"发图文", @"拍小视频", @"发视频", @"提问", @"开直播", @"爆料"];
    self.publishTableView = [[UITableView alloc] initWithFrame:CGRectMake(screenBound.size.width - 100, self.searchBackgroundView.frame.size.height, 100, 260) style:UITableViewStylePlain];
    self.publishTableView.backgroundColor = [UIColor whiteColor];
    self.publishTableView.delegate = self;
    self.publishTableView.dataSource = self;
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
    self.tagScrollView.delegate = self;
    // 在scrollView中添加label
    NSArray *category = [NSArray arrayWithObjects:@"关注", @"推荐", @"热点", @"娱乐", @"科技", @"数码", @"电影", @"游戏", nil];
    for (int i = 0; i < category.count; i++) {
        UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(5 + 60 * i, 0, 60, 40)];
        [tempLabel setFont:[UIFont systemFontOfSize:20]];
        [tempLabel setTextAlignment:NSTextAlignmentCenter];
        [tempLabel setTextColor:[UIColor blackColor]];
        [tempLabel setText:[category objectAtIndex:i]];
        [self.tagScrollView addSubview:tempLabel];
    }
    [self.tagScrollView setContentSize:CGSizeMake(5 + 45 + 60 * category.count, 40)];
    [self.view addSubview:self.tagScrollView];
    
    self.tagView = [[UIView alloc] initWithFrame:CGRectMake(screenBound.size.width - 40, self.searchBackgroundView.bounds.size.height, 40, 40)];
    self.tagView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tagView];
    
    UIImage *tagImage = [UIImage imageNamed:@"edit_label.png"];
    self.tagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    self.tagImageView.image = tagImage;
    [self.tagView addSubview:self.tagImageView];
    
    self.verticalLine = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 1, 20)];
    self.verticalLine.backgroundColor = [UIColor colorWithHexString:@"#D9D9D9"];
    [self.tagView addSubview:self.verticalLine];
    
    // 分割线
    self.horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.searchBackgroundView.bounds.size.height + self.tagScrollView.bounds.size.height, screenBound.size.width, 1)];
    self.horizontalLine.backgroundColor = [UIColor colorWithHexString:@"#D9D9D9"];
    [self.view addSubview:self.horizontalLine];
    
    // newsTableView显示主体部分
    self.newsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchBackgroundView.bounds.size.height + self.tagScrollView.bounds.size.height + 1, screenBound.size.width, screenBound.size.height - self.searchBackgroundView.bounds.size.height - self.tagScrollView.bounds.size.height) style:UITableViewStylePlain];
    self.newsTableView.dataSource = self;
    self.newsTableView.delegate = self;
    // 去除多余的分割线
    UIView *footer = [[UIView alloc] init];
    footer.backgroundColor = [UIColor clearColor];
    self.newsTableView.tableFooterView = footer;
    // tableView分割线
    self.newsTableView.separatorInset = UIEdgeInsetsMake(1, 0, 1, 0);
    self.newsTableView.separatorColor = [UIColor lightGrayColor];
    self.newsTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.newsTableView.rowHeight = UITableViewAutomaticDimension;
    self.newsTableView.estimatedRowHeight = 180;
    [self.view addSubview:self.newsTableView];
}

// 懒加载
- (NSMutableArray *)tableDataArray {
    if (_tableDataArray == nil || _tableDataArray == NULL) {
        _tableDataArray = [NSMutableArray array];
    }
    return _tableDataArray;
}


#pragma mark - SingleTap

// 点击除下拉菜单之外的区域触发事件
- (void)otherSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"otherSingleTap");
    [self.view sendSubviewToBack:self.publishView];
    [self.view sendSubviewToBack:self.publishTableView];
}

// 发布按钮点击触发事件
- (void)publishSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"publishSingleTap");
    [self.view bringSubviewToFront:self.publishView];
    [self.view bringSubviewToFront:self.publishTableView];
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
        NewsModel *cellData = self.tableDataArray[indexPath.row];
        if (cellData.type == 0) {
            NSLog(@"%d", cellData.type);
            NoImageTableViewCell *cell = [NoImageTableViewCell cellWithTableView:tableView];
            cell.cellData = cellData;
            return cell;
        }
        else if (cellData.type == 1) {
            SingleImageTableViewCell *cell = [SingleImageTableViewCell cellWithTableView:tableView];
            cell.cellData = cellData;
            return cell;
        }
        else if (cellData.type == 2) {
            MultiImageTableViewCell *cell = [MultiImageTableViewCell cellWithTableView:tableView];
            cell.cellData = cellData;
            return cell;
        }
        else {
            NSLog(@"error-cellForRowAtIndexPath:%lu", indexPath.row);
            UITableViewCell *cell;
            return cell;
        }
    }
    else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        cell.backgroundColor = [UIColor darkGrayColor];
        cell.textLabel.text = self.publishChoiceArray[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:12.0];
        cell.textLabel.textColor = [UIColor whiteColor];
        return cell;
    }
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"willSelectRowAtIndexPath:%@", indexPath);
    if (indexPath.row == self.tableDataArray.count - 5 && self.isLoading == NO) {
        [self loadMoreData];
    }
}

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
        NewsModel *temp = self.tableDataArray[indexPath.row];
        newsDetailVC.groupID = temp.groupID;
        [self.navigationController pushViewController:newsDetailVC animated:NO];
    }
}


#pragma mark - UIScrollViewDelegate

// 当开始滚动视图时，执行该方法，一次有效滑动（开始滑动，滑动一小段距离，只要手指不松开，只算一次滑动），只执行一次
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.tagScrollView]) {
        NSLog(@"scrollViewWillBeginDragging");
        self.tagView.alpha = 0.9; // 设置tagView为透明
    }
}

// 滑动scrollView，并且手指离开时执行，一次有效滑动，只执行一次，当pagingEnabled=YES时不会调用该方法
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView {
    NSLog(@"scrollViewWillEndDragging");
}

// 滑动视图，当手指离开屏幕那一霎那，调用该方法，一次有效滑动，只执行一次，decelerate指当我们手指离开那一瞬后，视图是否还将继续向前滚动一段距离
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([scrollView isEqual:self.tagScrollView]) {
        NSLog(@"scrollViewDidEndDragging");
        self.tagView.alpha = 1;
    }
}

@end
