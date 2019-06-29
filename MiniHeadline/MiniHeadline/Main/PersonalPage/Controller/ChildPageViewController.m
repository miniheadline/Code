//
//  ChildPageViewController.m
//  MiniHeadline
//
//  Created by 蔡倓 on 2019/5/1.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import "ChildPageViewController.h"
#import "InfoTableViewCell.h"
#import "InfoTableViewCellWithPicture.h"
#import "NSComment.h"
#import "ChildPageNetworkModel.h"
#import "NoImageTableViewCell.h"
#import "SingleImageTableViewCell.h"
#import "MultiImageTableViewCell.h"
#import "RecommendationVideoTableViewCell.h"
#import "NewsDetailViewController.h"
#import "UserInfoModel.h"
#import "UIColor+Hex.h"
#import "VideoDetailViewController.h"
#import "SimpleVideoView.h"

@interface ChildPageViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain)IBOutlet UIButton *bt1;
@property (nonatomic, retain)IBOutlet UIButton *bt2;
@property (nonatomic, retain)IBOutlet UIButton *bt3;
@property (nonatomic, retain)IBOutlet UIButton *bt4;

@property (nonatomic, retain)IBOutlet UIButton *editor;
@property (nonatomic, retain)IBOutlet UIButton *search;
@property (nonatomic, retain)IBOutlet UIImageView *backImageView;

@property (nonatomic, strong) UIView *seperateLine;

@property (nonatomic, strong) UITableView *tableView;

@property int select;
@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, retain) NSMutableArray *itemsOfbt1;
@property (nonatomic, retain) NSMutableArray *itemsOfbt2;
@property (nonatomic, retain) NSMutableArray *itemsOfbt3;
@property (nonatomic, retain) NSMutableArray *itemsOfbt4;

@property (nonatomic) BOOL isLoading;

@property (nonatomic) int offset;
@property(nonatomic, strong) UserInfoModel* user;


@property (nonatomic, assign) UITableViewCell *cell;
@property (nonatomic, strong) SimpleVideoView *playerView;

@end


@implementation ChildPageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [UserInfoModel testUser];
    self.items = [[NSMutableArray alloc]init];
    self.itemsOfbt1 = [[NSMutableArray alloc]init];
    self.itemsOfbt2 = [[NSMutableArray alloc]init];
    self.itemsOfbt3 = [[NSMutableArray alloc]init];
    self.itemsOfbt4 = [[NSMutableArray alloc]init];
    
    CGRect mainscreenBound =  [UIScreen mainScreen].bounds;
    CGRect statusBarBound = [[UIApplication sharedApplication] statusBarFrame];
    CGRect screenBound = CGRectMake(0, 0, mainscreenBound.size.width, mainscreenBound.size.height - statusBarBound.size.height - 50);
    
    self.seperateLine = [[UIView alloc] initWithFrame:CGRectMake(0, 110 + self.bt1.frame.size.height - 0.5, screenBound.size.width, 0.5)];
    self.seperateLine.backgroundColor = [UIColor colorWithHexString:@"#D9D9D9"];
    [self.view addSubview:self.seperateLine];
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 110 + self.bt1.frame.size.height, screenBound.size.width, screenBound.size.height - self.bt1.frame.size.height - 60) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        UIView *footer = [[UIView alloc] init];
        footer.backgroundColor = [UIColor clearColor];
        tableView.tableFooterView = footer;
        // tableView分割线
        tableView.separatorInset = UIEdgeInsetsMake(1, 0, 1, 0);
        tableView.separatorColor = [UIColor lightGrayColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 180;
        tableView;
    });
    
    //self.items = self.itemsOfbt1;
    [self tableLoad];
    [self.view addSubview: self.tableView];
    
    if(self.select == 4){
        
        [self.bt4 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.bt1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.bt2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.bt3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    else if(self.select == 3){
        
        [self.bt3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.bt1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.bt2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.bt4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    else if(self.select == 2){
        
        [self.bt2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.bt1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.bt4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.bt3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    else if(self.select == 1){
        
        [self.bt1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.bt4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.bt2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.bt3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    [self.bt1 addTarget:self action:@selector(MarkButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bt2 addTarget:self action:@selector(CommentButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bt3 addTarget:self action:@selector(LikeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bt4 addTarget:self action:@selector(HistoryButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    //[self.editor addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    
    self.backImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *back = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backSingleTap:)];
    [self.backImageView addGestureRecognizer:back];
    
    [self viewWillAppear:FALSE];
}


- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES; // 隐藏navigationBar
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO; // 取消隐藏navigationBar
    [super viewWillDisappear:animated];
}

- (void)backSingleTap:(UITapGestureRecognizer *)gestureRecognizer {
    NSLog(@"backSingleTap");
    [self.navigationController popViewControllerAnimated:NO];
}


- (void)MarkButtonClick {
    
    NSLog(@"click markbutton");
    
    self.items = self.itemsOfbt1;
    self.select = 1;
    
    [self.tableView  reloadData];
    [self.bt1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.bt2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.bt3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.bt4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (void)CommentButtonClick {
    
    NSLog(@"click comment button");
    
    self.items = self.itemsOfbt2;
    self.select = 2;
    
    [self.tableView  reloadData];
    [self.bt1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.bt2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.bt3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.bt4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (void)LikeButtonClick {
    
    NSLog(@"click like button");
    
    self.items = self.itemsOfbt3;
    self.select = 3;
    
    [self.tableView  reloadData];
    [self.bt1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.bt2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.bt3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.bt4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}



- (void)HistoryButtonClick {
    
    NSLog(@"click history button");
    
    self.items = self.itemsOfbt4;
    self.select = 4;
    
    
    [self.tableView  reloadData];
    [self.bt1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.bt2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.bt3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.bt4 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
}

- (void)loadVideo:(NSInteger)type{
    NSString *urlString = [NSString stringWithFormat:@"http://149.28.26.98:8082/miniheadline/getVideoList?uid=%ld&type=%ld", self.user.uid,(long)type];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error == nil) {
            NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSLog(@"%@",dict);
            NSLog(@"%@",str);
            NSMutableArray *dataArr = [dict objectForKey:@"videoList"];
            for(int i = 0; i < dataArr.count; i ++){// 到icon都是可用的，后面的信息没有，likeNum没用上
                
                NSString *title = [dataArr[i] objectForKey:@"title"];
                NSString *url = [dataArr[i] objectForKey:@"url"];
                NSString *detail = [dataArr[i] objectForKey:@"introduction"];
                NSString *userPicURL = [dataArr[i] objectForKey:@"user_pic"];
                NSString *userName = [dataArr[i] objectForKey:@"username"];
                BOOL isFollow = [[dataArr[i] objectForKey:@"statusWithUser"] boolValue];
                int userID = [[dataArr[i] objectForKey:@"from_uid"] integerValue];
                NSString *index = [NSString stringWithFormat:@"icon_%d", userID];
                int vid = [[dataArr[i] objectForKey:@"vid"] integerValue];
                int likeNum = [[dataArr[i] objectForKey:@"likeNum"] integerValue];
                UIImage *pic = [UIImage imageNamed:@"icon_default.jpg"];
                MyVideo *video = [[MyVideo alloc] initWithVideo:title video:url authorName:userName icon:pic commentNum:0 isFollow:isFollow playNum:0];
                video.vid = vid;
                video.detail = detail;
                video.likeNum = likeNum;
                
                switch (type) {
                        //浏览
                    case 0:
                        [self.itemsOfbt4 addObject:video];
                        if(self.select == 4){
                            dispatch_group_t group = dispatch_group_create();
                            dispatch_group_async(group, dispatch_get_main_queue(), ^{
                                self.items = self.itemsOfbt4;
                                [self.tableView  reloadData];
                            });
                        }
                        break;
                        //点赞
                    case 1:
                        [self.itemsOfbt2 addObject:video];
                        if(self.select == 2){
                            dispatch_group_t group = dispatch_group_create();
                            dispatch_group_async(group, dispatch_get_main_queue(), ^{
                                self.items = self.itemsOfbt2;
                                [self.tableView  reloadData];
                            });
                        }
                        break;
                        //收藏
                    case 2:
                        [self.itemsOfbt1 addObject:video];
                        if(self.select == 1){
                            dispatch_group_t group = dispatch_group_create();
                            dispatch_group_async(group, dispatch_get_main_queue(), ^{
                                self.items = self.itemsOfbt1;
                                [self.tableView  reloadData];
                            });
                        }
                        break;
                }
            
            }
        }
    }];
    
    [dataTask resume];

}

- (void)loadNews:(NSInteger)type{
    NSString *urlString = [NSString stringWithFormat:@"http://149.28.26.98:8082/miniheadline/getNewsList?uid=%ld&type=%ld", self.user.uid,(long)type];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error == nil) {
            NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSLog(@"%@",dict);
            NSLog(@"%@",str);
            NSMutableArray *dataArr = [dict objectForKey:@"newsList"];
            
            ChildPageNetworkModel *viewModel = [[ChildPageNetworkModel alloc] init];
            for(int i = 0; i < dataArr.count; i ++){
                NSLog(@"%d",[[dataArr[i] objectForKey:@"offset"]intValue]);
                [viewModel getFeedsListWithOffset:[[dataArr[i] objectForKey:@"offset"]intValue] count:1 success:^(NSMutableArray * _Nonnull dataArray) {
                    switch (type) {
                            //浏览
                        case 0:
                            [self.itemsOfbt4 addObjectsFromArray:dataArray];
                            if(self.select == 4){
                                dispatch_group_t group = dispatch_group_create();
                                dispatch_group_async(group, dispatch_get_main_queue(), ^{
                                    self.items = self.itemsOfbt4;
                                    [self.tableView  reloadData];
                                });
                            }
                            break;
                            //点赞
                        case 1:
                            [self.itemsOfbt2 addObjectsFromArray:dataArray];
                            if(self.select == 2){
                                dispatch_group_t group = dispatch_group_create();
                                dispatch_group_async(group, dispatch_get_main_queue(), ^{
                                    self.items = self.itemsOfbt2;
                                    [self.tableView  reloadData];
                                });
                            }
                            break;
                            //收藏
                        case 2:
                            [self.itemsOfbt1 addObjectsFromArray:dataArray];

                            if(self.select == 1){
                                dispatch_group_t group = dispatch_group_create();
                                dispatch_group_async(group, dispatch_get_main_queue(), ^{
                                    self.items = self.itemsOfbt1;
                                    [self.tableView  reloadData];
                                });
                            }
                            break;
                            
                    }
     
                } failure:^(NSError * _Nonnull error) {
                    NSLog(@"请求失败 error:%@",error.description);

                }];
            }
        }
    }];
    
    [dataTask resume];

}

- (void)tableLoad {
    NSLog(@"loadNewData");
    
    // 线程问题
    [self loadNews:2];
    [self loadNews:0];
    [self loadNews:1];

    [self loadVideo:0];
    [self loadVideo:1];
    [self loadVideo:2];

    /*
    self.isLoading = YES;
    FirstPageViewModel *viewModel = [[FirstPageViewModel alloc] init];
    [viewModel getFeedsListWithOffset:self.offset count:20 success:^(NSMutableArray * _Nonnull dataArray) {
        // 返回的数据插入在前面
        NSRange range = NSMakeRange(0, 20);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        NSLog(@"%@",self.items);
        
        [self.items insertObjects:dataArray atIndexes:indexSet];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            //[self.tableView.mj_header endRefreshing];
            //self.offset = self.offset + 20;
            self.isLoading = NO;
           // NSLog(@"reload tableview");
        });
        NSLog(@"%@",dataArray);
        NSLog(@"%@",self.items);
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"请求失败 error:%@",error.description);
        //[self.newsTableView.mj_header endRefreshing];
        self.isLoading = NO;
    }];
    
    // 加载视频
    NSMutableArray* result = [NSMutableArray arrayWithCapacity:3];
    for(int i=0; i<3; i++){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"video" ofType:@".mp4"];
        MyVideo *myVideo = [[MyVideo alloc] initWithVideo:[NSString stringWithFormat:@"title: %d", i] video:path authorName:[NSString stringWithFormat:@"aaaaaaaaaaaaa%d", i] icon:[UIImage imageNamed:[NSString stringWithFormat:@"icon_%d", i]] commentNum:i*10 isFollow:NO playNum:(i+1)*100000];
        [result addObject:myVideo];
    }
    [self.items addObjectsFromArray:result];
    */
    
}


-(void)SelectPage:(int) select {
    
    switch (select) {
        case 1:
            NSLog(@"1");
            self.select = 1;
            [self.bt1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [self.bt2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.bt3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.bt4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            break;
            
        case 2:
            self.select = 2;
            NSLog(@"2");
            [self.bt2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [self.bt1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.bt3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.bt4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            break;
            
        case 3:
            self.select = 3;
            NSLog(@"3");
            [self.bt3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [self.bt1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.bt2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.bt4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            break;
            
        case 4:
            self.select = 4;
            NSLog(@"4");
            break;
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark ------------ UITableViewDataSource ------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([self.items[indexPath.row] isKindOfClass:[NewsModel class]]){
        NewsModel* cellData = self.items[indexPath.row];
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
    else{
        MyVideo *cellData = self.items[indexPath.row];
        NSInteger cellType;
        cellType = cellData.cellType;
        NSString* cellTypeString = [NSString stringWithFormat:@"cellType:%d", cellType];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellTypeString];
        if(cell == nil){
            cell = [[RecommendationVideoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellTypeString];
            [(RecommendationVideoTableViewCell*)cell setCellData:self.items[indexPath.row]];
        }
        else{
            [(RecommendationVideoTableViewCell*)cell setCellData:self.items[indexPath.row]];
        }
        
        return cell;
    }
}

#pragma mark ------------ UITableViewDelegate ------------------

// 通知委托指定行将要被选中，返回响应行的索引
- (nullable NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"willSelectRowAtIndexPath:%@", indexPath);
    return indexPath;
}

// 通知委托指定行被选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([self.items[indexPath.row] isKindOfClass:[NewsModel class]]){
        NSLog(@"didSelectRowAtIndexPath:%@", indexPath);
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
            // 跳转
        NewsDetailViewController *newsDetailVC = [[NewsDetailViewController alloc] init];
        NewsModel *temp = self.items[indexPath.row];
        newsDetailVC.groupID = temp.groupID;
        [self.navigationController pushViewController:newsDetailVC animated:NO];
    }
    else{
        
        NSLog(@"didSelectRowAtIndexPath:%@", indexPath);
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSString *cellType = cell.reuseIdentifier;
        if([cellType isEqualToString:@"cellType:1"]) {
            VideoDetailViewController *videoDetailViewController = [[VideoDetailViewController alloc] init];
            videoDetailViewController.myVideo = self.items[indexPath.row];
            [self.navigationController pushViewController:videoDetailViewController animated:NO];
        }
    }
    
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    self.tableView.editing = YES;
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"关注" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        //        [self.tableView reloadData];
        //        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        // 退出编辑模式
        self.tableView.editing = NO;
    }];
    
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [self.items removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        switch(self.select) {
            case 1:
                [self.itemsOfbt1 removeObjectAtIndex:indexPath.row];
                break;
            
            case 2:
                [self.itemsOfbt2 removeObjectAtIndex:indexPath.row];
                break;
            
            case 3:
                [self.itemsOfbt3 removeObjectAtIndex:indexPath.row];
                break;
                
            case 4:
                [self.itemsOfbt4 removeObjectAtIndex:indexPath.row];
                break;
        }
        
    }];
    return @[action1,action];
}

#pragma mark - 按钮的点击
/*
- (IBAction)remove {
    // 进入编辑模式
    //    self.tableView.editing = !self.tableView.isEditing;
    [self.tableView setEditing:!self.tableView.isEditing animated:YES];
}
*/


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([self.items[indexPath.row] isKindOfClass:[NewsModel class]]){
        return UITableViewAutomaticDimension;
    }
    else{
        return 100;
    }
}

/*- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
 //因为复用，同一个cell可能会走多次
 if ([_cell isEqual:cell]) {
 //区分是否是播放器所在cell,销毁时将指针置空
 [_playerView destroyPlayer];
 _cell = nil;
 }
 }*/

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



@end
