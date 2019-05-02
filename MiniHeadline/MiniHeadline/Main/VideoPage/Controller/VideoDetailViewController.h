//
//  VideoDetailViewController.h
//  MiniHeadline
//
//  Created by huangscar on 2019/4/27.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Model/MyVideo.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoDetailViewController : UIViewController
@property (nonatomic, strong) MyVideo* myVideo;
@end

NS_ASSUME_NONNULL_END
