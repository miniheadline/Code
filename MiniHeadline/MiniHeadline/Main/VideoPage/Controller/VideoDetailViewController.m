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

@interface VideoDetailViewController ()
@property (nonatomic, strong) UIView *header;
@property (nonatomic, strong) UIView *footer;

@property (nonatomic, strong) UIView *headerLine;
@property (nonatomic, strong) UIView *footerLine;


@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *videoView;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UISlider *videoProgess;
@property (nonatomic, strong) UIButton *fullScreamBtn;
@property (nonatomic, strong) UIButton *icon;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UIButton *followBtn;
@property (nonatomic, strong) UILabel *moreDetail;
@property (nonatomic, strong) UIButton *likeBtn;
@property (nonatomic, strong) UIButton *unlikeBtn;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) UITableView *commentTableView;

@property (nonatomic, assign) BOOL isPlay;
@property (nonatomic, strong) AVPlayer *videoPlayer;
@property (nonatomic, strong) AVPlayerLayer *video;
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
    [self.backBtn setBackgroundImage:[UIImage imageNamed:@"back_white.png"] forState:UIControlStateNormal];
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
    if(self.myVideo.isFollow == YES) {
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
    self.titleLabel.font = [UIFont systemFontOfSize:25];
    [self.titleLabel setText:self.myVideo.title];
    [self.view addSubview:self.titleLabel];
    self.moreDetail = [[UILabel alloc] initWithFrame:CGRectMake(20, 393, 374, 21)];
    self.moreDetail.font = [UIFont systemFontOfSize:20];
    self.moreDetail.textColor = [UIColor grayColor];
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
    
    
    self.footer = [[UIView alloc] initWithFrame:CGRectMake(0, screenBound.size.height - 60, screenBound.size.width, 60)];
    [self.view addSubview:self.footer];
    
    self.headerLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.header.frame.size.height - 0.5, screenBound.size.width, 0.5)];
    self.headerLine.backgroundColor = [UIColor colorWithHexString:@"#D9D9D9"];
    [self.header addSubview:self.headerLine];
    
    self.footerLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenBound.size.width, 0.5)];
    self.footerLine.backgroundColor = [UIColor colorWithHexString:@"#D9D9D9"];
    [self.footer addSubview:self.footerLine];
}

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
