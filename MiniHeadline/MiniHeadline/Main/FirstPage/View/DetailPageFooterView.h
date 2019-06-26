//
//  DetailPageFooterView.h
//  MiniHeadline
//
//  Created by Booooby on 2019/6/4.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailPageFooterView : UIView

@property (nonatomic, copy) void(^writeViewClick)(void);
@property (nonatomic, copy) void(^commentBtnClick)(void);
@property (nonatomic, copy) BOOL(^starBtnClick)(void);
@property (nonatomic, copy) BOOL(^likeBtnClick)(void);

- (void)setWriteViewClick:(void (^)(void))writeViewClickBlock;
- (void)setCommentBtnClick:(void (^)(void))commentBtnClickBlock;
- (void)setStarBtnClick:(BOOL (^)(void))starBtnClickBlock;
- (void)setLikeBtnClick:(BOOL (^)(void))likeBtnClickBlock;

- (void)setStarBtnStateWithIsStar:(BOOL)isStar;
- (void)setLikeBtnStateWithIsLike:(BOOL)isLike;

@end

NS_ASSUME_NONNULL_END
