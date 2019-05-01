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
- (instancetype)initWithVideo:(NSString*)title video:(AVPlayer*)video authorName:(NSString*)authorName icon:(UIImage*)icon commentNum:(NSInteger)commentNum isFollow:(BOOL)isFollow {
    if(self=[super init]) {
        self.title = [title copy];
        self.video = [video copy];
        self.authorName = [authorName copy];
        self.icon = [icon copy];
        self.commentNum = commentNum;
        self.isFollow = isFollow;
        self.cellType = 1;
    }
    return self;
}
@end
