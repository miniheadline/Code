//
//  VideoDetailViewController.m
//  MiniHeadline
//
//  Created by huangscar on 2019/4/27.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import "VideoDetailViewController.h"
#import "../../../Common/UIColor+Hex.h"
#import "../Model/MyVideo.h"
#import <AVFoundation/AVFoundation.h>
#import "../Model/MyComment.h"
#import "../ViewModel/LoadingTableViewCell.h"
#import "../ViewModel/RecommendationVideoTableViewCell.h"
#import "../ViewModel/CommentTableViewCell.h"

@interface VideoDetailViewController ()

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *icon;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UIButton *followBtn;
@property (nonatomic, strong) UILabel *moreDetail;
@property (nonatomic, strong) UIButton *likeBtn;
@property (nonatomic, strong) UIButton *unlikeBtn;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) UITableView *commentTableView;

@property (nonatomic, strong) UIView *footToolBar;
@property (nonatomic, strong) UIButton *editCommentBtn;
@property (nonatomic, strong) UIButton *commentBtn;
@property (nonatomic, strong) UIButton *starBtn;
@property (nonatomic, strong) UIButton *likeBarBtn;
@property (nonatomic, strong) UIButton *shareBtn;

@property (nonatomic, assign) BOOL isPlay;
@property (nonatomic, strong) AVPlayer *videoPlayer;
@property (nonatomic, strong) AVPlayerLayer *video;
@property (nonatomic, strong) UIView *videoView;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UISlider *videoProgess;
@property (nonatomic, strong) UIButton *fullScreamBtn;
@property (nonatomic, strong) UILabel *currTime;
@property (nonatomic, strong) UILabel *duraTime;
@property (nonatomic, strong) UIView *fullView;

@property (nonatomic, strong) NSMutableArray<MyVideo*>* recommendationVideoList;
@property (nonatomic, strong) NSMutableArray<MyComment*>* commentsList;
@property (nonatomic, assign) NSInteger pageIndex;
@property(nonatomic, assign)LoadingStatus status;
@end

@implementation VideoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.myVideo) {
        self.isPlay = NO;
        [self addSubViews];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES; // 隐藏navigationBar
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO; // 取消隐藏navigationBar
    [super viewWillDisappear:animated];
}

- (void)addSubViews {
    // 获取屏幕尺寸（包括状态栏）
    CGRect screenBound = [UIScreen mainScreen].bounds;
    // 获取状态栏尺寸
    CGRect statusBound = [[UIApplication sharedApplication] statusBarFrame];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.videoView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 414, 254)];
    self.videoView.backgroundColor = [UIColor blackColor];
    NSURL *url = [NSURL fileURLWithPath:self.myVideo.video];
    self.videoPlayer = [AVPlayer playerWithURL:url];
    self.video = [AVPlayerLayer playerLayerWithPlayer:self.videoPlayer];
    self.video.frame = self.videoView.bounds;
    [self.videoView.layer addSublayer:self.video];
    [self.view addSubview:self.videoView];
    self.backBtn = [[UIButton alloc] initWithFrame:CGRectMake(8, 8, 30, 30)];
    [self.backBtn setBackgroundImage:[UIImage imageNamed:@"back_white_25.png"] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.videoView addSubview:self.backBtn];
    self.playBtn = [[UIButton alloc] initWithFrame:CGRectMake(19, 219, 25, 25)];
    [self.playBtn setBackgroundImage:[UIImage imageNamed:@"play_white.png"] forState:UIControlStateNormal];
    [self.playBtn addTarget:self action:@selector(pauseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.videoView addSubview:self.playBtn];
    self.videoProgess = [[UISlider alloc] initWithFrame:CGRectMake(50, 217, 308, 30)];
    [self.videoView addSubview:self.videoProgess];
    self.fullScreamBtn = [[UIButton alloc] initWithFrame:CGRectMake(364, 219, 25, 25)];
    [self.fullScreamBtn setBackgroundImage:[UIImage imageNamed:@"full-screen.png"] forState:UIControlStateNormal];
    [self.videoView addSubview:self.fullScreamBtn];
    self.icon = [[UIButton alloc] initWithFrame:CGRectMake(19, 311, 35, 35)];
    [self.icon setBackgroundImage:self.myVideo.icon forState:UIControlStateNormal];
    [self.view addSubview:self.icon];
    self.name = [[UILabel alloc] initWithFrame:CGRectMake(62, 311, 254, 35)];
    self.name.font = [UIFont systemFontOfSize:20];
    [self.name setText:self.myVideo.authorName];
    [self.view addSubview:self.name];
    self.followBtn = [[UIButton alloc] initWithFrame:CGRectMake(324, 313, 70, 30)];
    self.followBtn.layer.cornerRadius = 5;
    if(self.myVideo.isFollow == NO) {
        self.followBtn.backgroundColor = [UIColor colorWithHexString:@"#B54434"];
        [self.followBtn setTitle:@"关注" forState:UIControlStateNormal];
    }
    else {
        self.followBtn.backgroundColor = [UIColor grayColor];
        [self.followBtn setTitle:@"取消关注" forState:UIControlStateNormal];
    }
    [self.followBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:self.followBtn];
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 354, 374, 31)];
    self.titleLabel.font = [UIFont systemFontOfSize:30];
    [self.titleLabel setText:self.myVideo.title];
    [self.view addSubview:self.titleLabel];
    self.moreDetail = [[UILabel alloc] initWithFrame:CGRectMake(20, 393, 374, 21)];
    self.moreDetail.font = [UIFont systemFontOfSize:17];
    self.moreDetail.textColor = [UIColor grayColor];
    [self.moreDetail setText:@"随便下的视频"];
    [self.view addSubview:self.moreDetail];
    self.likeBtn = [[UIButton alloc] initWithFrame:CGRectMake(19, 436, 71, 25)];
    [self.likeBtn setImage:[UIImage imageNamed:@"like_25.png"] forState:UIControlStateNormal];
    [self.likeBtn setTitle:@" 1234" forState:UIControlStateNormal];
    [self.likeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.likeBtn];
    self.unlikeBtn = [[UIButton alloc] initWithFrame:CGRectMake(120, 436, 71, 25)];
    [self.unlikeBtn setImage:[UIImage imageNamed:@"unlike_25.png"] forState:UIControlStateNormal];
    [self.unlikeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.unlikeBtn setTitle:@" 1234" forState:UIControlStateNormal];
    [self.view addSubview:self.unlikeBtn];
    self.moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(290, 435, 104, 26)];
    [self.moreBtn setImage:[UIImage imageNamed:@"link.png"] forState:UIControlStateNormal];
    [self.moreBtn setTitle:@" 了解更多" forState:UIControlStateNormal];
    [self.moreBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.moreBtn];
    
    self.footToolBar = [[UIView alloc] initWithFrame:CGRectMake(0, 818, 414, 44)];
    [self.footToolBar setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [self.view addSubview:self.footToolBar];
    self.editCommentBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 7, 130, 30)];
    [self.editCommentBtn setImage:[UIImage imageNamed:@"write.png"] forState:UIControlStateNormal];
    [self.editCommentBtn setTitle:@"写评论..." forState:UIControlStateNormal];
    [self.editCommentBtn setBackgroundColor:[UIColor whiteColor]];
    [self.editCommentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.editCommentBtn.layer.cornerRadius = 15;
    [self.footToolBar addSubview:self.editCommentBtn];
    self.commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(181, 8, 25, 25)];
    [self.commentBtn setBackgroundImage:[UIImage imageNamed:@"comment.png"] forState:UIControlStateNormal];
    [self.footToolBar addSubview:self.commentBtn];
    self.starBtn = [[UIButton alloc] initWithFrame:CGRectMake(237, 8, 25, 25)];
    [self.starBtn setBackgroundImage:[UIImage imageNamed:@"star_25.png"] forState:UIControlStateNormal];
    [self.footToolBar addSubview:self.starBtn];
    self.likeBarBtn = [[UIButton alloc] initWithFrame:CGRectMake(296, 8, 25, 25)];
    [self.likeBarBtn setBackgroundImage:[UIImage imageNamed:@"like_23.png"] forState:UIControlStateNormal];
    [self.footToolBar addSubview:self.likeBarBtn];
    self.shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(351, 8, 25, 25)];
    [self.shareBtn setBackgroundImage:[UIImage imageNamed:@"Share_25.png"] forState:UIControlStateNormal];
    [self.footToolBar addSubview:self.shareBtn];
    
    self.commentTableView = ({
        UITableView* tableView = ([[UITableView alloc]initWithFrame:CGRectMake(0, 477, 414, 341) style:UITableViewStylePlain]);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = [UIView new];
        tableView;
    });
    [self.view addSubview:self.commentTableView];
    self.fullView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 896, 414)];
    
    NSArray* videoPart = [self loadVideo];
    self.recommendationVideoList = [NSMutableArray arrayWithArray:videoPart];
    NSArray* commentPart = [self loadComment:0];
    self.commentsList = [NSMutableArray arrayWithArray:commentPart];
    self.pageIndex = 0;
    
    [self.fullScreamBtn addTarget:self action:@selector(fullScreamBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.commentBtn addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)fullScreamBtnClick:(id)sender {
    
}

- (IBAction)commentBtnClick:(id)sender {
    NSIndexPath * dayOne = [NSIndexPath indexPathForRow:0 inSection:1];
    [self.commentTableView scrollToRowAtIndexPath:dayOne atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (IBAction)pauseBtnClick:(id)sender {
    if(self.isPlay == YES) {
        [self.videoPlayer pause];
        [self.playBtn setBackgroundImage:[UIImage imageNamed:@"play_white.png"] forState:UIControlStateNormal];
        self.isPlay = NO;
    }
    else {
        [self.videoPlayer play];
        [self.playBtn setBackgroundImage:[UIImage imageNamed:@"pause _white.png"] forState:UIControlStateNormal];
        self.isPlay = YES;
    }
}

- (NSArray*)loadVideo{
    NSMutableArray* result = [NSMutableArray arrayWithCapacity:3];
    for(int i=0; i<3; i++){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"video" ofType:@".mp4"];
        MyVideo *myVideo = [[MyVideo alloc] initWithVideo:[NSString stringWithFormat:@"title: %d", i] video:path authorName:[NSString stringWithFormat:@"aaaaaaaaaaaaa%d", i] icon:[UIImage imageNamed:[NSString stringWithFormat:@"icon_%d", i]] commentNum:i*10 isFollow:NO playNum:(i+1)*10000];
        [result addObject:myVideo];
    }
    return result;
}

- (NSArray*)loadComment:(NSInteger)pageIndex{
    NSMutableArray* result = [NSMutableArray arrayWithCapacity:3];
    for(int i=0; i<3; i++){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"video" ofType:@".mp4"];
        MyComment *myComment = [[MyComment alloc] initWithComment:[UIImage imageNamed:[NSString stringWithFormat:@"icon_%d", i]] authorName:[NSString stringWithFormat:@"aaaaaaaaaaaaa%d", i] comment:[NSString stringWithFormat:@"视频随便找的吧喂，放什么鬼抖音啊，你就不能下个别的什么视频吗？？？？？_%d", i]  likeNum:(i+1)*10 isLike:NO date:[NSDate date]];
        [result addObject:myComment];
    }
    return result;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return self.recommendationVideoList.count;
    }
    else {
        return self.commentsList.count + 1; // 增加的1为加载更多
    }
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSInteger cellType;
    if(indexPath.row == self.commentsList.count) {
        cellType = 0;
    }
    else if(indexPath.section == 0) {
        cellType = self.recommendationVideoList[indexPath.row].cellType;
    }
    else {
        cellType = self.commentsList[indexPath.row].cellType;
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
            cell = [[RecommendationVideoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellTypeString];
            [(RecommendationVideoTableViewCell*)cell setCellData:self.recommendationVideoList[indexPath.row]];
            //cell.cellD
        }
        else if(cellType == 2) {
            cell = [[CommentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellTypeString];
            [(CommentTableViewCell*)cell setCellData:self.commentsList[indexPath.row]];
        }
    } else {
        if(cellType == 0){
            ((LoadingTableViewCell*) cell).status = self.status;
            cell.selectionStyle = ((self.status==LoadingStatusDefault)?UITableViewCellSelectionStyleDefault:UITableViewCellSelectionStyleNone);
        }
        else if(cellType == 1) {
            [(RecommendationVideoTableViewCell*)cell setCellData:self.recommendationVideoList[indexPath.row]];
        }
        else if(cellType == 2) {
            [(CommentTableViewCell*)cell setCellData:self.commentsList[indexPath.row]];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if(indexPath.row == self.commentsList.count) {
        self.status = LoadingStatusLoding;
        [tableView reloadData]; // 从默认态切换到加载状态，需要更新
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.pageIndex++;
            if (self.pageIndex < 5) {
                self.status = LoadingStatusDefault;
            } else {
                self.status = LoadingStatusNoMore;
            }
            
            NSArray *newPage = [self loadComment:self.pageIndex];
            [self.commentsList addObjectsFromArray:newPage];
            
            [tableView reloadData];  // 从默认态切换到加载状态或者加载技术，需要更新
        });
    }
    else {
        NSLog(@"didSelectRowAtIndexPath:%@", indexPath);
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        if (indexPath.section == 0) {
            // 跳转
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            NSString *cellType = cell.reuseIdentifier;
            if([cellType isEqualToString:@"cellType:1"]) {
                VideoDetailViewController *videoDetailViewController = [[VideoDetailViewController alloc] init];
                videoDetailViewController.myVideo = self.recommendationVideoList[indexPath.row];
                [self.navigationController pushViewController:videoDetailViewController animated:NO];
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == self.commentsList.count) {
        return 30;
    }
    else {
        if(indexPath.section == 0) {
            return 110;
        }
        return self.commentsList[indexPath.row].height;
    }
}

// 通知委托指定行将要被选中，返回响应行的索引
- (nullable NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"willSelectRowAtIndexPath:%@", indexPath);
    return indexPath;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
