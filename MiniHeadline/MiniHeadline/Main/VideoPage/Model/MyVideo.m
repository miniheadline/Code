//
//  MyVideo.m
//  MiniHeadline
//
//  Created by huangscar on 2019/4/26.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import "MyVideo.h"
@interface MyVideo()

@end
@implementation MyVideo
- (instancetype)initWithVideo:(NSString*)title video:(NSString*)video authorName:(NSString*)authorName icon:(UIImage*)icon commentNum:(NSInteger)commentNum isFollow:(BOOL)isFollow
    playNum:(NSInteger)playNum {
    if(self=[super init]) {
        self.title = [title copy];
        self.video = [video copy];
        self.authorName = [authorName copy];
        self.icon = [icon copy];
        self.commentNum = commentNum;
        self.isFollow = isFollow;
        self.cellType = 1;
        self.playNum = playNum;
    }
    return self;
}

-(float) getHeight {
    CGRect rect = [self.detail boundingRectWithSize:CGSizeMake(340, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]} context:nil];
    CGRect rect2 = [self.title boundingRectWithSize:CGSizeMake(340, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:23]} context:nil];
    return rect.size.height+1+rect2.size.height;
}

@end
