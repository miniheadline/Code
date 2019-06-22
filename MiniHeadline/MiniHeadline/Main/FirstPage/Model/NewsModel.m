//
//  NewsModel.m
//  MiniHeadline
//
//  Created by Booooby on 2019/4/23.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import "NewsModel.h"

@implementation NewsModel

+ (instancetype)initWithTitle:(NSString *)title type:(int)type groupID:(NSString *)groupID offset:(NSInteger)offset {
    NewsModel *cellModel = [[NewsModel alloc] init];
    cellModel.title = title;
    cellModel.publisher = @"中山大学";
    cellModel.comments = @"432评论";
    cellModel.time = @"5小时前";
    cellModel.groupID = groupID;
    cellModel.offset = offset;
    cellModel.type = type;
    return cellModel;
}

+ (instancetype)initWithTitle:(NSString *)title type:(int)type imagePath:(NSString *)imagePath groupID:(NSString *)groupID offset:(NSInteger)offset {
    NewsModel *cellModel = [[NewsModel alloc] init];
    cellModel.title = title;
    cellModel.publisher = @"中山大学";
    cellModel.comments = @"432评论";
    cellModel.time = @"5小时前";
    cellModel.firstImagePath = imagePath;
    cellModel.groupID = groupID;
    cellModel.offset = offset;
    cellModel.type = type;
    return cellModel;
}

+ (instancetype)initWithTitle:(NSString *)title type:(int)type firstImagePath:(NSString *)firstImagePath secondImagePath:(NSString *)secondImagePath thirdImagePath:(NSString *)thirdImagePath groupID:(NSString *)groupID offset:(NSInteger)offset {
    NewsModel *cellModel = [[NewsModel alloc] init];
    cellModel.title = title;
    cellModel.publisher = @"中山大学";
    cellModel.comments = @"432评论";
    cellModel.time = @"5小时前";
    cellModel.firstImagePath = firstImagePath;
    cellModel.secondImagePath = secondImagePath;
    cellModel.thirdImagePath = thirdImagePath;
    cellModel.groupID = groupID;
    cellModel.offset = offset;
    cellModel.type = type;
    return cellModel;
}

@end
