//
//  MyComment.h
//  MiniHeadline
//
//  Created by huangscar on 2019/5/3.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyComment : NSObject
@property(nonatomic, strong) UIImage* icon;
@property(nonatomic, strong) NSString* authorName;
@property(nonatomic, strong) NSString* comment;
@property(nonatomic) NSInteger cellType;
@property(nonatomic, assign) NSInteger likeNum;
@property(nonatomic, assign) BOOL isLike;
@property(nonatomic, strong) NSDate *date;
@property(nonatomic, assign) NSInteger height;
- (instancetype)initWithComment:(UIImage*)icon authorName:(NSString*)authorName comment:(NSString*)comment  likeNum:(NSInteger)likeNum isLike:(BOOL)isLike date:(NSDate*)date;
@end

NS_ASSUME_NONNULL_END
