//
//  PostViewModel.m
//  MiniHeadline
//
//  Created by huangscar on 2019/6/24.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import "PostViewModel.h"

@implementation PostViewModel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)likeVideoWithUid:(int)uid vid:(int)vid success:(void (^)(BOOL, int))success failure:(void (^)(NSError * _Nonnull))failure {
    //1.确定请求路径
    NSString *urlString = [NSString stringWithFormat:@"http://149.28.26.98:8082/miniheadline/UserWithVideo?uid=%d&vid=%d&type=1", uid, vid];
    NSURL *url = [NSURL URLWithString:urlString];
    
    //2.创建请求对象
    //请求对象内部默认已经包含了请求头和请求方法（GET）
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    //4.根据会话对象创建一个Task(发送请求）
    /*
     第一个参数：请求对象
     第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
     data：响应体信息（期望的数据）
     response：响应头信息，主要是对服务器端的描述
     error：错误信息，如果请求失败，则error有值
     */
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_group_t getIsLikeTaskGroup = dispatch_group_create();
        if (error == nil) {
            //6.解析服务器返回的数据
            //说明：（此处返回的数据是JSON格式的，因此使用NSJSONSerialization进行反序列化处理）
            NSString *output = [[NSString alloc] initWithBytes:data.bytes length:data.length encoding:NSUTF8StringEncoding];
            NSLog(@"%@", output);
            if([output isEqualToString:@"success."]) {
                dispatch_group_enter(getIsLikeTaskGroup);
                static BOOL isLike;
                static int likeNum;
                [self getIsLikeWithUid:uid vid:vid success:^(BOOL isLikeGet) {
                    isLike = isLikeGet;
                    dispatch_group_leave(getIsLikeTaskGroup);
                } failure:^(NSError * _Nonnull error) {
                    dispatch_group_leave(getIsLikeTaskGroup);
                }];
                dispatch_group_notify(getIsLikeTaskGroup, dispatch_get_main_queue(), ^{
                     success(isLike, likeNum);
                });
            }
        }
    }];
    
    //5.执行任务
    [dataTask resume];
}

// 收藏
- (void)starVideoWithUid:(int)uid vid:(int)vid success:(void (^)(BOOL))success failure:(void (^)(NSError * _Nonnull))failure {
    //1.确定请求路径
    NSString *urlString = [NSString stringWithFormat:@"http://149.28.26.98:8082/miniheadline/UserWithVideo?uid=%d&vid=%d&type=2", uid, vid];
    NSURL *url = [NSURL URLWithString:urlString];
    
    //2.创建请求对象
    //请求对象内部默认已经包含了请求头和请求方法（GET）
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    //4.根据会话对象创建一个Task(发送请求）
    /*
     第一个参数：请求对象
     第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
     data：响应体信息（期望的数据）
     response：响应头信息，主要是对服务器端的描述
     error：错误信息，如果请求失败，则error有值
     */
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_group_t getIsStarTaskGroup = dispatch_group_create();
        if (error == nil) {
            //6.解析服务器返回的数据
            //说明：（此处返回的数据是JSON格式的，因此使用NSJSONSerialization进行反序列化处理）
            //NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSString *output = [[NSString alloc] initWithBytes:data.bytes length:data.length encoding:NSUTF8StringEncoding];
            NSLog(@"%@", output);
            if([output isEqualToString:@"success."]) {
                dispatch_group_enter(getIsStarTaskGroup);
                static BOOL isStar;
                [self getIsStarWithUid:uid vid:vid success:^(BOOL isStarGet) {
                    isStar = isStarGet;
                    dispatch_group_leave(getIsStarTaskGroup);
                } failure:^(NSError * _Nonnull error) {
                    dispatch_group_leave(getIsStarTaskGroup);
                }];
                dispatch_group_notify(getIsStarTaskGroup, dispatch_get_main_queue(), ^{
                    success(isStar);
                });
            }
        }
    }];
    
    //5.执行任务
    [dataTask resume];
}

// 是否已点赞
- (void)getIsLikeWithUid:(int)uid vid:(int)vid success:(void (^)(BOOL))success failure:(void (^)(NSError * _Nonnull))failure {
    //1.确定请求路径
    NSString *urlString = [NSString stringWithFormat:@"http://149.28.26.98:8082/miniheadline/isUserConnectWithVideo?uid=%d&vid=%d&type=1", uid, vid];
    NSURL *url = [NSURL URLWithString:urlString];
    
    //2.创建请求对象
    //请求对象内部默认已经包含了请求头和请求方法（GET）
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    //4.根据会话对象创建一个Task(发送请求）
    /*
     第一个参数：请求对象
     第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
     data：响应体信息（期望的数据）
     response：响应头信息，主要是对服务器端的描述
     error：错误信息，如果请求失败，则error有值
     */
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error == nil) {
            //6.解析服务器返回的数据
            //说明：（此处返回的数据是JSON格式的，因此使用NSJSONSerialization进行反序列化处理）
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            BOOL status = [[dict objectForKey:@"status"] boolValue];
            success(status);
            NSLog(@"isStar:%@", [dict objectForKey:@"status"]);
        }
    }];
    
    //5.执行任务
    [dataTask resume];
}

// 是否已收藏
- (void)getIsStarWithUid:(int)uid vid:(int)vid success:(void (^)(BOOL))success failure:(void (^)(NSError * _Nonnull))failure {
    //1.确定请求路径
    NSString *urlString = [NSString stringWithFormat:@"http://149.28.26.98:8082/miniheadline/isUserConnectWithVideo?uid=%d&vid=%d&type=2", uid, vid];
    NSURL *url = [NSURL URLWithString:urlString];
    
    //2.创建请求对象
    //请求对象内部默认已经包含了请求头和请求方法（GET）
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    //4.根据会话对象创建一个Task(发送请求）
    /*
     第一个参数：请求对象
     第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
     data：响应体信息（期望的数据）
     response：响应头信息，主要是对服务器端的描述
     error：错误信息，如果请求失败，则error有值
     */
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error == nil) {
            //6.解析服务器返回的数据
            //说明：（此处返回的数据是JSON格式的，因此使用NSJSONSerialization进行反序列化处理）
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            BOOL status = [[dict objectForKey:@"status"] boolValue];
            success(status);
            NSLog(@"isStar:%@", [dict objectForKey:@"status"]);
        }
    }];
    
    //5.执行任务
    [dataTask resume];
}

- (void)getLikeNumWithUid:(int)uid vid:(int)vid success:(void (^)(int))success failure:(void (^)(NSError * _Nonnull))failure {
    //1.确定请求路径
    NSString *urlString = [NSString stringWithFormat:@"http://149.28.26.98:8082/miniheadline/getVideo?uid=%d&vid=%d&type=0", uid, vid];
    NSURL *url = [NSURL URLWithString:urlString];
    
    //2.创建请求对象
    //请求对象内部默认已经包含了请求头和请求方法（GET）
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    //4.根据会话对象创建一个Task(发送请求）
    /*
     第一个参数：请求对象
     第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
     data：响应体信息（期望的数据）
     response：响应头信息，主要是对服务器端的描述
     error：错误信息，如果请求失败，则error有值
     */
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        int likeNum = [[dict objectForKey:@"likeNum"] integerValue];
        success(likeNum);
    }];
    
    //5.执行任务
    [dataTask resume];
}

- (void)postCommentWith:(int)uid vid:(int)vid text:(NSString*)text success:(void (^)(int, MyComment*))success failure:(void (^)(NSError * _Nonnull))failure {
    //1.创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    //2.根据会话对象创建task
    NSURL *url = [NSURL URLWithString:@"http://149.28.26.98:8082/miniheadline/add_videos_comment"];
    
    //3.创建可变的请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //4.修改请求方法为POST
    request.HTTPMethod = @"POST";
    
    //5.设置请求体
    //NSString *arg = [NSString stringWithFormat:@"groupId=%@", groupID];
    //NSLog(@"%@", arg);
    //request.HTTPBody = [arg dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = @{
                           @"uid": [NSNumber numberWithInteger:uid],
                           @"vid": [NSNumber numberWithInteger:vid],
                           @"text": text
                           };
    NSData *data = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
    request.HTTPBody = data;
    
    //6.根据会话对象创建一个Task(发送请求）
    /*
     第一个参数：请求对象
     第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
     data：响应体信息（期望的数据）
     response：响应头信息，主要是对服务器端的描述
     error：错误信息，如果请求失败，则error有值
     */
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"res: %@", res);
        int cid = [[res objectForKey:@"cid"] integerValue];
        [self getCommentWithID:cid success:^(MyComment * _Nonnull comment) {
            success(cid, comment);
        } failure:^(NSError * _Nonnull error) {
            
        }];
        
    }];
    [dataTask resume];
}

- (void)getCommentWithID:(int)idNum success:(void (^)(MyComment * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    //1.创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    //2.根据会话对象创建task
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://149.28.26.98:8082/miniheadline/getComment?cid=%d", idNum]];
    
    //3.创建可变的请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    
    //6.根据会话对象创建一个Task(发送请求）
    /*
     第一个参数：请求对象
     第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
     data：响应体信息（期望的数据）
     response：响应头信息，主要是对服务器端的描述
     error：错误信息，如果请求失败，则error有值
     */
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //8.解析数据
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSString* text = [res objectForKey:@"text"];
        int uid = [[res objectForKey:@"from_uid"] integerValue];
        int replyNum = [[res objectForKey:@"replyNum"] integerValue];
        int likeNum = [[res objectForKey:@"likeNum"] integerValue];
        NSString *time = [res objectForKey:@"time"];
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        //设置时区  全球标准时间CUT 必须设置 我们要设置中国的时区
        NSTimeZone *zone = [[NSTimeZone alloc] initWithName:@"CUT"];
        [formatter setTimeZone:zone];
        NSDate *stringDate = [formatter dateFromString:time];
        
        
        dispatch_group_t downloadTaskGroup = dispatch_group_create();
        dispatch_group_enter(downloadTaskGroup);
        [self getUserWithID:uid success:^(NSString * username, UIImage *icon) {
            //UIImage *pic = [[UIImage alloc] initWithContentsOfFile:picPath];
            MyComment *comment = [[MyComment alloc] initWithComment:icon authorName:username comment:text likeNum:likeNum date:stringDate];
            dispatch_group_leave(downloadTaskGroup);
            success(comment);
        } failure:^(NSError * _Nonnull error) {
            dispatch_group_leave(downloadTaskGroup);
        }];
    }];
    
    //7.执行任务
    [dataTask resume];
}



/*- (void)downloadImageWithURL:(NSString *)url index:(NSString *)index success:(void (^)(NSString *imagePath))success failure:(void (^)(NSError *error))failure {
    //    NSLog(@"%@", url);
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        //下载完成后文件位于location处，我们需要移到沙盒中
        NSString *dirPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *imagePath = [dirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", index]];
        // NSLog(@"%@", imagePath);
        
        NSFileManager *manager = [NSFileManager defaultManager];
        if ([manager fileExistsAtPath:imagePath isDirectory:NO]) {
            [manager removeItemAtPath:imagePath error:nil];
        }
        
        [manager moveItemAtPath:[location path] toPath:imagePath error:nil];
        
        success(imagePath);
    }];
    
    //开始任务
    [task resume];
}*/

- (void)getUserWithID:(int)idNum success:(void (^)(NSString*, UIImage*))success failure:(void (^)(NSError * _Nonnull))failure {
    //1.创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    //2.根据会话对象创建task
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://149.28.26.98:8082/miniheadline/getUser?uid=%d", idNum]];
    
    //3.创建可变的请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    
    //6.根据会话对象创建一个Task(发送请求）
    /*
     第一个参数：请求对象
     第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
     data：响应体信息（期望的数据）
     response：响应头信息，主要是对服务器端的描述
     error：错误信息，如果请求失败，则error有值
     */
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //8.解析数据
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        // 为了确保返回的数据和加载的顺序一致
        NSString* username = [res objectForKey:@"username"];
        UIImage* icon = [UIImage imageNamed:@"default_user.jpg"];
        success(username, icon);
        //NSString* picURL = [res objectForKey:@"pic_url"];
        
        //NSString *index = [NSString stringWithFormat:@"icon_%d", idNum];
        
        //static NSString *picPath;
        /*dispatch_group_t imagesDownloadTaskGroup = dispatch_group_create();
        dispatch_group_enter(imagesDownloadTaskGroup);
        [self downloadImageWithURL:picURL index:index success:^(NSString *imagePath) {
            picPath = [imagePath copy];
            dispatch_group_leave(imagesDownloadTaskGroup);
        } failure:^(NSError *error) {
            dispatch_group_leave(imagesDownloadTaskGroup);
        }];
        dispatch_group_notify(imagesDownloadTaskGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            success(username, picPath);
        });*/
    }];
    
    //7.执行任务
    [dataTask resume];
}

- (void)postCommentTwoWith:(int)uid cid:(int)cid text:(NSString*)text success:(void (^)(int, MyComment*))success failure:(void (^)(NSError * _Nonnull))failure {
    //1.创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    //2.根据会话对象创建task
    NSURL *url = [NSURL URLWithString:@"http://149.28.26.98:8082/miniheadline/add_second_comment"];
    
    //3.创建可变的请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //4.修改请求方法为POST
    request.HTTPMethod = @"POST";
    
    //5.设置请求体
    //NSString *arg = [NSString stringWithFormat:@"groupId=%@", groupID];
    //NSLog(@"%@", arg);
    //request.HTTPBody = [arg dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = @{
                           @"uid": [NSNumber numberWithInteger:uid],
                           @"pid": [NSNumber numberWithInteger:cid],
                           @"text": text
                           };
    NSData *data = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
    request.HTTPBody = data;
    
    //6.根据会话对象创建一个Task(发送请求）
    /*
     第一个参数：请求对象
     第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
     data：响应体信息（期望的数据）
     response：响应头信息，主要是对服务器端的描述
     error：错误信息，如果请求失败，则error有值
     */
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        int cid = [[res objectForKey:@"cid"] integerValue];
        [self getCommentWithID:cid success:^(MyComment * _Nonnull comment) {
            success(cid, comment);
        } failure:^(NSError * _Nonnull error) {
            
        }];
        
    }];
    [dataTask resume];
}

- (void)browseVideoWithUid:(int)uid vid:(int)vid success:(void (^)(void))success failure:(void (^)(NSError * _Nonnull))failure {
    //1.确定请求路径
    NSString *urlString = [NSString stringWithFormat:@"http://149.28.26.98:8082/miniheadline/UserWithVideo?uid=%d&vid=%d&type=0", uid, vid];
    NSURL *url = [NSURL URLWithString:urlString];
    
    //2.创建请求对象
    //请求对象内部默认已经包含了请求头和请求方法（GET）
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    //4.根据会话对象创建一个Task(发送请求）
    /*
     第一个参数：请求对象
     第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
     data：响应体信息（期望的数据）
     response：响应头信息，主要是对服务器端的描述
     error：错误信息，如果请求失败，则error有值
     */
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_group_t getIsLikeTaskGroup = dispatch_group_create();
        if (error == nil) {
            //6.解析服务器返回的数据
            //说明：（此处返回的数据是JSON格式的，因此使用NSJSONSerialization进行反序列化处理）
            NSString *output = [[NSString alloc] initWithBytes:data.bytes length:data.length encoding:NSUTF8StringEncoding];
            NSLog(@"%@", output);
            if([output isEqualToString:@"success."]) {
                success();
            }
        }
    }];
    
    //5.执行任务
    [dataTask resume];
}

@end
