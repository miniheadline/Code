//
//  VideoPageViewController.m
//  MiniHeadline
//
//  Created by Booooby on 2019/4/20.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import "VideoPageViewController.h"
#import "../Model/MyVideo.h"
#import "../ViewModel/LoadingTableViewCell.h"
#import "../ViewModel/VideoTableViewCell.h"
#import "../../FirstPage/Controller/SearchViewController.h"
#import "../../../Common/UIColor+Hex.h"
#import "VideoDetailViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface VideoPageViewController ()
@property (nonatomic, strong) UIView *searchBackgroundView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIImageView *publishImageView;
@property (nonatomic, strong) UILabel *publishLabel;
//@property (nonatomic, strong) UITableView *publishTableView;
@property (nonatomic, strong) UIScrollView *tagScrollView;
@property (nonatomic, strong) UIView *horizontalLine;
@property (nonatomic, copy) NSArray *publishChoiceArray;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray<MyVideo*>* dataList;
@property(nonatomic, assign)LoadingStatus status;
@property(nonatomic, assign)NSInteger pageIndex;
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
    
    
    
    self.tableView = ({
        UITableView* tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 90, screenBound.size.width, screenBound.size.height-180) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = [UIView new];
        tableView;
    });
    [self.view addSubview:self.tableView];
    
    NSArray* firstPage = [self loadData:0];
    self.dataList = [NSMutableArray arrayWithArray:firstPage];
    self.pageIndex = 0;
}

- (NSArray*)loadData:(NSInteger)pageIndex{
    NSMutableArray* result = [NSMutableArray arrayWithCapacity:3];
    for(int i=0; i<3; i++){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"video" ofType:@".mp4"];
        MyVideo *myVideo = [[MyVideo alloc] initWithVideo:[NSString stringWithFormat:@"title: %d", i] video:path authorName:[NSString stringWithFormat:@"aaaaaaaaaaaaa%d", i] icon:[UIImage imageNamed:[NSString stringWithFormat:@"icon_%d", i]] commentNum:i*10 isFollow:NO];
        [result addObject:myVideo];
    }
    return result;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count + 1; // 增加的1为加载更多
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSInteger cellType;
    if(indexPath.row == self.dataList.count) {
        cellType = 0;
    }
    else {
        cellType = self.dataList[indexPath.row].cellType;
    }
    NSString* cellTypeString = [NSString stringWithFormat:@"cellType:%d", cellType];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellTypeString];
    
    if(cell == nil) {
        if(cellType == 0){
            cell = [[LoadingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellTypeString];
            ((LoadingTableViewCell*) cell).status = self.status;
            cell.selectionStyle = ((self.status==LoadingStatusDefault)?UITableViewCellSelectionStyleDefault:UITableViewCellSelectionStyleNone);
        }
        else if(cellType == 1) {
            cell = [[VideoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellTypeString];
            [(VideoTableViewCell*)cell setCellData:self.dataList[indexPath.row]];
            //cell.cellD
        }
        else if(cellType == 2) {
            
        }
    } else {
        if(cellType == 0){
            ((LoadingTableViewCell*) cell).status = self.status;
            cell.selectionStyle = ((self.status==LoadingStatusDefault)?UITableViewCellSelectionStyleDefault:UITableViewCellSelectionStyleNone);
        }
        else if(cellType == 1) {
            [(VideoTableViewCell*)cell setCellData:self.dataList[indexPath.row]];
        }
        else if(cellType == 2) {
            
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if(indexPath.row == self.dataList.count) {
        self.status = LoadingStatusLoding;
        [tableView reloadData]; // 从默认态切换到加载状态，需要更新
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.pageIndex++;
            if (self.pageIndex < 5) {
                self.status = LoadingStatusDefault;
            } else {
                self.status = LoadingStatusNoMore;
            }
            
            NSArray *newPage = [self loadData:self.pageIndex];
            [self.dataList addObjectsFromArray:newPage];
            
            [tableView reloadData];  // 从默认态切换到加载状态或者加载技术，需要更新
        });
    }
    else {
        NSLog(@"didSelectRowAtIndexPath:%@", indexPath);
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        if ([tableView isEqual:self.tableView]) {
            // 跳转
            VideoDetailViewController *videoDetailViewController = [[VideoDetailViewController alloc] init];
            videoDetailViewController.myVideo = self.dataList[indexPath.row];
            [self.navigationController pushViewController:videoDetailViewController animated:NO];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == self.dataList.count) {
        return 30;
    }
    return 300;
}

// 通知委托指定行将要被选中，返回响应行的索引
- (nullable NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"willSelectRowAtIndexPath:%@", indexPath);
    return indexPath;
}




@end
