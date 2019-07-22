//
//  SimpleVideoView.h
//  MiniHeadline
//
//  Created by huangscar on 2019/6/22.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SimpleVideoView : UIView
@property (nonatomic, strong) AVPlayer *videoPlayer;
@property (nonatomic, strong) AVPlayerItem *videoPlayerItem;
@property (nonatomic, strong) AVPlayerLayer *video;
@property (nonatomic, strong) AVURLAsset* urlAsset;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UISlider *videoProgess;
@property (nonatomic, strong) NSTimer *videoTimer;
@property (nonatomic, assign) BOOL isPlay;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) BOOL isBuffering;
- (void) loadVideo;
- (void) destroyPlayer;
- (void) playVideo;
@end

NS_ASSUME_NONNULL_END
