//
//  NSComment.h
//  MiniHeadline
//
//  Created by 蔡倓 on 2019/5/10.
//  Copyright © 2019 Booooby. All rights reserved.
//

#ifndef NSComment_h
#define NSComment_h

#import <Foundation/Foundation.h>

@interface NSComment : NSObject

@property (nonatomic, copy) NSString *text; // 内容
@property (nonatomic, copy) NSString *iconUrl; // 头像
@property (nonatomic, copy) NSString *name; // 昵称
@property (nonatomic, copy) NSString *pictureUrl; // 配图

@property int shareNums;
@property int commentNums;
@property int likeNums;

@property (nonatomic, assign) BOOL vip;

- (id)initWithDict:(NSString *)text iconUrl:(NSString*) msg1 username:(NSString*) msg2 picture:(NSString*) msg3 share: (int)num1 comment: (int)num2 like: (int)num3;

@end


#endif /* NSComment_h */
