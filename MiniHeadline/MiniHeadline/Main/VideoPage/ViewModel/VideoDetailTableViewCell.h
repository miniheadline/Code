//
//  VideoDetailTableViewCell.h
//  MiniHeadline
//
//  Created by huangscar on 2019/6/11.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Model/MyVideo.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoDetailTableViewCell : UITableViewCell
- (void)setCellData:(MyVideo*) data;
@end

NS_ASSUME_NONNULL_END
