//
//  NewsDetailViewModel.h
//  MiniHeadline
//
//  Created by Booooby on 2019/5/23.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsDetailViewModel : NSObject

- (void)getFeedDetailWithGroupID:(NSString *)groupID success:(void (^)(NSString *content))success failure:(void (^)(NSError *error))failure;

- (void)getIsStarWithUid:(NSInteger)uid nid:(NSInteger)nid success:(void (^)(BOOL isStar))success failure:(void (^)(NSError *error))failure;
- (void)getIsLikeWithUid:(NSInteger)uid nid:(NSInteger)nid success:(void (^)(BOOL isLike))success failure:(void (^)(NSError *error))failure;

- (void)readNewsWithUid:(NSInteger)uid nid:(NSInteger)nid success:(void (^)(void))success failure:(void (^)(NSError *error))failure;
- (void)starNewsWithUid:(NSInteger)uid nid:(NSInteger)nid success:(void (^)(void))success failure:(void (^)(NSError *error))failure;
- (void)likeNewsWithUid:(NSInteger)uid nid:(NSInteger)nid success:(void (^)(void))success failure:(void (^)(NSError *error))failure;

- (void)getCommentsOfNewsWithNid:(NSInteger)nid success:(void (^)(NSMutableArray *))success failure:(void (^)(NSError *error))failure;
- (void)getCommentsOfCommentWithCid:(NSInteger)cid success:(void (^)(NSMutableArray *))success failure:(void (^)(NSError *error))failure;

- (void)addCommentForNewsWithUid:(NSInteger)uid nid:(NSInteger)nid text:(NSString *)text success:(void (^)(NSInteger))success failure:(void (^)(NSError *error))failure;
- (void)addCOmmentForCommentWithUid:(NSInteger)uid pid:(NSInteger)pid text:(NSString *)text success:(void (^)(NSInteger))success failure:(void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
