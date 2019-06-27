//
//  CommentTableViewCell.h
//  MiniHeadline
//
//  Created by huangscar on 2019/5/3.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyComment.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommentTableViewCell : UITableViewCell
@property (nonatomic, assign) GLfloat height;
@property (nonatomic, strong) MyComment *data;
- (void)setCellData:(MyComment*) data;
@end

NS_ASSUME_NONNULL_END
