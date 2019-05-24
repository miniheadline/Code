//
//  UserLoginController.h
//  MiniHeadline
//
//  Created by Vicent Zhang on 2019/5/15.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol sender <NSObject>

- (void)send:(BOOL)isLogin;

@end

@interface UserLoginController : UIViewController

@property(nonatomic, weak)id <sender>delegate;

@end



NS_ASSUME_NONNULL_END
