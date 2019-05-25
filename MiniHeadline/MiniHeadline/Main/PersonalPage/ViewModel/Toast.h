//
//  Toast.h
//  MiniHeadline
//
//  Created by Vicent Zhang on 2019/5/24.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @使用方法
 *  [[[Toast alloc] init] popUpToastWithMessage:@"提示内容"];
 */

@interface Toast : UIView

- (void)popUpToastWithMessage:(NSString *)message;

@end
