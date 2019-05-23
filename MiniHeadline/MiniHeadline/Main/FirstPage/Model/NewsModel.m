//
//  NewsModel.m
//  MiniHeadline
//
//  Created by Booooby on 2019/4/23.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import "NewsModel.h"

@implementation NewsModel

+ (instancetype)initWithTitle:(NSString *)title imagePath:(NSString *)imagePath {
    NewsModel *cellModel = [[NewsModel alloc] init];
    cellModel.title = title;
    cellModel.publisher = @"中山大学";
    cellModel.comments = @"432评论";
    cellModel.time = @"5小时前";
    cellModel.firstImagePath = imagePath;
    return cellModel;
}

@end
