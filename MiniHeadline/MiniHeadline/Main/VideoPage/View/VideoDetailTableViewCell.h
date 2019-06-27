//
//  VideoDetailTableViewCell.h
//  MiniHeadline
//
//  Created by huangscar on 2019/6/11.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyVideo.h"
#import "VideoDetailViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class VideoDetailTableViewCell;

@protocol VideoTableViewCellDelegate <NSObject>

- (void)videoLikeBtnDelegate:(VideoDetailTableViewCell *)cell;

@end

@interface VideoDetailTableViewCell : UITableViewCell
- (void)setCellData:(MyVideo*) data;
@property (nonatomic, weak) id <VideoTableViewCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
