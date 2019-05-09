//
//  VideoTableViewCell.m
//  MiniHeadline
//
//  Created by huangscar on 2019/4/29.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import "VideoTableViewCell.h"
#import "../Model/MyVideo.h"

@interface VideoTableViewCell()
@property (strong, nonatomic)  UILabel *titleLabel;
@property (strong, nonatomic)  UIView *videoView;
@property (strong, nonatomic)  UIButton *startBtn;
@property (strong, nonatomic)  UIButton *pauseBtn;
@property (strong, nonatomic)  UIButton *icon;
@property (strong, nonatomic)  UILabel *name;
@property (strong, nonatomic)  UIButton *followBtn;
@property (strong, nonatomic)  UIButton *commentBtn;
@property (strong, nonatomic)  UIButton *shareBtn;
@property (nonatomic, strong) AVPlayer* videoPlayer;
@property (nonatomic, strong) AVPlayerLayer *video;
@property (nonatomic, assign) BOOL isPlay;

@end

@implementation VideoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    self.videoView = [[UIView alloc] init];
    [self.videoView setFrame:CGRectMake(0, 0, 414, 215)];
    
    [self.contentView addSubview:self.videoView];
    self.titleLabel = [[UILabel alloc] init];
    [self.titleLabel setFrame:CGRectMake(21, 11, 414, 21)];
    self.pauseBtn = [[UIButton alloc] init];
    [self.pauseBtn setFrame:CGRectMake(21, 183, 32, 32)];
    self.pauseBtn.hidden = YES;
    [self.pauseBtn addTarget:self action:@selector(pauseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.pauseBtn setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    self.startBtn = [[UIButton alloc] init];
    [self.startBtn setFrame:CGRectMake(194, 91, 32, 32)];
    [self.startBtn setBackgroundImage:[UIImage imageNamed:@"video_unselected.png"] forState:UIControlStateNormal];
    [self.startBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.icon = [[UIButton alloc] init];
    [self.icon setFrame:CGRectMake(16, 255, 30, 30)];
    [self.contentView addSubview:self.icon];
    self.name = [[UILabel alloc] init];
    [self.contentView addSubview:self.name];
    self.followBtn = [[UIButton alloc] init];
    [self.followBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.followBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.contentView addSubview:self.followBtn];
    self.commentBtn = [[UIButton alloc] init];
    [self.commentBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.commentBtn setFrame:CGRectMake(291, 255, 62, 30)];
    [self.commentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.contentView addSubview:self.commentBtn];
    self.shareBtn = [[UIButton alloc] init];
    [self.shareBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.shareBtn setFrame:CGRectMake(356, 255, 30, 30)];
    [self.shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.contentView addSubview:self.shareBtn];
}

- (void)setCellData:(MyVideo*)cellData{
    [self.titleLabel setText:cellData.title];
    NSURL *url = [NSURL fileURLWithPath:cellData.video];
    self.videoPlayer = [AVPlayer playerWithURL:url];
    self.video = [AVPlayerLayer playerLayerWithPlayer:self.videoPlayer];
    self.video.frame = self.videoView.bounds;
    [self.videoView.layer addSublayer:self.video];
    [self.videoView addSubview:self.titleLabel];
    [self.videoView addSubview:self.startBtn];
    [self.videoView addSubview:self.pauseBtn];
    [self.icon setBackgroundImage:cellData.icon forState:UIControlStateNormal];
    CGRect rect = [cellData.authorName boundingRectWithSize:CGSizeMake(CGFLOAT_MAX - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: self.titleLabel.font} context:nil];
    [self.name setFrame:CGRectMake(61, 260, rect.size.width, 21)];
    [self.name setText:cellData.authorName];
    if(cellData.isFollow == NO) {
        [self.followBtn setFrame:CGRectMake(61+rect.size.width+8, 255, 70, 30)];
        [self.followBtn setTitle:@"follow" forState:UIControlStateNormal];
        [self.followBtn setTitle:@"unfollow" forState:UIControlStateSelected];
    } else {
        [self.followBtn setFrame:CGRectMake(61+rect.size.width+8, 255, 80, 30)];
        [self.followBtn setTitle:@"unfollow" forState:UIControlStateNormal];
        [self.followBtn setTitle:@"follow" forState:UIControlStateSelected];
    }
    [self.commentBtn setTitle:[NSString stringWithFormat:@" %d", cellData.commentNum] forState:UIControlStateNormal];
    [self.commentBtn setImage:[UIImage imageNamed:@"comment.png"] forState:(UIControlState)UIControlStateNormal];
    [self.shareBtn setTitle:@"∙∙∙" forState:UIControlStateNormal];
}
- (IBAction)playBtnClick:(id)sender {
    [self.videoPlayer play];
    self.startBtn.hidden = YES;
    self.pauseBtn.hidden = NO;
    _isPlay = YES;
}
- (IBAction)pauseBtnClick:(id)sender {
    if(self.isPlay == YES) {
        [self.videoPlayer pause];
        [self.pauseBtn setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        self.isPlay = NO;
    }
    else {
        [self.videoPlayer play];
        [self.pauseBtn setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        self.isPlay = YES;
    }
}
- (IBAction)iconClick:(id)sender {
    //进入用户详情页面
}
- (IBAction)followClick:(id)sender {
    //更改关注
    
}
- (IBAction)commentClick:(id)sender {
    //进入详情页面
    
}
- (IBAction)shareClick:(id)sender {
    //分享
    
}

@end
