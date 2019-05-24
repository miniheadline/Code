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

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic) NSInteger numOfHeadline;
@property (nonatomic) NSInteger numOfAttention;
@property (nonatomic) NSInteger numOfFans;
@property (nonatomic) NSInteger numOfLike;
@property (nonatomic, strong) UIImage *photo;

+ (instancetype)testUser;

@end

NS_ASSUME_NONNULL_END
