//
//  VideoDetailViewController.m
//  MiniHeadline
//
//  Created by huangscar on 2019/4/27.
//  Copyright © 2019 Booooby. All rights reserved.
//
// 定义这个常量，就可以不用在开发过程中使用mas_前缀。
#define MAS_SHORTHAND
// 定义这个常量，就可以让Masonry帮我们自动把基础数据类型的数据，自动装箱为对象类型。
#define MAS_SHORTHAND_GLOBALS
#import "VideoDetailViewController.h"
#import "../../../Common/UIColor+Hex.h"
#import "../Model/MyVideo.h"
#import <AVFoundation/AVFoundation.h>
#import "../Model/MyComment.h"
#import "../ViewModel/LoadingTableViewCell.h"
#import "../ViewModel/RecommendationVideoTableViewCell.h"
#import "../ViewModel/CommentTableViewCell.h"
#import "../ViewModel/ChoosenCommentTableViewCell.h"
#import "Masonry.h"

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
@property (nonatomic, strong) UITextField *editCommentField;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) UIView *commentsView;
@property (nonatomic, strong) UITextView *commentText;

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
@property (nonatomic, strong) NSTimer *videoTimer;
@property (nonatomic, strong) UIButton *backFullScreenBtn;

@property (nonatomic, strong) UIView *commentTwoView;
@property (nonatomic, strong) UILabel *commentViewLabel;
@property (nonatomic, strong) UITableView *commentViewTableView;
@property (nonatomic, strong) UIButton *closeCommentViewBtn;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) MyComment *choosenComment;

@property (nonatomic, strong) NSMutableArray<MyVideo*>* recommendationVideoList;
@property (nonatomic, strong) NSMutableArray<MyComment*>* commentsList;
@property (nonatomic, strong) NSMutableArray<MyComment*>* commentsListSecond;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger pageIndexSecond;
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
    self.icon = [[UIButton alloc] init];
    
    //self.icon = [[UIButton alloc] initWithFrame:CGRectMake(19, 311, 35, 35)];
    [self.icon setBackgroundImage:self.myVideo.icon forState:UIControlStateNormal];
    [self.view addSubview:self.icon];
    self.name = [[UILabel alloc] init];
    //self.name = [[UILabel alloc] initWithFrame:CGRectMake(62, 311, 254, 35)];
    self.name.font = [UIFont systemFontOfSize:17];
    [self.name setText:self.myVideo.authorName];
    [self.view addSubview:self.name];
    //self.followBtn = [[UIButton alloc] initWithFrame:CGRectMake(324, 313, 70, 30)];
    self.followBtn = [[UIButton alloc] init];
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
    //self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 354, 374, 31)];
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:25];
    [self.titleLabel setText:self.myVideo.title];
    [self.view addSubview:self.titleLabel];
    self.moreDetail = [[UILabel alloc] init];
    //self.moreDetail = [[UILabel alloc] initWithFrame:CGRectMake(20, 393, 374, 21)];
    self.moreDetail.font = [UIFont systemFontOfSize:17];
    self.moreDetail.textColor = [UIColor grayColor];
    [self.moreDetail setText:@"随便下的视频"];
    [self.view addSubview:self.moreDetail];
    self.likeBtn = [[UIButton alloc] init];
    //self.likeBtn = [[UIButton alloc] initWithFrame:CGRectMake(19, 436, 71, 25)];
    [self.likeBtn setImage:[UIImage imageNamed:@"like_25.png"] forState:UIControlStateNormal];
    [self.likeBtn setTitle:@" 1234" forState:UIControlStateNormal];
    [self.likeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.likeBtn];
    self.unlikeBtn = [[UIButton alloc] init];
    //self.unlikeBtn = [[UIButton alloc] initWithFrame:CGRectMake(120, 436, 71, 25)];
    [self.unlikeBtn setImage:[UIImage imageNamed:@"unlike_25.png"] forState:UIControlStateNormal];
    [self.unlikeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.unlikeBtn setTitle:@" 1234" forState:UIControlStateNormal];
    [self.view addSubview:self.unlikeBtn];
    self.moreBtn = [[UIButton alloc] init];
    //self.moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(290, 435, 104, 26)];
    [self.moreBtn setImage:[UIImage imageNamed:@"link.png"] forState:UIControlStateNormal];
    [self.moreBtn setTitle:@" 了解更多" forState:UIControlStateNormal];
    [self.moreBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.moreBtn];
    self.footToolBar = [[UIView alloc] init];
    //self.footToolBar = [[UIView alloc] initWithFrame:CGRectMake(0, 818, 414, 44)];
    [self.footToolBar setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [self.view addSubview:self.footToolBar];
    self.editCommentBtn = [[UIButton alloc] init];
    //self.editCommentBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 7, 130, 30)];
    [self.editCommentBtn setImage:[UIImage imageNamed:@"write.png"] forState:UIControlStateNormal];
    [self.editCommentBtn setTitle:@"写评论..." forState:UIControlStateNormal];
    [self.editCommentBtn setBackgroundColor:[UIColor whiteColor]];
    [self.editCommentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.editCommentBtn.layer.cornerRadius = 15;
    [self.footToolBar addSubview:self.editCommentBtn];
    self.commentBtn = [[UIButton alloc] init];
    //self.commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(181, 8, 25, 25)];
    [self.commentBtn setBackgroundImage:[UIImage imageNamed:@"comment.png"] forState:UIControlStateNormal];
    [self.footToolBar addSubview:self.commentBtn];
    self.starBtn = [[UIButton alloc] init];
    //self.starBtn = [[UIButton alloc] initWithFrame:CGRectMake(237, 8, 25, 25)];
    [self.starBtn setBackgroundImage:[UIImage imageNamed:@"star_25.png"] forState:UIControlStateNormal];
    [self.footToolBar addSubview:self.starBtn];
    self.likeBarBtn = [[UIButton alloc] init];
    //self.likeBarBtn = [[UIButton alloc] initWithFrame:CGRectMake(296, 8, 25, 25)];
    [self.likeBarBtn setBackgroundImage:[UIImage imageNamed:@"like_23.png"] forState:UIControlStateNormal];
    [self.footToolBar addSubview:self.likeBarBtn];
    self.shareBtn = [[UIButton alloc] init];
    //self.shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(351, 8, 25, 25)];
    [self.shareBtn setBackgroundImage:[UIImage imageNamed:@"Share_25.png"] forState:UIControlStateNormal];
    [self.footToolBar addSubview:self.shareBtn];
    self.videoView = [[UIView alloc] init];
    //self.videoView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, screenBound.size.width, 254)];
    self.videoView.backgroundColor = [UIColor blackColor];
    NSURL *url = [NSURL fileURLWithPath:self.myVideo.video];
    self.videoPlayer = [AVPlayer playerWithURL:url];
    self.video = [AVPlayerLayer playerLayerWithPlayer:self.videoPlayer];
    [self.videoView.layer addSublayer:self.video];
    [self.view addSubview:self.videoView];
    self.backBtn = [[UIButton alloc] init];
    //self.backBtn = [[UIButton alloc] initWithFrame:CGRectMake(8, 8, 30, 30)];
    [self.backBtn setBackgroundImage:[UIImage imageNamed:@"back_white_25.png"] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.videoView addSubview:self.backBtn];
    self.playBtn = [[UIButton alloc] init];
    //self.playBtn = [[UIButton alloc] initWithFrame:CGRectMake(19, 219, 25, 25)];
    [self.playBtn setBackgroundImage:[UIImage imageNamed:@"play_white.png"] forState:UIControlStateNormal];
    [self.playBtn addTarget:self action:@selector(pauseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.videoView addSubview:self.playBtn];
    self.videoProgess = [[UISlider alloc] init];
    //self.videoProgess = [[UISlider alloc] initWithFrame:CGRectMake(92, 217, 231, 30)];
    [self.videoView addSubview:self.videoProgess];
    self.fullScreamBtn = [[UIButton alloc] init];
    //self.fullScreamBtn = [[UIButton alloc] initWithFrame:CGRectMake(364, 219, 25, 25)];
    [self.fullScreamBtn setBackgroundImage:[UIImage imageNamed:@"full-screen.png"] forState:UIControlStateNormal];
    [self.videoView addSubview:self.fullScreamBtn];
    self.backFullScreenBtn = [[UIButton alloc] init];
    //self.backFullScreenBtn = [[UIButton alloc] initWithFrame:CGRectMake(60, 21, 30, 30)];
    [self.backFullScreenBtn setBackgroundImage:[UIImage imageNamed:@"back_white_25.png"] forState:UIControlStateNormal];
    self.currTime = [[UILabel alloc] init];
    //self.currTime = [[UILabel alloc] initWithFrame:CGRectMake(52, 224, 34, 15)];
    [self.currTime setTextColor:[UIColor whiteColor]];
    self.currTime.font = [UIFont systemFontOfSize:12];
    [self.currTime setText:@"00:00"];
    [self.videoView addSubview:self.currTime];
    AVURLAsset *avUrlAsset = [AVURLAsset assetWithURL:url];
    CMTime videoDuration = [avUrlAsset duration];
    float videoDurationSeconds = CMTimeGetSeconds(videoDuration);
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:videoDurationSeconds];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:@"mm:ss"];  //you can vary the date string. Ex: "mm:ss"
    NSString* result = [dateFormatter stringFromDate:date];
    self.duraTime = [[UILabel alloc] init];
    //self.duraTime = [[UILabel alloc] initWithFrame:CGRectMake(329, 224, 34, 15)];
    [self.duraTime setTextColor:[UIColor whiteColor]];
    self.duraTime.font = [UIFont systemFontOfSize:12];
    [self.duraTime setText:result];
    [self.videoView addSubview:self.duraTime];
    self.editCommentField = [[UITextField alloc] init];
    self.commentTwoView = [[UIView alloc] init];
    self.closeCommentViewBtn = [[UIButton alloc] init];
    [self.closeCommentViewBtn setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    //[self.closeCommentViewBtn setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    self.commentViewLabel = [[UILabel alloc] init];
    [self.commentViewLabel setText:@"所有评论"];
    self.line = [[UIView alloc] init];
    [self.line setBackgroundColor:[UIColor darkGrayColor]];
    //[self.commentViewLabel setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    //设置位置
    [self.videoView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(44);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(screenBound.size.width*7/12);
    }];
    [self.backBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.videoView).with.offset(10);
        make.left.equalTo(self.videoView).with.offset(10);
        make.width.and.height.equalTo(25);
    }];
    [self.playBtn makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.videoView).with.offset(-10);
        make.left.equalTo(self.videoView).with.offset(10);
        make.width.and.height.equalTo(30);
    }];
    [self.fullScreamBtn makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.videoView).with.offset(-10);
        make.right.equalTo(self.videoView).with.offset(-10);
        make.width.and.height.equalTo(30);
    }];
    [self.currTime makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playBtn.right).with.offset(10);
        make.centerY.equalTo(self.playBtn.centerY);
    }];
    [self.duraTime makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.fullScreamBtn.left).with.offset(-10);
        make.centerY.equalTo(self.fullScreamBtn.centerY);
    }];
    [self.videoProgess makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.currTime.right).with.offset(10);
        make.right.equalTo(self.duraTime.left).with.offset(-10);
        make.centerY.equalTo(self.currTime.centerY);
        make.centerX.equalTo(self.view.centerX);
    }];
    [self.icon makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.videoView.bottom).with.offset(20);
        make.left.equalTo(self.view).with.offset(20);
        make.width.and.height.equalTo(30);
    }];
    [self.name makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.right).with.offset(10);
        make.centerY.equalTo(self.icon.centerY);
    }];
    [self.followBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).with.offset(-20);
        make.centerY.equalTo(self.icon.centerY);
        make.width.equalTo(70);
        make.height.equalTo(30);
    }];
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(20);
        make.top.equalTo(self.icon.bottom).with.offset(15);
        make.width.equalTo(screenBound.size.width);
    }];
    [self.moreDetail makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.top.equalTo(self.titleLabel.bottom).with.offset(15);
        make.width.equalTo(screenBound.size.width);
    }];
    [self.likeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(20);
        make.top.equalTo(self.moreDetail.bottom).with.offset(20);
    }];
    [self.unlikeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.likeBtn.right).with.offset(15);
        make.centerY.equalTo(self.likeBtn.centerY);
        
    }];
    [self.moreBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).with.offset(-20);
        make.centerY.equalTo(self.likeBtn.centerY);
    }];
    [self.footToolBar makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(-44);
        make.left.equalTo(self.view);
        make.width.equalTo(screenBound.size.width);
        make.height.equalTo(44);
    }];
    [self.editCommentBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(20);
        make.centerY.equalTo(self.footToolBar.centerY);
        make.width.equalTo(130);
    }];
    NSInteger offsetNum = (screenBound.size.width-130-25*4-40)/4;
    [self.commentBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.editCommentBtn.right).with.offset(offsetNum);
        make.centerY.equalTo(self.editCommentBtn.centerY);
        make.height.and.width.equalTo(25);
    }];
    [self.starBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commentBtn.right).with.offset(offsetNum);
        make.centerY.equalTo(self.editCommentBtn.centerY);
        make.height.and.width.equalTo(25);
    }];
    [self.likeBarBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.starBtn.right).with.offset(offsetNum);
        make.centerY.equalTo(self.editCommentBtn.centerY);
        make.height.and.width.equalTo(25);
    }];
    [self.shareBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.likeBarBtn.right).with.offset(offsetNum);
        make.centerY.equalTo(self.editCommentBtn.centerY);
        make.height.and.width.equalTo(25);
    }];
    self.commentTableView = ({
        UITableView* tableView = ([[UITableView alloc]initWithFrame:CGRectMake(0, 477, 414, 341) style:UITableViewStylePlain]);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = [UIView new];
        tableView;
    });
    [self.view addSubview:self.commentTableView];
    [self.commentTableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.likeBtn.bottom).with.offset(10);
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.footToolBar.top);
        make.width.equalTo(screenBound.size.width);
    }];
    self.fullView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 896, 414)];
    
    
    NSArray* videoPart = [self loadVideo];
    self.recommendationVideoList = [NSMutableArray arrayWithArray:videoPart];
    NSArray* commentPart = [self loadComment:0];
    self.commentsList = [NSMutableArray arrayWithArray:commentPart];
    self.pageIndex = 0;
    
    
    self.video.frame = CGRectMake(0, 0, screenBound.size.width, screenBound.size.width*7/12);
    
    
    [self.fullScreamBtn addTarget:self action:@selector(fullScreamBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.commentBtn addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.backFullScreenBtn addTarget:self action:@selector(backBtnFullScreenClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.editCommentBtn addTarget:self action:@selector(editCommentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.videoProgess addTarget:self action:@selector(progessChange:) forControlEvents:UIControlEventValueChanged];
    [self.closeCommentViewBtn addTarget:self action:@selector(closeComment:) forControlEvents:UIControlEventTouchUpInside];
    
    
    /// 添加监听.以及回调
    __weak typeof(self) weakSelf = self;
    self.videoTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timer) userInfo:nil repeats:YES];
}

- (void)timer {
    self.videoProgess.value = CMTimeGetSeconds(self.videoPlayer.currentItem.currentTime) / CMTimeGetSeconds(self.videoPlayer.currentItem.duration);
    float videoCurrentSeconds = CMTimeGetSeconds(self.videoPlayer.currentItem.currentTime);
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:videoCurrentSeconds];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:@"mm:ss"];  //you can vary the date string. Ex: "mm:ss"
    NSString* result = [dateFormatter stringFromDate:date];
    [self.currTime setText:result];
}

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)fullScreamBtnClick:(id)sender {
    CGRect screenBound = [UIScreen mainScreen].bounds;
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationLandscapeRight] forKey:@"orientation"];
    [self.videoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(self.view);
    }];
    [self.videoView addSubview:self.backFullScreenBtn];
    [self.backBtn removeFromSuperview];
    [self.backFullScreenBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(20);
        make.top.equalTo(self.view).with.offset(20);
        make.width.and.height.equalTo(30);
    }];
    [self.playBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.videoView).with.offset(60);
        make.bottom.equalTo(self.videoView).with.offset(-50);
        make.height.and.width.equalTo(30);
    }];
    [self.currTime mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playBtn.right).with.offset(15);
        make.centerY.equalTo(self.playBtn.centerY);
    }];
    [self.duraTime mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.videoView).with.offset(-105);
        make.centerY.equalTo(self.playBtn.centerY);
    }];
    [self.videoProgess mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.currTime.right).with.offset(15);
        make.right.equalTo(self.duraTime.left).with.offset(-15);
        make.centerY.equalTo(self.playBtn.centerY);
        make.centerX.equalTo(self.videoView);
        make.height.equalTo(30);
    }];
    self.video.frame = CGRectMake(0, 0, screenBound.size.height, screenBound.size.width);
    [self.fullScreamBtn removeFromSuperview];
    //[self.backBtn removeTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (IBAction)closeComment:(id)sender {
    [self.commentTwoView removeFromSuperview];
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

- (IBAction)backBtnFullScreenClick:(id)sender {
    
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
    CGRect screenBound = [UIScreen mainScreen].bounds;
    [self.backFullScreenBtn removeFromSuperview];
    [self.videoView addSubview:self.backBtn];
    [self.videoView addSubview:self.fullScreamBtn];
    [self.videoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(44);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(screenBound.size.width*7/12);
    }];
    //[self.backBtn setFrame:CGRectMake(60, 21, 30, 30)];
    
    [self.backBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.videoView).with.offset(10);
        make.left.equalTo(self.videoView).with.offset(10);
        make.width.and.height.equalTo(25);
    }];
    [self.playBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.videoView).with.offset(-10);
        make.left.equalTo(self.videoView).with.offset(10);
        make.width.and.height.equalTo(30);
    }];
    [self.fullScreamBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.videoView).with.offset(-10);
        make.right.equalTo(self.videoView).with.offset(-10);
        make.width.and.height.equalTo(30);
    }];
    [self.currTime mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playBtn.right).with.offset(10);
        make.centerY.equalTo(self.playBtn.centerY);
    }];
    [self.duraTime mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.fullScreamBtn.left).with.offset(-10);
        make.centerY.equalTo(self.fullScreamBtn.centerY);
    }];
    [self.videoProgess mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.currTime.right).with.offset(10);
        make.right.equalTo(self.duraTime.left).with.offset(-10);
        make.centerY.equalTo(self.currTime.centerY);
        make.centerX.equalTo(self.view.centerX);
    }];
    self.video.frame = CGRectMake(0, 0, screenBound.size.width, screenBound.size.width*7/12);
    
}

-(IBAction)progessChange:(UISlider*)sender{
    NSURL *url = [NSURL fileURLWithPath:self.myVideo.video];
    AVURLAsset *avUrlAsset = [AVURLAsset assetWithURL:url];
    CMTime videoDuration = [avUrlAsset duration];
    float videoDurationSeconds = CMTimeGetSeconds(videoDuration);
    CGFloat fps = [[[avUrlAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] nominalFrameRate];
    CMTime time = CMTimeMakeWithSeconds(videoDurationSeconds * sender.value, fps);
    
    [self.videoPlayer seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

-(void)textViewDidChange:(UITextView *)textView{
    CGRect screenBound = [UIScreen mainScreen].bounds;
    static CGFloat maxHeight =60.0f;
    CGRect frame = textView.frame;
    CGRect viewFrame = self.commentsView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    CGFloat height = size.height;
    if (size.height<=30) {
        height=30;
    }
    else{
        if (size.height >= maxHeight) {
            height = maxHeight;
            textView.scrollEnabled = YES;  // 允许滚动
        }
        else{
            //textView.scrollEnabled = NO;    // 不允许滚动
        }
    }
    if(height == frame.size.height) {
        self.commentsView.frame = CGRectMake(viewFrame.origin.x, viewFrame.origin.y-(frame.size.height+15-viewFrame.size.height), viewFrame.size.width, frame.size.height+15);
    }
    //textView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, height);
    [self.sendBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.commentsView).with.offset(-10);
        make.centerY.equalTo(self.commentsView.centerY);
        make.height.equalTo(30);
        make.width.equalTo(50);
    }];
    [self.commentText mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commentsView).with.offset(10);
        make.right.equalTo(self.sendBtn.left).with.offset(-10);
        //make.centerY.equalTo(self.commentsView.centerY);
        make.top.equalTo(self.commentsView.top).with.offset(10);
        make.height.mas_greaterThanOrEqualTo(height);
    }];
}

- (void)createCommentsView {
    CGRect screenBound = [UIScreen mainScreen].bounds;
    if (!self.commentsView) {
        
        self.commentsView = [[UIView alloc] initWithFrame:CGRectMake(0.0, screenBound.size.height, screenBound.size.width, 40.0)];
        self.commentsView.backgroundColor = [UIColor whiteColor];
        self.sendBtn = [[UIButton alloc] init];
        [self.sendBtn setTitle:@"发布" forState:UIControlStateNormal];
        [self.sendBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.commentsView addSubview:self.sendBtn];
        self.commentText = [[UITextView alloc] init];
        self.commentText.layer.borderColor = [UIColor darkGrayColor].CGColor;
        self.commentText.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
        //commentText.layer.borderColor   = [COLORRGB(212.0, 212.0, 212.0) CGColor];
        self.commentText.layer.borderWidth   = 1.0;
        self.commentText.layer.cornerRadius  = 15.0;
        self.commentText.layer.masksToBounds = YES;
        self.commentText.inputAccessoryView  = self.commentsView;
        self.commentText.backgroundColor     = [UIColor clearColor];
        //self.commentText.returnKeyType       = UIReturnKeySend;
        self.commentText.delegate            = self;
        self.commentText.font                = [UIFont systemFontOfSize:15.0];
        self.commentText.textContainerInset = UIEdgeInsetsMake(7.5, 15, 0, 15);
        [self.commentsView addSubview:self.commentText];
        [self.sendBtn makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.commentsView).with.offset(-10);
            make.centerY.equalTo(self.commentsView.centerY);
            make.height.equalTo(30);
            make.width.equalTo(50);
        }];
        [self.commentText makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.commentsView).with.offset(10);
            make.right.equalTo(self.sendBtn.left).with.offset(-10);
            make.centerY.equalTo(self.commentsView.centerY);
            make.height.mas_greaterThanOrEqualTo(30);
        }];
        [self.commentText setDelegate:self];
        [self.sendBtn addTarget:self action:@selector(sendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view.window addSubview:self.commentsView];//添加到window上或者其他视图也行，只要在视图以外就好了
    [self.commentText becomeFirstResponder];//让textView成为第一响应者（第一次）这次键盘并未显示出来，（个人觉得这里主要是将commentsView设置为commentText的inputAccessoryView,然后再给一次焦点就能成功显示）
}

-(IBAction)sendBtnClick:(id)sender {
    
    [self.view endEditing:YES];
    [self.commentsView removeFromSuperview];
    self.editCommentBtn.userInteractionEnabled = YES;
    [self addComment];
}

-(void) addComment {
    MyComment *myComment = [[MyComment alloc]initWithComment:[UIImage imageNamed:@"icon_2.png"] authorName:@"huangscar" comment:self.commentText.text likeNum:0 isLike:NO date:[NSDate date]];
    [self.commentText setText:@""];
    [self.commentsList insertObject:myComment atIndex:0];
    [self.commentTableView reloadData];
}

- (void)showCommentText {
    [self createCommentsView];
    
    [self.commentText becomeFirstResponder];//再次让textView成为第一响应者（第二次）这次键盘才成功显示
}

- (IBAction)editCommentBtnClick:(id)sender {
    UIButton *clickBtn = (UIButton*)sender;
    clickBtn.userInteractionEnabled = NO;
    [sender performSelector:@selector(setUserInteractionEnabled:) withObject:@YES afterDelay:1];
    [self showCommentText];
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [self.commentsView removeFromSuperview];
    self.editCommentBtn.userInteractionEnabled = YES;
}

- (NSArray*)loadComment:(NSInteger)tableViewType{
    NSMutableArray* result;
    if(tableViewType == 0) {
        result = [NSMutableArray arrayWithCapacity:3];
        for(int i=0; i<3; i++){
            //NSString *path = [[NSBundle mainBundle] pathForResource:@"video" ofType:@".mp4"];
            MyComment *myComment = [[MyComment alloc] initWithComment:[UIImage imageNamed:[NSString stringWithFormat:@"icon_%d", i]] authorName:[NSString stringWithFormat:@"aaaaaaaaaaaaa%d", i] comment:[NSString stringWithFormat:@"日清和海贼王的联动广告，哈哈哈哈哈哈不愧是日清的广告，我还记得之前的小狐狸吉冈里帆_%d", i]  likeNum:(i+1)*10 isLike:NO date:[NSDate date]];
            [result addObject:myComment];
        }
    }
    else {
        result = [NSMutableArray arrayWithCapacity:3];
        for(int i=0; i<3; i++){
            //NSString *path = [[NSBundle mainBundle] pathForResource:@"video" ofType:@".mp4"];
            MyComment *myComment = [[MyComment alloc] initWithComment:[UIImage imageNamed:[NSString stringWithFormat:@"icon_%d", i]] authorName:[NSString stringWithFormat:@"aaaaaaaaaaaaa%d", i] comment:[NSString stringWithFormat:@"你这个什么垃圾评论啊_%d", i]  likeNum:(i+1)*10 isLike:NO date:[NSDate date]];
            [result addObject:myComment];
        }
    }
    return result;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([tableView isEqual:self.commentTableView]) {
        if(section == 0){
            return self.recommendationVideoList.count;
        }
        else {
            return self.commentsList.count + 1; // 增加的1为加载更多
        }
    }
    else {
        if(section == 0) {
            return 1;
        }
        else {
            return self.commentsListSecond.count + 1;
        }
    }
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSInteger cellType;
    UITableViewCell* cell;
    if([tableView isEqual:self.commentTableView]) {
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
        cell = [tableView dequeueReusableCellWithIdentifier:cellTypeString];
        
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
    }
    else {
        if(indexPath.row == self.commentsList.count) {
            cellType = 0;
        }
        else if(indexPath.section == 0) {
            cellType = 3;
        }
        else {
            cellType = self.commentsList[indexPath.row].cellType;
        }
        NSString* cellTypeString = [NSString stringWithFormat:@"cellType:%d", cellType];
        cell = [tableView dequeueReusableCellWithIdentifier:cellTypeString];
        if(cell == nil) {
            if(cellType == 0){
                cell = [[LoadingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellTypeString];
                ((LoadingTableViewCell*) cell).status = self.status;
                cell.selectionStyle = ((self.status==LoadingStatusDefault)?UITableViewCellSelectionStyleDefault:UITableViewCellSelectionStyleNone);
            }
            else if(cellType == 2) {
                cell = [[CommentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellTypeString];
                [(CommentTableViewCell*)cell setCellData:self.commentsListSecond[indexPath.row]];
            }
            else if(cellType == 3) {
                cell = [[ChoosenCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellTypeString];
                [(ChoosenCommentTableViewCell*)cell setCellData:self.choosenComment];
                cellType = 3;
            }
        } else {
            if(cellType == 0){
                ((LoadingTableViewCell*) cell).status = self.status;
                cell.selectionStyle = ((self.status==LoadingStatusDefault)?UITableViewCellSelectionStyleDefault:UITableViewCellSelectionStyleNone);
            }
            else if(cellType == 2) {
                [(CommentTableViewCell*)cell setCellData:self.commentsListSecond[indexPath.row]];
            }
            else if(cellType == 3) {
                [(ChoosenCommentTableViewCell*)cell setCellData:self.choosenComment];
            }
        }
    }
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if(indexPath.row == self.commentsList.count) {
        self.status = LoadingStatusLoding;
        [tableView reloadData]; // 从默认态切换到加载状态，需要更新
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if([tableView isEqual:self.commentTableView]) {
                self.pageIndex++;
                if (self.pageIndex < 5) {
                    self.status = LoadingStatusDefault;
                } else {
                    self.status = LoadingStatusNoMore;
                }
                
                NSArray *newPage = [self loadComment:0];
                [self.commentsList addObjectsFromArray:newPage];
            }
            else {
                self.pageIndexSecond++;
                if (self.pageIndexSecond < 5) {
                    self.status = LoadingStatusDefault;
                } else {
                    self.status = LoadingStatusNoMore;
                }
                
                NSArray *newPage = [self loadComment:1];
                [self.commentsListSecond addObjectsFromArray:newPage];
            }
            [tableView reloadData];  // 从默认态切换到加载状态或者加载技术，需要更新
        });
    }
    else {
        NSLog(@"didSelectRowAtIndexPath:%@", indexPath);
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        if([tableView isEqual:self.commentTableView]) {
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
            else {
                CGRect screenBound = [UIScreen mainScreen].bounds;
                [self.commentTwoView setBackgroundColor:[UIColor whiteColor]];
                if(!self.commentViewTableView) {
                    self.commentViewTableView = ({
                        UITableView* tableView = ([[UITableView alloc]initWithFrame:CGRectMake(0, 52, screenBound.size.width, 290) style:UITableViewStylePlain]);
                        tableView.delegate = self;
                        tableView.dataSource = self;
                        tableView.tableFooterView = [UIView new];
                        tableView;
                    });
                }
                //self.closeCommentViewBtn.frame = CGRectMake(30, 0, 30, 30);
                [self.commentTwoView addSubview:self.commentViewLabel];
                [self.commentTwoView addSubview:self.commentViewTableView];
                [self.commentTwoView addSubview:self.closeCommentViewBtn];
                [self.commentTwoView addSubview:self.line];
                [self.view addSubview:self.commentTwoView];
                self.commentViewLabel.textAlignment = NSTextAlignmentCenter;
                [self.commentTwoView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.likeBtn.bottom).with.offset(10);
                    make.bottom.equalTo(self.footToolBar.top);
                    make.left.equalTo(self.view);
                    make.right.equalTo(self.view);
                }];
                [self.closeCommentViewBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.commentTwoView).with.offset(10);
                    make.left.equalTo(self.commentTwoView).with.offset(10);
                    make.width.height.equalTo(25);
                }];
                [self.commentViewLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(self.closeCommentViewBtn.centerY);
                    make.left.equalTo(self.closeCommentViewBtn.right).with.offset(10);
                    make.right.equalTo(self.commentTwoView);
                    make.height.equalTo(50);
                }];
                [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.commentViewLabel.bottom);
                    make.left.equalTo(self.commentTwoView);
                    make.right.equalTo(self.commentTwoView);
                    make.height.equalTo(1);
                }];
                /*[self.commentViewTableView makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.commentViewLabel.bottom).with.offset(10);
                    make.left.equalTo(self.commentTwoView);
                    make.bottom.equalTo(self.footToolBar.top);
                    make.width.equalTo(screenBound.size.width);
                }];*/
                CommentTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                _choosenComment = cell.data;
                NSArray* commentPart = [self loadComment:1];
                self.commentsListSecond = [NSMutableArray arrayWithArray:commentPart];
                self.pageIndexSecond = 0;
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == self.commentsList.count) {
        return 30;
    }
    else {
        if([tableView isEqual:self.commentTableView]) {
            if(indexPath.section == 0) {
                return 110;
            }
            return self.commentsList[indexPath.row].height;
        }
        else {
            if(indexPath.section == 0) {
                self.choosenComment.height;
            }
            return self.commentsListSecond[indexPath.row].height;
        }
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
