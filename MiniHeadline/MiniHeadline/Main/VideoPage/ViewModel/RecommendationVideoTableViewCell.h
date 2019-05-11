//
//  RecommendationVideoTableViewCell.h
//  MiniHeadline
//
//  Created by huangscar on 2019/5/8.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Model/MyVideo.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecommendationVideoTableViewCell : UITableViewCell
- (void)setCellData:(MyVideo*) data;
@end

NS_ASSUME_NONNULL_END
