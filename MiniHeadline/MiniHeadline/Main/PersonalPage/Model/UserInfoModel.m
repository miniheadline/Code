//
//  UserInfoModel.m
//  MiniHeadline
//
//  Created by Vicent Zhang on 2019/5/8.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

+ (instancetype)testUser {
    UserInfoModel *model = [[UserInfoModel alloc] init];
    model.username = @"testUser";
    model.password = @"123";
    model.numOfHeadline = 10;
    model.numOfAttention = 100;
    model.numOfFans = 20;
    model.numOfLike = 30;
    model.photo = [UIImage imageNamed:@"logo.png"];
    return model;
}

@end
