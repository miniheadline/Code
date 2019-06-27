//
//  PostViewModel.h
//  MiniHeadline
//
//  Created by huangscar on 2019/6/24.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyComment.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostViewModel : UIView

- (void)likeVideoWithUid:(int)uid vid:(int)vid success:(void (^)(BOOL, int))success failure:(void (^)(NSError * _Nonnull))failure;
- (void)starVideoWithUid:(int)uid vid:(int)vid success:(void (^)(BOOL))success failure:(void (^)(NSError * _Nonnull))failure;
- (void)getIsLikeWithUid:(int)uid vid:(int)vid success:(void (^)(BOOL))success failure:(void (^)(NSError * _Nonnull))failure;
- (void)getLikeNumWithUid:(int)uid vid:(int)vid success:(void (^)(int))success failure:(void (^)(NSError * _Nonnull))failure;
- (void)getIsStarWithUid:(int)uid vid:(int)vid success:(void (^)(BOOL))success failure:(void (^)(NSError * _Nonnull))failure;
- (void)postCommentWith:(int)uid vid:(int)vid text:(NSString*)text success:(void (^)(int, MyComment*))success failure:(void (^)(NSError * _Nonnull))failure;
- (void)postCommentTwoWith:(int)uid cid:(int)cid text:(NSString*)text success:(void (^)(int, MyComment*))success failure:(void (^)(NSError * _Nonnull))failure;
- (void)browseVideoWithUid:(int)uid vid:(int)vid success:(void (^)(void))success failure:(void (^)(NSError * _Nonnull))failure;
@end

NS_ASSUME_NONNULL_END
