//
//  NSPerson.h
//  MiniHeadline
//
//  Created by 蔡倓 on 2019/5/17.
//  Copyright © 2019 Booooby. All rights reserved.
//

#ifndef NSPerson_h
#define NSPerson_h

#import <Foundation/Foundation.h>

@interface NSPerson : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *introduction;
@property (nonatomic, copy) NSString *FansNum;

@property (nonatomic, copy) NSString *iconUrl;


@property int shareNums;
@property int commentNums;
@property int likeNums;

@property (nonatomic, assign) BOOL vip;

- (id)initWithDict:(NSString *)name introduction:(NSString*) msg1 Fans:(NSString*) msg2 picture:(NSString*) msg3;

@end


#endif /* NSPerson_h */
