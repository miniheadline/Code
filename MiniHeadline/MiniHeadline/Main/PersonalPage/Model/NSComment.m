//
//  NSComment.m
//  MiniHeadline
//
//  Created by 蔡倓 on 2019/5/10.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSComment.h"

@implementation NSComment

- (id)initWithDict:(NSString *)text iconUrl:(NSString*) msg1 username:(NSString*) msg2 picture:(NSString*) msg3 share: (int)num1 comment: (int)num2 like: (int)num3 {
    
    self.text = text;
    self.iconUrl = msg1;
    self.name = msg2;
    self.pictureUrl = msg3;
    self.shareNums = num1;
    self.commentNums = num2;
    self.likeNums = num3;
    
    return self;
    
}

@end
