//
//  CommentTwoTableViewCell.h
//  MiniHeadline
//
//  Created by huangscar on 2019/6/26.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Model/MyComment.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommentTwoTableViewCell : UITableViewCell
@property (nonatomic, assign) GLfloat height;
@property (nonatomic, strong) MyComment *data;
- (void)setCellData:(MyComment*) data username:(MyComment*)username;
@end

NS_ASSUME_NONNULL_END
