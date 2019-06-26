//
//  CommentIDViewModel.h
//  MiniHeadline
//
//  Created by huangscar on 2019/6/20.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommentIDViewModel : NSObject
- (void)getFeedsListWithID:(int)idNum offset:(int)offset size:(int)size success:(void (^)(NSMutableArray *dataArray))success failure:(void (^)(NSError *error))failure;
- (void)getCommentListWithID:(int)idNum offset:(int)offset size:(int)size success:(void (^)(NSMutableArray * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure;
@end

NS_ASSUME_NONNULL_END
