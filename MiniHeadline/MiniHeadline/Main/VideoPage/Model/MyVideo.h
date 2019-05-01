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
@property(nonatomic, strong) AVPlayer* video;
@property(nonatomic) NSInteger cellType;
@property(nonatomic, assign) NSInteger commentNum;
@property(nonatomic, assign) BOOL isFollow;
- (instancetype)initWithVideo:(NSString*)title video:(AVPlayer*)video authorName:(NSString*)authorName icon:(UIImage*)icon commentNum:(NSInteger)commentNum isFollow:(BOOL)isFollow;

@end

NS_ASSUME_NONNULL_END
