//
//  VideoTableViewCell.h
//  MiniHeadline
//
//  Created by huangscar on 2019/4/29.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "MyVideo.h"

NS_ASSUME_NONNULL_BEGIN
@class VideoTableViewCell;

@protocol VideoTableViewCellDelegate <NSObject>

- (void)cl_tableViewCellPlayVideoWithCell:(VideoTableViewCell *)cell;

@end

@interface VideoTableViewCell : UITableViewCell
@property (strong, nonatomic)  UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *shadowImage;
@property (strong, nonatomic)  UIView *videoView;
@property (strong, nonatomic)  UIButton *startBtn;
@property (strong, nonatomic) MyVideo *videoModel;
- (void)setCellData:(MyVideo*)myVideo;
@property (nonatomic, weak) id <VideoTableViewCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
