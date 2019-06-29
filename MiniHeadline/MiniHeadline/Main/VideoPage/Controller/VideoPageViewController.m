//
//  VideoPageViewController.m
//  MiniHeadline
//
//  Created by Booooby on 2019/4/20.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "VideoPageViewController.h"
#import "MyVideo.h"
#import "LoadingTableViewCell.h"
#import "VideoTableViewCell.h"
#import "SearchViewController.h"
#import "UIColor+Hex.h"
#import "VideoDetailViewController.h"
#import "MJRefresh.h"
#import "VideoListViewModel.h"
#import "SimpleVideoView.h"
#import "UserInfoModel.h"

static NSString *VideoTableViewCellIdentifier = @"VideoTableViewCellIdentifier";

@interface VideoPageViewController ()

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
@property (nonatomic, copy) NSArray *publishChoiceArray;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray<MyVideo*>* dataList;
@property(nonatomic, assign)LoadingStatus status;
@property(nonatomic, assign)NSInteger pageIndex;
@property(nonatomic, assign)BOOL isLoading;
@property(nonatomic, assign)NSInteger offset;
@property (nonatomic, assign) UITableViewCell *cell;
@property (nonatomic, strong) SimpleVideoView *playerView;
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, assign) int uid;
@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@end

@implementation VideoPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addSubViews];
    
}

- (void)addSubViews {
    self.view.backgroundColor = [UIColor whiteColor];
    // 获取屏幕尺寸（包括状态栏）
    CGRect screenBound = [UIScreen mainScreen].bounds;
    // 获取状态栏尺寸
    CGRect statusBound = [[UIApplication sharedApplication] statusBarFrame];
    
    self.indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
    [self.indicator setFrame:CGRectMake(screenBound.size.width/2-50, screenBound.size.height/2-50, 100, 100)];
    
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
    
    
    
    self.tableView = ({
        UITableView* tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.searchBackgroundView.bounds.size.height + self.tagScrollView.bounds.size.height + 1, screenBound.size.width, screenBound.size.height - self.searchBackgroundView.bounds.size.height - self.tagScrollView.bounds.size.height) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        tableView;
    });
    [self.view addSubview:self.tableView];
    self.whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenBound.size.width, screenBound.size.height)];
    [self.whiteView setBackgroundColor:[UIColor whiteColor]];
    [self.whiteView addSubview:self.indicator];
    [self.view addSubview:self.whiteView];
    
    
    /*NSArray* firstPage = [self loadData:0];
    self.dataList = [NSMutableArray arrayWithArray:firstPage];
    self.pageIndex = 0;*/
    self.dataList = [[NSMutableArray alloc] init];
    self.offset = 1;
    self.isFirst = YES;
    UserInfoModel *user = [UserInfoModel testUser];
    self.isLogin = user.isLogin;
    self.uid = user.uid;
    [self.indicator startAnimating];
    [self loadMoreData];
    
}

- (void)loadNewData {
    NSLog(@"loadNewData");
    self.isLoading = YES;
    
    VideoListViewModel *viewModel = [[VideoListViewModel alloc] init];
    [viewModel getFeedsListWithOffset:self.offset size:5 success:^(NSMutableArray * _Nonnull dataArray) {
        NSRange range = NSMakeRange(0, 5);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.dataList insertObjects:dataArray atIndexes:indexSet];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            self.offset = self.offset + 5;
            self.isLoading = NO;
            NSLog(@"reload tableview");
        });
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"请求失败 error:%@",error.description);
        [self.tableView.mj_header endRefreshing];
        self.isLoading = NO;
    }];
    /*for(int i=0; i<3; i++){
        //NSString *path = [[NSBundle mainBundle] pathForResource:@"video" ofType:@".mp4"];
        NSString *path;
        if(i==0) {
            path = @"http://149.28.26.98/video.mp4";
        }
        else if (i == 1) {
            path = @"http://149.28.26.98/ramen.mp4";
        }
        MyVideo *myVideo = [[MyVideo alloc] initWithVideo:[NSString stringWithFormat:@"title: %d", i] video:path authorName:[NSString stringWithFormat:@"aaaaaaaaaaaaa%d", i] icon:[UIImage imageNamed:[NSString stringWithFormat:@"icon_%d", i]] commentNum:i*10 isFollow:NO playNum:(i+1)*10000];
        [self.dataList addObject:myVideo];
    }*/
    /*dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        self.offset = self.offset + 20;
        self.isLoading = NO;
        NSLog(@"reload tableview");
    });*/
}

- (void)loadMoreData {
    NSLog(@"loadMoreData");
    self.isLoading = YES;
    VideoListViewModel *viewModel = [[VideoListViewModel alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [viewModel getFeedsListWithOffset:self.offset size:5 success:^(NSMutableArray * _Nonnull dataArray) {
            [self.dataList addObjectsFromArray:dataArray];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
                self.isLoading = NO;
                self.offset = self.offset + 5;
                NSLog(@"reload tableview");
                if(self.isFirst) {
                    [self.indicator stopAnimating];
                    [self.whiteView removeFromSuperview];
                }
            });
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"请求失败 error:%@",error.description);
            [self.tableView.mj_footer endRefreshing];
            self.isLoading = NO;
        }];
    });
    /*for(int i=0; i<3; i++){
        //NSString *path = [[NSBundle mainBundle] pathForResource:@"video" ofType:@".mp4"];
        NSString *path;
        if(i==0) {
            path = @"http://149.28.26.98/video.mp4";
        }
        else if (i == 1) {
            path = @"http://149.28.26.98/ramen.mp4";
        }
        MyVideo *myVideo = [[MyVideo alloc] initWithVideo:[NSString stringWithFormat:@"title: %d", i] video:path authorName:[NSString stringWithFormat:@"aaaaaaaaaaaaa%d", i] icon:[UIImage imageNamed:[NSString stringWithFormat:@"icon_%d", i]] commentNum:i*10 isFollow:NO playNum:(i+1)*10000];
        [self.dataList addObject:myVideo];
    }*/
    /*dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        self.isLoading = NO;
        self.offset = self.offset + 5;
        NSLog(@"reload tableview");
    });*/
}

- (NSArray*)loadData:(NSInteger)pageIndex{
    NSMutableArray* result = [NSMutableArray arrayWithCapacity:3];
    for(int i=0; i<3; i++){
        //NSString *path = [[NSBundle mainBundle] pathForResource:@"video" ofType:@".mp4"];
        NSString *path = @"http://149.28.26.98/video.mp4";
        MyVideo *myVideo = [[MyVideo alloc] initWithVideo:[NSString stringWithFormat:@"title: %d", i] video:path authorName:[NSString stringWithFormat:@"aaaaaaaaaaaaa%d", i] icon:[UIImage imageNamed:[NSString stringWithFormat:@"icon_%d", i]] commentNum:i*10 isFollow:NO playNum:(i+1)*100000];
        [result addObject:myVideo];
    }
    return result;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count; // 增加的1为加载更多
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSInteger cellType;
    cellType = self.dataList[indexPath.row].cellType;
    NSString* cellTypeString = [NSString stringWithFormat:@"cellType:%d", cellType];
    //UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellTypeString];
    VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellTypeString];
    if(cell == nil) {
        cell = [[VideoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellTypeString];
        [(VideoTableViewCell*)cell setCellData:self.dataList[indexPath.row]];
        cell.delegate = self;
        
    } else {
        [(VideoTableViewCell*)cell setCellData:self.dataList[indexPath.row]];
        cell.delegate = self;
    }
    
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSLog(@"didSelectRowAtIndexPath:%@", indexPath);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([tableView isEqual:self.tableView]) {
        // 跳转
        VideoDetailViewController *videoDetailViewController = [[VideoDetailViewController alloc] init];
        videoDetailViewController.myVideo = self.dataList[indexPath.row];
        //[videoDetailViewController setData];
        [self.navigationController pushViewController:videoDetailViewController animated:NO];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 270;
}

// 通知委托指定行将要被选中，返回响应行的索引
- (nullable NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"willSelectRowAtIndexPath:%@", indexPath);
    return indexPath;
}

/*- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //因为复用，同一个cell可能会走多次
    if ([_cell isEqual:cell]) {
        //区分是否是播放器所在cell,销毁时将指针置空
        [_playerView destroyPlayer];
        _cell = nil;
    }
}*/

- (void)cl_tableViewCellPlayVideoWithCell:(VideoTableViewCell *)cell{
    //记录被点击的Cell
    _cell = cell;
    //销毁播放器
    [_playerView destroyPlayer];
    SimpleVideoView *playerView = [[SimpleVideoView alloc] initWithFrame:cell.videoView.frame];
    //playerView.frame = cell.videoView.frame;
    _playerView = playerView;
    //[cell.videoView addSubview:_playerView];
    [cell.videoView insertSubview:_playerView belowSubview:cell.titleLabel];
    //视频地址
    _playerView.url = cell.videoModel.video;
    [_playerView loadVideo];
    //播放
    [_playerView playVideo];
    
}

/*- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"willSelectRowAtIndexPath:%@", indexPath);
    if (indexPath.row == self.dataList.count - 1 && self.isLoading == NO) {
        [self loadMoreData];
    }
    
}*/

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //我尝试去修改作者的，似乎也没有起作用，所有自己在改方法中进行销毁
    NSArray *cells = [self.tableView visibleCells];
    if (![cells containsObject:self.cell]) {
        
        if (self.playerView) {
            //销毁播放器
            [self.playerView destroyPlayer];
            self.playerView = nil;
        }
        
    }
}

// 搜索输入框点击触发事件
- (void)searchSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"searchSingleTap");
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:NO];
}


@end
