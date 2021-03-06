//
//  MyVideo.h
//  MiniHeadline
//
//  Created by huangscar on 2019/4/26.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyVideo : NSObject
@property(nonatomic, strong) NSString* title;
@property(nonatomic, strong) UIImage* icon;
@property(nonatomic, strong) NSString* authorName;
@property(nonatomic, strong) NSString* video;
@property(nonatomic) NSInteger cellType;
@property(nonatomic, assign) NSInteger commentNum;
@property(nonatomic, assign) BOOL isFollow;
@property(nonatomic, assign) NSInteger playNum;
@property(nonatomic, assign) int vid;
@property(nonatomic, strong) NSString *detail;
@property(nonatomic, assign) float height;
@property(nonatomic, assign) int likeNum;
@property(nonatomic, assign) BOOL isLike;
@property(nonatomic, assign) BOOL isStar;
@property(nonatomic, strong) UIImage *startPic;
- (instancetype)initWithVideo:(NSString*)title video:(NSString*)video authorName:(NSString*)authorName icon:(UIImage*)icon commentNum:(NSInteger)commentNum isFollow:(BOOL)isFollow
    playNum:(NSInteger)playNum;
- (float) getHeight;
- (void) getPic;

@end

NS_ASSUME_NONNULL_END
