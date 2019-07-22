//
//  VideoTableViewCell.m
//  MiniHeadline
//
//  Created by huangscar on 2019/4/29.
//  Copyright © 2019 Booooby. All rights reserved.
//
// 定义这个常量，就可以不用在开发过程中使用mas_前缀。
#define MAS_SHORTHAND
// 定义这个常量，就可以让Masonry帮我们自动把基础数据类型的数据，自动装箱为对象类型。
#define MAS_SHORTHAND_GLOBALS
#import "VideoTableViewCell.h"
#import "MyVideo.h"
#import "Masonry.h"


@interface VideoTableViewCell()

//@property (strong, nonatomic)  UIButton *pauseBtn;
@property (strong, nonatomic)  UIButton *icon;
@property (strong, nonatomic)  UILabel *name;
//@property (strong, nonatomic)  UIButton *followBtn;
@property (strong, nonatomic)  UIButton *commentBtn;
@property (strong, nonatomic)  UIButton *shareBtn;
@property (strong, nonatomic) UIImageView *pic;
@property (strong, nonatomic) UIView *upLine;
@property (strong, nonatomic) UIView *leftLine;
@property (strong, nonatomic) UIView *downLine;
@property (strong, nonatomic) UIView *rightLine;
//@property (nonatomic, strong) AVPlayer* videoPlayer;
//@property (nonatomic, strong) AVPlayerLayer *video;
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
        [self setSubview];
    }
    return self;
}

- (void)initSubView {
    CGRect screenBound = [UIScreen mainScreen].bounds;
    self.videoView = [[UIView alloc] init];
    //[self.videoView setFrame:CGRectMake(0, 0, 414, 215)];
    
    [self.contentView addSubview:self.videoView];
    [self.videoView setFrame:CGRectMake(0, 0, screenBound.size.width, 215)];
    self.upLine = [[UIView alloc] init];
    self.downLine = [[UIView alloc] init];
    self.leftLine = [[UIView alloc] init];
    self.rightLine = [[UIView alloc] init];
    /*[self.upLine setBackgroundColor:[UIColor blackColor]];
    [self.upLine setAlpha:0.5];
    [self.downLine setBackgroundColor:[UIColor blackColor]];
    [self.downLine setAlpha:0.5];
    [self.leftLine setBackgroundColor:[UIColor blackColor]];
    [self.leftLine setAlpha:0.5];
    [self.rightLine setBackgroundColor:[UIColor blackColor]];
    [self.rightLine setAlpha:0.5];*/
    self.titleLabel = [[UILabel alloc] init];
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    [self.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:17]];
    //[self.contentView addSubview:self.titleLabel];
    //[self.titleLabel setFrame:CGRectMake(21, 11, 414, 21)];
    
    /*self.pauseBtn = [[UIButton alloc] init];
    [self.pauseBtn setFrame:CGRectMake(21, 183, 32, 32)];
    self.pauseBtn.hidden = YES;
    [self.pauseBtn addTarget:self action:@selector(pauseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.pauseBtn setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];*/
    self.pic = [[UIImageView alloc] init];
    [self.videoView addSubview:self.pic];
    self.shadowImage = [[UIImageView alloc] init];
    [self.shadowImage setImage:[UIImage imageNamed:@"shadow.png"]];
    //[self.shadowImage setAlpha:0.05];
    self.shadowImage.frame = self.videoView.frame;
    [self.videoView addSubview:self.shadowImage];
    /*[self.videoView addSubview:self.upLine];
    [self.videoView addSubview:self.downLine];
    [self.videoView addSubview:self.leftLine];
    [self.videoView addSubview:self.rightLine];*/
    [self.pic setFrame:self.videoView.frame];
    self.startBtn = [[UIButton alloc] init];
    [self.startBtn addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    //[self.startBtn setFrame:CGRectMake(194, 91, 32, 32)];
    [self.startBtn setBackgroundImage:[UIImage imageNamed:@"play_list.png"] forState:UIControlStateNormal];
    [self.videoView addSubview:self.startBtn];
    self.icon = [[UIButton alloc] init];
    //[self.icon setFrame:CGRectMake(16, 255, 30, 30)];
    [self.contentView addSubview:self.icon];
    self.name = [[UILabel alloc] init];
    [self.contentView addSubview:self.name];
    /*self.followBtn = [[UIButton alloc] init];
    [self.followBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.followBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.contentView addSubview:self.followBtn];*/
    self.commentBtn = [[UIButton alloc] init];
    //[self.commentBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    //[self.commentBtn setFrame:CGRectMake(291, 255, 62, 30)];
    //[self.commentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.contentView addSubview:self.commentBtn];
    self.shareBtn = [[UIButton alloc] init];
    [self.shareBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    //[self.shareBtn setFrame:CGRectMake(356, 255, 30, 30)];
    [self.shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.contentView addSubview:self.shareBtn];
    [self.videoView addSubview:self.titleLabel];
    
}

- (void)setSubview {
    CGRect screenBound = [UIScreen mainScreen].bounds;
    /*[self.upLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.videoView.top);
        make.left.equalTo(self.videoView.left);
        make.right.equalTo(self.videoView.right);
        make.width.equalTo(screenBound.size.width);
        make.height.equalTo(10);
    }];
    [self.leftLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.videoView.left);
        make.top.equalTo(self.upLine.bottom);
        make.bottom.equalTo(self.videoView.bottom);
        make.width.equalTo(10);
        make.height.equalTo(205);
    }];
    [self.rightLine makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.videoView.right);
        make.top.equalTo(self.videoView.top);
        make.bottom.equalTo(self.videoView.bottom);
        make.width.equalTo(10);
        make.height.equalTo(215);
    }];
    [self.downLine makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.videoView.bottom);
        make.left.equalTo(self.videoView.left);
        make.right.equalTo(self.videoView.right);
        make.width.equalTo(screenBound.size.width);
        make.height.equalTo(10);
    }];*/
    [self.videoView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top);
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right);
        //make.width.equalTo(screenBound.size.width);
        //make.height.equalTo(215);
        make.size.equalTo(CGSizeMake(screenBound.size.width, 215)).priorityHigh();
    }];
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.videoView.top).with.offset(10);
        make.left.equalTo(self.contentView.left).with.offset(10);
    }];
    
    [self.startBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.videoView.centerX);
        make.centerY.equalTo(self.videoView.centerY);
        make.height.and.width.equalTo(30);
    }];
    [self.icon makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.videoView.bottom).with.offset(10);
        make.left.equalTo(self.contentView.left).with.offset(30);
        make.height.and.width.equalTo(30);
        make.bottom.equalTo(self.contentView).with.offset(-10);
    }];
    [self.name makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.icon.centerY);
        make.left.equalTo(self.icon.right).with.offset(10);
        make.bottom.equalTo(self.contentView).with.offset(-10);
    }];
    /*[self.followBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.icon.centerY);
        make.left.equalTo(self.name.right).with.offset(10);
    }];*/
    
    [self.shareBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.icon.centerY);
        make.right.equalTo(self.right).with.offset(-30);
        make.bottom.equalTo(self.contentView).with.offset(-10);
    }];
    [self.commentBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.icon.centerY);
        make.right.equalTo(self.shareBtn.left).with.offset(-10);
        make.height.and.width.equalTo(25);
        make.bottom.equalTo(self.contentView).with.offset(-10);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 重点代码：contentView的4条边和self对齐
        make.top.left.right.bottom.mas_equalTo(self);
    }];
}

- (void)setCellData:(MyVideo*)cellData{
    self.videoModel = cellData;
    [self.titleLabel setText:cellData.title];
    //NSURL *url = [NSURL URLWithString:cellData.video];
    /*self.videoPlayer = [AVPlayer playerWithURL:url];
    self.video = [AVPlayerLayer playerLayerWithPlayer:self.videoPlayer];
    self.video.frame = self.videoView.bounds;
    [self.videoView.layer addSublayer:self.video];
    [self.videoView addSubview:self.titleLabel];
    [self.videoView addSubview:self.startBtn];
    [self.videoView addSubview:self.pauseBtn];*/
    //[self.commentBtn setTitle:[NSString stringWithFormat:@"%d", cellData.commentNum] forState:UIControlEventTouchUpInside];
    /*NSURL *url = [NSURL URLWithString:cellData.video];
    AVAsset * asset = [AVAsset assetWithURL:url];
    AVAssetImageGenerator * imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    CMTime cmtime = CMTimeMake(1,1);
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:cmtime actualTime:NULL error:NULL];
    UIImage * thumbnail = [UIImage imageWithCGImage:imageRef];*/
    if(self.videoModel.startPic == NULL){
        [self.pic setImage:[UIImage imageNamed:@"white.png"]];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.videoModel getPic];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.pic setImage:self.videoModel.startPic];
            });
        });
    }
    else {
        [self.pic setImage:self.videoModel.startPic];
    }
    
    [self.icon setBackgroundImage:cellData.icon forState:UIControlStateNormal];
    CGRect rect = [cellData.authorName boundingRectWithSize:CGSizeMake(CGFLOAT_MAX - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: self.titleLabel.font} context:nil];
    [self.name setFrame:CGRectMake(61, 260, rect.size.width, 21)];
    [self.name setText:cellData.authorName];
    /*if(cellData.isFollow == NO) {
        //[self.followBtn setFrame:CGRectMake(61+rect.size.width+8, 255, 70, 30)];
        [self.followBtn setTitle:@"follow" forState:UIControlStateNormal];
        [self.followBtn setTitle:@"unfollow" forState:UIControlStateSelected];
    } else {
        //[self.followBtn setFrame:CGRectMake(61+rect.size.width+8, 255, 80, 30)];
        [self.followBtn setTitle:@"unfollow" forState:UIControlStateNormal];
        [self.followBtn setTitle:@"follow" forState:UIControlStateSelected];
    }*/
    //[self.commentBtn setTitle:[NSString stringWithFormat:@" %d", cellData.commentNum] forState:UIControlStateNormal];
    [self.commentBtn setImage:[UIImage imageNamed:@"comment.png"] forState:(UIControlState)UIControlStateNormal];
    [self.shareBtn setTitle:@"∙∙∙" forState:UIControlStateNormal];
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

- (void)playAction:(UIButton *)button{
    if (_delegate && [_delegate respondsToSelector:@selector(cl_tableViewCellPlayVideoWithCell:)]){
        //[self.startBtn removeFromSuperview];
        [_delegate cl_tableViewCellPlayVideoWithCell:self];
    }
}



@end
