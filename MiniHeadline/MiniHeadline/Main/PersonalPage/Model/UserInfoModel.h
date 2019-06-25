//
//  UserInfoModel.h
//  MiniHeadline
//
//  Created by Vicent Zhang on 2019/5/8.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserInfoModel : NSObject
@property (nonatomic) NSInteger uid;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *_description;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *pic_url;
@property (nonatomic) NSInteger numOfHeadline;
@property (nonatomic) NSInteger numOfAttention;
@property (nonatomic) NSInteger numOfFans;
@property (nonatomic) NSInteger numOfLike;
@property (nonatomic) Boolean isLogin;


+ (instancetype)testUser;

@end

NS_ASSUME_NONNULL_END
