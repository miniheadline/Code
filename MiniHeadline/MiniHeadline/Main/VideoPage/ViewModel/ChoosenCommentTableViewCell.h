//
//  ChoosenCommentTableViewCell.h
//  MiniHeadline
//
//  Created by huangscar on 2019/5/24.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Model/MyComment.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChoosenCommentTableViewCell : UITableViewCell
- (void)setCellData:(MyComment*) data;
@end

NS_ASSUME_NONNULL_END
