//
//  CommentInputView.h
//  MiniHeadline
//
//  Created by Booooby on 2019/6/28.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommentInputView : UIView

@property (nonatomic, copy) void(^commentBtnClick)(NSString *);

- (void)setCommentBtnClick:(void (^)(NSString *))commentBtnClickBlock;

@end

NS_ASSUME_NONNULL_END
