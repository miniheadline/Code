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
#import "../ViewModel/CommentTwoTableViewCell.h"
#import "../ViewModel/ChoosenCommentTableViewCell.h"
#import "../ViewModel/CommentIDViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@class CommentsView;

@protocol CommentsViewDelegate <NSObject>

- (void)closeCommentsViewBtnDelegate:(CommentsView *)view;

@end

@interface CommentsView : UIView
@property (nonatomic, assign) int type;
@property (nonatomic, strong) MyComment *choosenComment;
@property (nonatomic, strong) UITableView *commentViewTableView;
@property (nonatomic, strong) NSMutableArray<MyComment*>* commentsListSecond;
@property (nonatomic, weak) id <CommentsViewDelegate> delegate;
- (void)setCommentData:(MyComment *)choosenComment;
@end

NS_ASSUME_NONNULL_END
