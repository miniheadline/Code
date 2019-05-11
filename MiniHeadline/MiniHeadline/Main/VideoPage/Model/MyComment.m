//
//  MyComment.m
//  MiniHeadline
//
//  Created by huangscar on 2019/5/3.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import "MyComment.h"

@implementation MyComment
- (instancetype)initWithComment:(UIImage*)icon authorName:(NSString*)authorName comment:(NSString*)comment  likeNum:(NSInteger)likeNum isLike:(BOOL)isLike date:(NSDate*)date{
    if(self = [super init]) {
        self.icon = [icon copy];
        self.authorName = [authorName copy];
        self.cellType = 2;
        self.likeNum = likeNum;
        self.isLike = isLike;
        self.date = [date copy];
        self.comment = [comment copy];
        CGRect rect = [comment boundingRectWithSize:CGSizeMake(340, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:25.0]} context:nil];
        NSInteger commentsHeight = ceil(rect.size.height)+1;
        self.height = 133 + commentsHeight - 30;
    }
    return self;
}
@end
