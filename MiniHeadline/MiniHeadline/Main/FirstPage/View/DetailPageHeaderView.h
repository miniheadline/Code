//
//  DetailPageHeaderView.h
//  MiniHeadline
//
//  Created by Booooby on 2019/6/3.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailPageHeaderView : UIView

@property (nonatomic, copy) void(^backBtnClick)(void);
@property (nonatomic, copy) void(^searchBtnClick)(void);
@property (nonatomic, copy) void(^moreBtnClick)(void);


- (void)setBackBtnClickWithBlock:(void(^)(void)) backBtnClickBlock;
- (void)setSearchBtnClickWithBlock:(void(^)(void)) searchBtnClickBlock;
- (void)setMoreBtnClickWithBlock:(void(^)(void)) moreBtnClickBlock;

@end

NS_ASSUME_NONNULL_END
