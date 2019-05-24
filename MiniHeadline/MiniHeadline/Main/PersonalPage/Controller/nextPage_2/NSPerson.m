//
//  NSPerson.m
//  MiniHeadline
//
//  Created by 蔡倓 on 2019/5/18.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSPerson.h"

@implementation NSPerson

- (id)initWithDict:(NSString *)name introduction:(NSString*) msg1 Fans:(NSString*) msg2 picture:(NSString*) msg3 {
    
    self.name = name;
    self.introduction = msg1;
    self.FansNum = msg2;
    self.iconUrl = msg3;
    
    return self;
}

@end


