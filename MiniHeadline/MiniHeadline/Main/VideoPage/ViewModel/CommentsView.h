//
//  CommentsView.h
//  MiniHeadline
//
//  Created by huangscar on 2019/6/1.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Model/MyComment.h"
#import "../ViewModel/LoadingTableViewCell.h"
#import "../ViewModel/CommentTableViewCell.h"
#import "../ViewModel/ChoosenCommentTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommentsView : UIView
@property (nonatomic, assign) int type;
@property (nonatomic, strong) MyComment *choosenComment;
- (void)setCommentData:(MyComment *)choosenComment;
@end

NS_ASSUME_NONNULL_END
