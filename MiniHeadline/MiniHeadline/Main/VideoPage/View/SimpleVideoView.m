//
//  SimpleVideoView.m
//  MiniHeadline
//
//  Created by huangscar on 2019/6/22.
//  Copyright © 2019 Booooby. All rights reserved.
//
// 定义这个常量，就可以不用在开发过程中使用mas_前缀。
#define MAS_SHORTHAND
// 定义这个常量，就可以让Masonry帮我们自动把基础数据类型的数据，自动装箱为对象类型。
#define MAS_SHORTHAND_GLOBALS
#import "SimpleVideoView.h"
#import "Masonry.h"

@implementation SimpleVideoView

- (instancetype) initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self initSubview];
        self.isPlay = false;
    }
    return self;
}

- (void) initSubview {
    self.playBtn = [[UIButton alloc] init];
    //self.playBtn = [[UIButton alloc] initWithFrame:CGRectMake(19, 219, 25, 25)];
    [self.playBtn setBackgroundImage:[UIImage imageNamed:@"play_white.png"] forState:UIControlStateNormal];
    [self.playBtn addTarget:self action:@selector(pauseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.playBtn];
    self.videoProgess = [[UISlider alloc] init];
    [self addSubview:self.videoProgess];
    [self.videoProgess addTarget:self action:@selector(progessChange:) forControlEvents:UIControlEventValueChanged];
    __weak typeof(self) weakSelf = self;
    self.videoTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timer) userInfo:nil repeats:YES];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self setBackgroundColor:[UIColor blackColor]];
    
    [self.playBtn makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottom).with.offset(-10);
        make.left.equalTo(self.left).with.offset(10);
        make.width.and.height.equalTo(30);
    }];
    [self.videoProgess makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playBtn.right).with.offset(10);
        make.right.equalTo(self.right).with.offset(-10);
        make.centerY.equalTo(self.playBtn.centerY);
    }];
    
}

- (void)timer {
    self.videoProgess.value = CMTimeGetSeconds(self.videoPlayer.currentItem.currentTime) / CMTimeGetSeconds(self.videoPlayer.currentItem.duration);
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

-(void) loadVideo {
    [self reloadURL];
    NSURL *url = [NSURL URLWithString:self.url];
    self.videoPlayerItem = [[AVPlayerItem alloc] initWithURL:url];
    self.videoPlayer = [[AVPlayer alloc] initWithPlayerItem:self.videoPlayerItem];
    self.urlAsset = [AVURLAsset assetWithURL:url];
    [self.videoPlayer.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    [self.videoPlayer.currentItem addObserver:self
                 forKeyPath:@"playbackBufferEmpty"
                    options:NSKeyValueObservingOptionNew
                    context:nil];
    self.video = [AVPlayerLayer playerLayerWithPlayer:self.videoPlayer];
    [self.layer addSublayer:self.video];
    //self.video.frame = self.frame;
    [self.video setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-5)];
    [self.playBtn removeFromSuperview];
    [self.videoProgess removeFromSuperview];
    [self addSubview:self.playBtn];
    [self addSubview:self.videoProgess];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
        // 当缓冲是空的时候
        if (self.videoPlayer.currentItem.isPlaybackBufferEmpty) {
            [self bufferingSomeSecond];
        }
    }
}

- (void)bufferingSomeSecond{
    _isBuffering = NO;
    if (_isBuffering){
        return;
    }
    _isBuffering = YES;
    // 需要先暂停一小会之后再播放，否则网络状况不好的时候时间在走，声音播放不出来
    [self.videoPlayer pause];
    //延迟执行
    [self performSelector:@selector(bufferingSomeSecondEnd)
               withObject:@"Buffering"
               afterDelay:5];
}
//卡顿缓冲结束
- (void)bufferingSomeSecondEnd{
    [self playVideo];
    // 如果执行了play还是没有播放则说明还没有缓存好，则再次缓存一段时间
    _isBuffering = NO;
    if (!self.videoPlayerItem.isPlaybackLikelyToKeepUp) {
        [self bufferingSomeSecond];
    }
}

- (void) destroyPlayer {
    [self.videoPlayer pause];
    self.videoPlayer = nil;
    //移除
    [self.video removeFromSuperlayer];
    [self removeFromSuperview];
    self.videoProgess.value = 0.0;
    self.isPlay = false;
}

-(void)playVideo {
    [self.videoPlayer play];
    self.isPlay = true;
    [self.playBtn setBackgroundImage:[UIImage imageNamed:@"pause _white.png"] forState:UIControlStateNormal];
}

-(void)reloadURL{
    [self.videoPlayer pause];
    self.videoPlayer = nil;
    self.videoProgess.value = 0.0;
    self.isPlay = false;
    [self.video removeFromSuperlayer];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
@end
