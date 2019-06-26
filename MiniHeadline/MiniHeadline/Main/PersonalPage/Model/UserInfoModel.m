//
//  UserInfoModel.m
//  MiniHeadline
//
//  Created by Vicent Zhang on 2019/5/8.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel
static UserInfoModel * model;
+ (instancetype)testUser {
    
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        NSLog(@"testssssss");
        model=[[UserInfoModel alloc] init];
        model.uid = -1;
        model.isLogin = NO;
        model.username = @"TestUser";
        model.password = @"123";
        model.birthday = @"yyyy-mm-dd";
        model._description = @"...";
        model.address = @"address";
        model.numOfHeadline = -1;
        model.numOfAttention = 0;
        model.numOfFans = 0;
        model.numOfLike = -1;
        model.pic_url = @"";
    });
    return model;
}

@end
