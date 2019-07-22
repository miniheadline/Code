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

-(void)getPic {
    dispatch_group_t browseVideo = dispatch_group_create();
    //dispatch_group_enter(browseVideo);
    NSURL *url = [NSURL URLWithString:self.video];
    AVAsset * asset = [AVAsset assetWithURL:url];
    AVAssetImageGenerator * imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    CMTime cmtime = CMTimeMake(1,1);
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:cmtime actualTime:NULL error:NULL];
    UIImage * thumbnail = [UIImage imageWithCGImage:imageRef];
    self.startPic = thumbnail;
    //return self.startPic;
    
}

@end
