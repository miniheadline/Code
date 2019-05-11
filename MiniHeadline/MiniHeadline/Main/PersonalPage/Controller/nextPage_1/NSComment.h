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
@property (nonatomic, copy) NSString *icon; // 头像
@property (nonatomic, copy) NSString *name; // 昵称
@property (nonatomic, copy) NSString *picture; // 配图
@property (nonatomic, assign) BOOL vip;

- (id)initWithDict:(NSDictionary *)dict;
+ (id)commentWithDict:(NSDictionary *)dict;

@end


#endif /* NSComment_h */
