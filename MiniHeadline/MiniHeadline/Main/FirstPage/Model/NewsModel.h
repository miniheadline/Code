//
//  NewsModel.h
//  MiniHeadline
//
//  Created by Booooby on 2019/4/23.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *publisher;
@property (nonatomic, copy) NSString *comments;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *firstImagePath;
@property (nonatomic, copy) NSString *secondImagePath;
@property (nonatomic, copy) NSString *thirdImagePath;
@property (nonatomic, copy) NSString *groupID;

@property (nonatomic) int type; // 0 - noImage, 1 - singleImage, 2 - multiImgae

+ (instancetype)initWithTitle:(NSString *)title type:(int)type groupID:(NSString *)groupID;

+ (instancetype)initWithTitle:(NSString *)title type:(int)type imagePath:(NSString *)imagePath groupID:(NSString *)groupID;

+ (instancetype)initWithTitle:(NSString *)title type:(int)type firstImagePath:(NSString *)firstImagePath secondImagePath:(NSString *)secondImagePath thirdImagePath:(NSString *)thirdImagePath groupID:(NSString *)groupID;

@end

NS_ASSUME_NONNULL_END
