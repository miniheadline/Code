//
//  VideoDetailViewController.h
//  MiniHeadline
//
//  Created by huangscar on 2019/4/27.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyVideo.h"

NS_ASSUME_NONNULL_BEGIN

@class VideoDetailViewController;

@protocol VideoDetailViewControllerDelegate <NSObject>

- (void)videoLikeBarBtnDelegate:(VideoDetailViewController *)controller;

@end

@interface VideoDetailViewController : UIViewController
@property (nonatomic, strong) MyVideo* myVideo;
@property (nonatomic, weak) id <VideoDetailViewControllerDelegate> delegate;
- (void)setData;
@end

NS_ASSUME_NONNULL_END
