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

- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (id)commentWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

@end
