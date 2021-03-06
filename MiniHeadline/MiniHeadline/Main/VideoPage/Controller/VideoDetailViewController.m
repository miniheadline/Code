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

#import <AVFoundation/AVFoundation.h>

#import "VideoDetailViewController.h"
#import "UIColor+Hex.h"
#import "MyVideo.h"
#import "MyComment.h"
#import "RecommendationVideoTableViewCell.h"
#import "CommentTableViewCell.h"
#import "ChoosenCommentTableViewCell.h"
#import "CommentsView.h"
#import "Masonry.h"
#import "VideoDetailTableViewCell.h"
#import "MJRefresh.h"
#import "CommentIDViewModel.h"
#import "PostViewModel.h"
#import "VideoListViewModel.h"
#import "UserInfoModel.h"
#import "Toast.h"


@interface VideoDetailViewController ()

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UILabel *titleLabel;

//@property (nonatomic, strong) UIButton *icon;
//@property (nonatomic, strong) UILabel *name;
//@property (nonatomic, strong) UIButton *followBtn;
//@property (nonatomic, strong) UILabel *moreDetail;
//@property (nonatomic, strong) UIButton *likeBtn;
//@property (nonatomic, strong) UIButton *unlikeBtn;
//@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) UITableView *commentTableView;

@property (nonatomic, strong) UIView *footToolBar;
@property (nonatomic, strong) UIView *seperateLine;
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
@property (nonatomic, strong) AVURLAsset *urlAsset;
@property (nonatomic, strong) UIView *videoView;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UISlider *videoProgess;
@property (nonatomic, strong) UIButton *fullScreamBtn;
@property (nonatomic, strong) UILabel *currTime;
@property (nonatomic, strong) UILabel *duraTime;
@property (nonatomic, strong) UIView *fullView;
@property (nonatomic, strong) NSTimer *videoTimer;
@property (nonatomic, strong) UIButton *backFullScreenBtn;

@property (nonatomic, strong) CommentsView *commentTwoView;
@property (nonatomic, strong) UILabel *commentViewLabel;
@property (nonatomic, strong) UITableView *commentViewTableView;
@property (nonatomic, strong) UIButton *closeCommentViewBtn;
@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) MyComment *choosenComment;

@property (nonatomic, strong) NSMutableArray<MyVideo*>* recommendationVideoList;
@property (nonatomic, strong) NSMutableArray<MyComment*>* commentsList;
@property (nonatomic, strong) NSMutableArray<MyComment*>* commentsListSecond;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger pageIndexSecond;
@property(nonatomic, assign) LoadingStatus status;
@property(nonatomic, assign) LoadingStatus status2;
@property(nonatomic, strong) NSMutableArray<NSNumber*> *cids;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) BOOL hasMore;
@property (nonatomic, assign) BOOL isTwo;
@property (nonatomic, assign) int uid;
@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, strong) VideoDetailTableViewCell *detailCell;
//@property (nonatomic, )
@end

@implementation VideoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.myVideo) {
        self.isPlay = NO;
        //[self setData];
        [self addSubViews];
        self.isLoading = false;
        self.offset = 0;
        [self loadRecommendationData];
        
        self.isTwo = NO;
    }
}

- (void)setData {
    PostViewModel *viewModel = [[PostViewModel alloc] init];
    UserInfoModel *user = [UserInfoModel testUser];
    self.isLogin = user.isLogin;
    self.uid = user.uid;
    if(self.isLogin) {
        dispatch_group_t browseVideo = dispatch_group_create();
        dispatch_group_t getIsLike = dispatch_group_create();
        dispatch_group_t getIsStar = dispatch_group_create();
        dispatch_group_t getLikeNum = dispatch_group_create();
        dispatch_group_enter(browseVideo);
        [viewModel browseVideoWithUid:self.uid vid:self.myVideo.vid success:^{
            dispatch_group_leave(browseVideo);
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"请求失败 error:%@",error.description);
            dispatch_group_leave(browseVideo);
        }];
        dispatch_group_notify(browseVideo, dispatch_get_main_queue(), ^{
            [viewModel getIsLikeWithUid:self.uid vid:self.myVideo.vid success:^(BOOL isLike) {
                self.myVideo.isLike = isLike;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(isLike) {
                        [self.likeBarBtn setImage:[UIImage imageNamed:@"like-fill_25.png"] forState:UIControlStateNormal];
                    }
                    else {
                        [self.likeBarBtn setImage:[UIImage imageNamed:@"like_25.png"] forState:UIControlStateNormal];
                    }
                });
            } failure:^(NSError * _Nonnull error) {
                NSLog(@"请求失败 error:%@",error.description);
            }];
        });
        [viewModel getIsStarWithUid:self.uid vid:self.myVideo.vid success:^(BOOL isStar) {
            self.myVideo.isStar = isStar;
            dispatch_async(dispatch_get_main_queue(), ^{
                if(isStar) {
                    [self.starBtn setImage:[UIImage imageNamed:@"star_on.png"] forState:UIControlStateNormal];
                }
                else {
                    [self.starBtn setImage:[UIImage imageNamed:@"star_25.png"] forState:UIControlStateNormal];
                }
            });
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"请求失败 error:%@",error.description);
        }];
    }
    /*[viewModel getLikeNumWithUid:3 vid:self.myVideo.vid success:^(int likeNumGet) {
        self.myVideo.likeNum = likeNumGet;
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"请求失败 error:%@",error.description);
    }];*/
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
    /*self.icon = [[UIButton alloc] init];
    
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
    [self.view addSubview:self.moreBtn];*/
    self.footToolBar = [[UIView alloc] init];
    //self.footToolBar = [[UIView alloc] initWithFrame:CGRectMake(0, 818, 414, 44)];
    [self.footToolBar setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.footToolBar];
    self.seperateLine = [[UIView alloc] init];
    [self.seperateLine setBackgroundColor:[UIColor colorWithHexString:@"#D9D9D9"]];
    [self.footToolBar addSubview:self.seperateLine];
    self.editCommentBtn = [[UIButton alloc] init];
    //self.editCommentBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 7, 130, 30)];
    [self.editCommentBtn setImage:[UIImage imageNamed:@"write.png"] forState:UIControlStateNormal];
    [self.editCommentBtn setTitle:@"写评论..." forState:UIControlStateNormal];
    [self.editCommentBtn setBackgroundColor:[UIColor colorWithHexString:@"#EDEDED"]];
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
    [self.likeBarBtn setBackgroundImage:[UIImage imageNamed:@"like_25.png"] forState:UIControlStateNormal];
    [self.footToolBar addSubview:self.likeBarBtn];
    self.shareBtn = [[UIButton alloc] init];
    //self.shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(351, 8, 25, 25)];
    [self.shareBtn setBackgroundImage:[UIImage imageNamed:@"Share_25.png"] forState:UIControlStateNormal];
    [self.footToolBar addSubview:self.shareBtn];
    self.videoView = [[UIView alloc] init];
    //self.videoView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, screenBound.size.width, 254)];
    self.videoView.backgroundColor = [UIColor blackColor];
    NSURL *url = [NSURL URLWithString:self.myVideo.video];
    self.duraTime = [[UILabel alloc] init];
    //self.duraTime = [[UILabel alloc] initWithFrame:CGRectMake(329, 224, 34, 15)];
    [self.duraTime setTextColor:[UIColor whiteColor]];
    self.duraTime.font = [UIFont systemFontOfSize:12];
    //self.video = [[AVPlayerLayer alloc] init];
    //[self.videoView.layer addSublayer:self.video];
    [self.videoView addSubview:self.duraTime];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.videoPlayer = [AVPlayer playerWithURL:url];
        self.video = [AVPlayerLayer playerLayerWithPlayer:self.videoPlayer];
        self.urlAsset = [AVURLAsset assetWithURL:url];
        CMTime videoDuration = [self.urlAsset duration];
        float videoDurationSeconds = CMTimeGetSeconds(videoDuration);
        NSDate* date = [NSDate dateWithTimeIntervalSince1970:videoDurationSeconds];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        [dateFormatter setDateFormat:@"mm:ss"];  //you can vary the date string. Ex: "mm:ss"
        NSString* result = [dateFormatter stringFromDate:date];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.videoView.layer insertSublayer:self.video atIndex:0];
            [self.duraTime setText:result];
        });
    });
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
    
    
    self.editCommentField = [[UITextField alloc] init];
    //self.commentTwoView = [[UIView alloc] init];
    self.closeCommentViewBtn = [[UIButton alloc] init];
    [self.closeCommentViewBtn setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    //[self.closeCommentViewBtn setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    self.commentViewLabel = [[UILabel alloc] init];
    [self.commentViewLabel setText:@"所有评论"];
    self.line = [[UIView alloc] init];
    self.line1 = [[UIView alloc] init];
    [self.line setBackgroundColor:[UIColor darkGrayColor]];
    [self.line1 setBackgroundColor:[UIColor darkGrayColor]];
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
    /*[self.icon makeConstraints:^(MASConstraintMaker *make) {
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
    }];*/
    [self.footToolBar makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(-34);
        make.left.equalTo(self.view);
        make.width.equalTo(screenBound.size.width);
        make.height.equalTo(44);
    }];
    [self.seperateLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.footToolBar);
        make.left.and.right.equalTo(self.footToolBar);
        make.height.equalTo(0.5);
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
        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        [footer setTitle:@"" forState:MJRefreshStateIdle];
        tableView.mj_footer = footer;
        tableView;
    });
    [self.view addSubview:self.commentTableView];
    [self.commentTableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.videoView.bottom).with.offset(10);
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.footToolBar.top);
        make.width.equalTo(screenBound.size.width);
    }];
    self.fullView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 896, 414)];
    
    
    //NSArray* videoPart = [self loadVideo];
    //self.recommendationVideoList = [NSMutableArray arrayWithArray:videoPart];
    self.recommendationVideoList = [[NSMutableArray alloc] init];
    self.commentsList = [[NSMutableArray alloc] init];
    
    
    self.video.frame = CGRectMake(0, 0, screenBound.size.width, screenBound.size.width*7/12);
    
    
    [self.fullScreamBtn addTarget:self action:@selector(fullScreamBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.commentBtn addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.backFullScreenBtn addTarget:self action:@selector(backBtnFullScreenClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.editCommentBtn addTarget:self action:@selector(editCommentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.videoProgess addTarget:self action:@selector(progessChange:) forControlEvents:UIControlEventValueChanged];
    [self.closeCommentViewBtn addTarget:self action:@selector(closeComment:) forControlEvents:UIControlEventTouchUpInside];
    [self.likeBarBtn addTarget:self action:@selector(likeBarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.starBtn addTarget:self action:@selector(starBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setData];
    
    // 添加监听.以及回调
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
    NSIndexPath * dayOne = [NSIndexPath indexPathForRow:0 inSection:2];
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
    [self.likeBarBtn addTarget:self action:@selector(likeBarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(IBAction)progessChange:(UISlider*)sender{
    if(!self.videoPlayer.currentItem.isPlaybackBufferEmpty) {
        CMTime videoDuration = [self.urlAsset duration];
        float videoDurationSeconds = CMTimeGetSeconds(videoDuration);
        CGFloat fps = [[[self.urlAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] nominalFrameRate];
        float choose = videoDurationSeconds * sender.value;
        NSArray *loadedTimeRanges = [self.videoPlayer.currentItem loadedTimeRanges];
        // 获取缓冲区域
        CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
        //开始的时间
        NSTimeInterval startSeconds = CMTimeGetSeconds(timeRange.start);
        //表示已经缓冲的时间
        NSTimeInterval durationSeconds = CMTimeGetSeconds(timeRange.duration);
        // 计算缓冲总时间
        NSTimeInterval result = startSeconds + durationSeconds;
        NSLog(@"开始:%f,持续:%f,总时间:%f", startSeconds, durationSeconds, result);
        NSLog(@"视频的加载进度是:%%%f", durationSeconds / videoDurationSeconds * 100);
        if(choose>durationSeconds){
            choose = durationSeconds;
        }
        //NSInteger last = [ranges objectAtIndex:ranges.count-1];
        //NSLog(@"value = %@",ranges);
        CMTime time = CMTimeMakeWithSeconds(choose, fps);
        
        
        
        
        [self.videoPlayer seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    }
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
    NSLog(@"createCommentsView");
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
    [self.view.window addSubview:self.commentsView];
    [self.commentText becomeFirstResponder];//让textView成为第一响应者（第一次）这次键盘并未显示出来，（个人觉得这里主要是将commentsView设置为commentText的inputAccessoryView,然后再给一次焦点就能成功显示）
}

-(IBAction)sendBtnClick:(id)sender {
    [self.view endEditing:YES];
    [self.commentsView removeFromSuperview];
    self.editCommentBtn.userInteractionEnabled = YES;
    [self addComment];
}

-(void) addComment {
    /*MyComment *myComment = [[MyComment alloc]initWithComment:[UIImage imageNamed:@"icon_2.png"] authorName:@"huangscar" comment:self.commentText.text likeNum:0 date:[NSDate date]];
    [self.commentText setText:@""];
    [self.commentsList insertObject:myComment atIndex:0];
    [self.commentTableView reloadData];*/
    PostViewModel *viewModel = [[PostViewModel alloc] init];
    if(self.isLogin){
        if(self.isTwo == NO) {
            [viewModel postCommentWith:self.uid vid:self.myVideo.vid text:self.commentText.text success:^(int cid, MyComment * _Nonnull comment) {
                //[self.commentsList addObject:comment ];
                [self.commentsList insertObject:comment atIndex:0];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self.commentText setText:@""];
                    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:2];
                    [self.commentTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                });
            } failure:^(NSError * _Nonnull error) {
                NSLog(@"请求失败 error:%@",error.description);
            }];
        }
        else {
            int cid;
            if(self.commentTwoView != nil) {
                cid = self.commentTwoView.choosenComment.cid;
            }
            [viewModel postCommentTwoWith:self.uid cid:cid text:self.commentText.text success:^(int cid, MyComment * _Nonnull comment) {
                [self.commentTwoView.commentsListSecond insertObject:comment atIndex:0];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self.commentText setText:@""];
                    //[self.commentTwoView.commentsListSecond addObject:comment];
                    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:1];
                    [self.commentTwoView.commentViewTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                    //[self.commentTwoView.commentViewTableView reloadData];
                });
            } failure:^(NSError * _Nonnull error) {
                NSLog(@"请求失败 error:%@",error.description);
            }];
        }
    }
    else {
        Toast *toast = [[Toast alloc] init];
        [toast popUpToastWithMessage:@"请先登录"];
    }
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

- (void)loadRecommendationData {
    VideoListViewModel *viewModel = [[VideoListViewModel alloc] init];
    int randNum = (arc4random() % 43) + 5;
    [viewModel getFeedsListWithOffset:randNum size:3 success:^(NSMutableArray * _Nonnull dataArray) {
        [self.recommendationVideoList addObjectsFromArray:dataArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:1];
            [self.commentTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        });
        [self loadMoreData];
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)loadMoreData {
    NSLog(@"loadMoreData");
    self.isLoading = YES;
    CommentIDViewModel *viewModel = [[CommentIDViewModel alloc] init];
    [viewModel getFeedsListWithID:self.myVideo.vid offset:self.offset size:5 success:^(NSMutableArray * _Nonnull dataArray) {
        if(dataArray.count == self.commentsList.count) {
            self.hasMore = NO;
        }
        else {
            self.hasMore = YES;
        }
        if (dataArray != nil && dataArray.count > self.commentsList.count) {
            //[self.commentsList addObjectsFromArray:dataArray];
            if(self.commentsList.count > 0) {
                int count = self.commentsList.count;
                int minID = self.commentsList[count-1].cid;
                int maxID = self.commentsList[0].cid;
                NSPredicate *backApredicate = [NSPredicate predicateWithFormat:@"cid<=%ld AND cid>=%ld",maxID, minID-10];
                //NSPredicate *beforeApredicate = [NSPredicate predicateWithFormat:@"cid>%ld", maxID];
                /*if(beforeApredicate != nil) {
                    NSArray *beforeArray = [dataArray filteredArrayUsingPredicate:beforeApredicate];
                    if(beforeArray.count > 0) {
                        NSRange range = NSMakeRange(0, beforeArray.count);
                        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
                        [self.commentsList insertObjects:beforeArray atIndexes:indexSet];
                    }
                }*/
                if(backApredicate != nil) {
                    NSArray *afterArray = [dataArray filteredArrayUsingPredicate:backApredicate];
                    if(afterArray.count > 0) {
                        [self.commentsList removeAllObjects];
                        [self.commentsList addObjectsFromArray:afterArray];
                    }
                }
            }
            else {
                int count = dataArray.count < 5 ? dataArray.count : 5;
                for(int i = 0; i < count; i++) {
                    [self.commentsList addObject:dataArray[i]];
                }
            }
        }
        NSLog(@"count: %d", self.commentsList.count);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:2];
            [self.commentTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            //[self.commentTableView reloadData];
            [self.commentTableView.mj_footer endRefreshing];
            self.isLoading = NO;
            self.offset = self.commentsList.count;
        });
    } failure:^(NSError * _Nonnull error) {
        [self.commentTableView.mj_footer endRefreshing];
        self.isLoading = NO;
    }];
}

- (void)loadNewData {
    NSLog(@"loadNewData");
    self.isLoading = YES;
    CommentIDViewModel *viewModel = [[CommentIDViewModel alloc] init];
    [viewModel getFeedsListWithID:self.myVideo.vid offset:self.offset size:5 success:^(NSMutableArray * _Nonnull dataArray) {
        if(dataArray.count == self.commentsList.count) {
            self.hasMore = NO;
        }
        else {
            self.hasMore = YES;
        }
        if (dataArray != nil && dataArray.count > self.commentsList.count) {
            //[self.commentsList addObjectsFromArray:dataArray];
            if(self.commentsList.count > 0) {
                int count = self.commentsList.count;
                int minID = self.commentsList[count-1].cid;
                //int maxID = self.commentsList[0].cid;
                //NSPredicate *backApredicate = [NSPredicate predicateWithFormat:@"cid<%ld AND cid>=%ld",minID, minID-10];
                NSPredicate *beforeApredicate = [NSPredicate predicateWithFormat:@"cid>%ld", minID];
                if(beforeApredicate != nil) {
                    NSArray *beforeArray = [dataArray filteredArrayUsingPredicate:beforeApredicate];
                    if(beforeArray.count > 0) {
                        [self.commentsList removeAllObjects];
                        [self.commentsList addObjectsFromArray:beforeArray];
                    }
                }
                /*if(backApredicate != nil) {
                    NSArray *afterArray = [dataArray filteredArrayUsingPredicate:backApredicate];
                    if(afterArray.count > 0) {
                        [self.commentsList addObjectsFromArray:afterArray];
                    }
                }*/
            }
            else {
                int count = dataArray.count < 5 ? dataArray.count : 5;
                for(int i = 0; i < count; i++) {
                    [self.commentsList addObject:dataArray[i]];
                }
            }
        }
        NSLog(@"count: %d", self.commentsList.count);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:2];
            [self.commentTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            //[self.commentTableView reloadData];
            [self.commentTableView.mj_header endRefreshing];
            self.isLoading = NO;
            self.offset = self.commentsList.count;
        });
    } failure:^(NSError * _Nonnull error) {
        [self.commentTableView.mj_footer endRefreshing];
        self.isLoading = NO;
    }];
    //[self.detailCell loadNewLikeNum];
    PostViewModel* viewModel2 = [[PostViewModel alloc] init];
    [viewModel2 getLikeNumWithUid:self.uid vid:self.myVideo.vid success:^(int likeNumGet) {
        self.myVideo.likeNum = likeNumGet;
    } failure:^(NSError * _Nonnull error) {
    
    }];
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    VideoDetailTableViewCell *cell = (VideoDetailTableViewCell *)[self.commentTableView cellForRowAtIndexPath:path];
    [cell loadNewLikeNum];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [self.commentsView removeFromSuperview];
    self.editCommentBtn.userInteractionEnabled = YES;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        return 1;
    }
    else if(section == 1){
        return self.recommendationVideoList.count;
        //return 2;
    }
    else {
        return self.commentsList.count; // 增加的1为加载更多
    }
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSInteger cellType;
    UITableViewCell* cell;
    if([tableView isEqual:self.commentTableView]) {
        if(indexPath.section == 1) {
            cellType = self.recommendationVideoList[indexPath.row].cellType;
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
            if(cellType == 1) {
                cell = [[RecommendationVideoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellTypeString];
                [(RecommendationVideoTableViewCell*)cell setCellData:self.recommendationVideoList[indexPath.row]];
                //cell.cellD
            }
            else if(cellType == 2) {
                cell = [[CommentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellTypeString];
                NSLog(@"indexPath.row=%ld", indexPath.row);
                [(CommentTableViewCell*)cell setCellData:self.commentsList[indexPath.row]];
            }
            else if(cellType == 3) {
                cell = [[VideoDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellTypeString];
                [(VideoDetailTableViewCell*)cell setCellData:self.myVideo];
                VideoDetailTableViewCell *vcell = (VideoDetailTableViewCell*) cell;
                vcell.delegate = self;
                self.delegate = cell.self;
            }
        } else {
            if(cellType == 1) {
                [(RecommendationVideoTableViewCell*)cell setCellData:self.recommendationVideoList[indexPath.row]];
            }
            else if(cellType == 2) {
                [(CommentTableViewCell*)cell setCellData:self.commentsList[indexPath.row]];
            }
            else if(cellType == 3) {
                [(VideoDetailTableViewCell*)cell setCellData:self.myVideo];
                VideoDetailTableViewCell* vcell = (VideoDetailTableViewCell*) cell;
                vcell.delegate = self;
            }
        }
    }
    
    
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSLog(@"didSelectRowAtIndexPath:%@", indexPath);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if([tableView isEqual:self.commentTableView]) {
        if (indexPath.section == 1) {
            // 跳转
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            NSString *cellType = cell.reuseIdentifier;
            if([cellType isEqualToString:@"cellType:1"]) {
                VideoDetailViewController *videoDetailViewController = [[VideoDetailViewController alloc] init];
                videoDetailViewController.myVideo = self.recommendationVideoList[indexPath.row];
                [self.navigationController pushViewController:videoDetailViewController animated:NO];
            }
        }
        else if (indexPath.section == 2) {
            CommentTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            _choosenComment = cell.data;
            /*NSArray* commentPart = [self loadComment:1];
             self.commentsListSecond = [NSMutableArray arrayWithArray:commentPart];
             self.pageIndexSecond = 0;*/
            if(self.commentTwoView == nil) {
                self.commentTwoView = [[CommentsView alloc] init];
                self.commentTwoView.delegate = self;
            }
            [self.commentTwoView setCommentData:self.choosenComment];
            [self.view addSubview:self.commentTwoView];
            [self.commentTwoView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.videoView.bottom);
                make.bottom.equalTo(self.footToolBar.top);
                make.left.equalTo(self.view);
                make.right.equalTo(self.view);
            }];
            self.isTwo = YES;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if([tableView isEqual:self.commentTableView]) {
        if(indexPath.section == 1) {
            return 100;
        }
        else if(indexPath.section == 0){
            return [self.myVideo getHeight] + 160;
        }
        return self.commentsList[indexPath.row].height;
    }
    return 10;
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

/*- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"willSelectRowAtIndexPath:%@", indexPath);
    if (indexPath.row == self.commentsList.count - 1 && self.isLoading == NO && _hasMore == YES) {
        [self loadMoreData];
    }
}*/

- (void)videoLikeBtnDelegate:(VideoDetailTableViewCell *)cell{
    PostViewModel *viewModel = [[PostViewModel alloc] init];
    if(self.isLogin) {
        /*[viewModel getIsLikeWithUid:self.uid vid:self.myVideo.vid success:^(BOOL isLike) {
            self.myVideo.isLike = isLike;
            dispatch_async(dispatch_get_main_queue(), ^{
                if(isLike) {
                    [self.likeBarBtn setImage:[UIImage imageNamed:@"like-fill_25.png"] forState:UIControlStateNormal];
                }
                else {
                    [self.likeBarBtn setImage:[UIImage imageNamed:@"like_25.png"] forState:UIControlStateNormal];
                }
            });
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"请求失败 error:%@",error.description);
        }];*/
        self.myVideo.isLike = !self.myVideo.isLike;
        if(self.myVideo.isLike) {
            [self.likeBarBtn setImage:[UIImage imageNamed:@"like-fill_25.png"] forState:UIControlStateNormal];
        }
        else {
            [self.likeBarBtn setImage:[UIImage imageNamed:@"like_25.png"] forState:UIControlStateNormal];
        }
    }
    else {
        Toast *toast = [[Toast alloc] init];
        [toast popUpToastWithMessage:@"请先登录"];
    }
}

- (void)closeCommentsViewBtnDelegate:(CommentsView *)view{
    self.isTwo = NO;
}

- (void)likeBarBtnClick:(UIButton*) button {
    PostViewModel *viewModel = [[PostViewModel alloc] init];
    if(self.isLogin) {
        [viewModel likeVideoWithUid:self.uid vid:self.myVideo.vid success:^(BOOL isLikeGet, int likeNumGet) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(isLikeGet) {
                    [self.likeBarBtn setImage:[UIImage imageNamed:@"like-fill_25.png"] forState:UIControlStateNormal];
                }
                else {
                    [self.likeBarBtn setImage:[UIImage imageNamed:@"like_25.png"] forState:UIControlStateNormal];
                }
                //[self.likeBarBtn setTitle:[NSString stringWithFormat:@"%d", likeNumGet] forState:UIControlStateNormal];
            });
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"请求失败 error:%@",error.description);
        }];
        if (_delegate && [_delegate respondsToSelector:@selector(videoLikeBarBtnDelegate:)]){
            //[self.startBtn removeFromSuperview];
            [_delegate videoLikeBarBtnDelegate:self];
        }
    }
    else {
        Toast *toast = [[Toast alloc] init];
        [toast popUpToastWithMessage:@"请先登录"];
    }
}

-(void)starBtnClick:(UIButton*) button {
    PostViewModel *viewModel = [[PostViewModel alloc] init];
    if(self.isLogin){
        [viewModel starVideoWithUid:self.uid vid:self.myVideo.vid success:^(BOOL isStarGet) {
            self.myVideo.isStar = isStarGet;
            dispatch_async(dispatch_get_main_queue(), ^{
                if(isStarGet) {
                    [self.starBtn setImage:[UIImage imageNamed:@"star_on.png"] forState:UIControlStateNormal];
                }
                else {
                    [self.starBtn setImage:[UIImage imageNamed:@"star_25.png"] forState:UIControlStateNormal];
                }
            });
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"请求失败 error:%@",error.description);
        }];
    }
    else {
        Toast *toast = [[Toast alloc] init];
        [toast popUpToastWithMessage:@"请先登录"];
    }
}

@end
