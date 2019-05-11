//
//  VideoTableViewCell.h
//  MiniHeadline
//
//  Created by huangscar on 2019/4/29.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "../Model/MyVideo.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoTableViewCell : UITableViewCell
- (void)setCellData:(MyVideo*)myVideo;
@end

NS_ASSUME_NONNULL_END
