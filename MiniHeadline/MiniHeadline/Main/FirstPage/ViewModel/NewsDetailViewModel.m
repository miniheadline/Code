//
//  NewsDetailViewModel.m
//  MiniHeadline
//
//  Created by Booooby on 2019/5/23.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import "NewsDetailViewModel.h"

@implementation NewsDetailViewModel

- (void)getFeedDetailWithGroupID:(NSString *)groupID success:(void (^)(NSString *content))success failure:(void (^)(NSError *error))failure {
    //1.创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    //2.根据会话对象创建task
    NSURL *url = [NSURL URLWithString:@"https://i.snssdk.com/course/article_content"];
    
    //3.创建可变的请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //4.修改请求方法为POST
    request.HTTPMethod = @"POST";
    
    //5.设置请求体
    NSString *arg = [NSString stringWithFormat:@"groupId=%@", groupID];
    NSLog(@"%@", arg);
    request.HTTPBody = [arg dataUsingEncoding:NSUTF8StringEncoding];
    
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
        NSString *imageUrlPrefix = [[res objectForKey:@"data"] objectForKey:@"image_url_prefix"];
        
        NSString *content = [[res objectForKey:@"data"] objectForKey:@"article_content"];
        content = [self replaceImageSrcWithString:content UrlPrefix:imageUrlPrefix];
        
        // 设置文字两端对齐
        content = [content stringByReplacingOccurrencesOfString:@"<div>" withString:@"<div style=\"text-align:justify; text-justify:inter-ideograph;\">"];
        
        // 设置图片宽度
        NSString *htmlString = [NSString stringWithFormat:@"<html> \n"
                                                           "<head> \n"
                                                           "<style type=\"text/css\"> \n"
                                                           "body {font-size:50px; padding:20px;}\n"
                                                           "</style> \n"
                                                           "</head> \n"
                                                           "<body>"
                                                           "<script type='text/javascript'>"
                                                           "window.onload = function(){\n"
                                                           "var $img = document.getElementsByTagName('img');\n"
                                                           "for(var p in $img){\n"
                                                           "$img[p].style.width = '100%%';\n"
                                                           "$img[p].style.height = 'auto'\n"
                                                           "}\n"
                                                           "}"
                                                           "</script>%@"
                                                           "</body>"
                                                           "</html>", content];
        success(htmlString);
    }];
    
    //7.执行任务
    [dataTask resume];
}

// 是否已点赞
- (void)getIsLikeWithUid:(int)uid nid:(int)nid success:(void (^)(BOOL))success failure:(void (^)(NSError * _Nonnull))failure {
    //1.确定请求路径
    NSString *urlString = [NSString stringWithFormat:@"http://149.28.26.98:8082/miniheadline/isUserConnect?uid=%d&nid=%d&type=1", uid, nid];
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
            NSInteger status = (NSInteger)[dict objectForKey:@"status"];
            success(status == 1);
            NSLog(@"isStar:%@", [dict objectForKey:@"status"]);
        }
    }];
    
    //5.执行任务
    [dataTask resume];
}

// 是否已收藏
- (void)getIsStarWithUid:(int)uid nid:(int)nid success:(void (^)(BOOL))success failure:(void (^)(NSError * _Nonnull))failure {
    //1.确定请求路径
    NSString *urlString = [NSString stringWithFormat:@"http://149.28.26.98:8082/miniheadline/isUserConnect?uid=%d&nid=%d&type=2", uid, nid];
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
            NSInteger status = (NSInteger)[dict objectForKey:@"status"];
            success(status == 1);
            NSLog(@"isLike:%@", [dict objectForKey:@"status"]);
        }
    }];
    
    //5.执行任务
    [dataTask resume];
}

// 浏览
- (void)readNewsWithUid:(int)uid nid:(int)nid success:(void (^)(void))success failure:(void (^)(NSError * _Nonnull))failure {
    //1.确定请求路径
    NSString *urlString = [NSString stringWithFormat:@"http://149.28.26.98:8082/miniheadline/UserWithNews?uid=%d&nid=%d&type=0", uid, nid];
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
            NSLog(@"%@", dict);
        }
    }];
    
    //5.执行任务
    [dataTask resume];
}

// 点赞
- (void)likeNewsWithUid:(int)uid nid:(int)nid success:(void (^)(void))success failure:(void (^)(NSError * _Nonnull))failure {
    //1.确定请求路径
    NSString *urlString = [NSString stringWithFormat:@"http://149.28.26.98:8082/miniheadline/UserWithNews?uid=%d&nid=%d&type=1", uid, nid];
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
            NSLog(@"%@", dict);
        }
    }];
    
    //5.执行任务
    [dataTask resume];
}

// 收藏
- (void)starNewsWithUid:(int)uid nid:(int)nid success:(void (^)(void))success failure:(void (^)(NSError * _Nonnull))failure {
    //1.确定请求路径
    NSString *urlString = [NSString stringWithFormat:@"http://149.28.26.98:8082/miniheadline/UserWithNews?uid=%d&nid=%d&type=2", uid, nid];
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
            NSLog(@"%@", dict);
        }
    }];
    
    //5.执行任务
    [dataTask resume];
}


#pragma mark - AuxiliaryFunction

- (NSString *)replaceImageSrcWithString:(NSString *)content UrlPrefix:(NSString *)urlPrefix {
    NSString *temp = content;
    
    NSRange rangePre = [temp rangeOfString:@"<p><img"];
    NSRange rangeSuf;
    NSString *newHtmlString = @"";
    
    while (rangePre.location != NSNotFound) {
        newHtmlString = [newHtmlString stringByAppendingString:[temp substringToIndex:rangePre.location]];
        temp = [temp substringFromIndex:rangePre.location];
        rangeSuf = [temp rangeOfString:@"</p>"];
        NSString *imageHtmlString = [temp substringWithRange:NSMakeRange(0, rangeSuf.location + rangeSuf.length)];
        imageHtmlString = [self getImageSrcWithString:imageHtmlString UrlPrefix:urlPrefix];
        newHtmlString = [newHtmlString stringByAppendingString:imageHtmlString];
        temp = [temp substringFromIndex:(rangeSuf.location + rangeSuf.length)];
        rangePre = [temp rangeOfString:@"<p><img"];
    }
    newHtmlString = [newHtmlString stringByAppendingString:temp];
    
    return newHtmlString;
}

- (NSString *)getImageSrcWithString:(NSString *)content UrlPrefix:(NSString *)urlPrefix {
    NSString *res = @"<p><img src=\"";
    
    NSRange rangePre = [[content substringFromIndex:29] rangeOfString:@"{"];
    NSRange rangeSuf = [[content substringFromIndex:29] rangeOfString:@"}"];
    
    NSString *subString = [content substringWithRange:NSMakeRange(29 + rangePre.location, rangeSuf.location - rangePre.location + 1)];
    
    NSData *jsonData = [subString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (error != nil) {
        NSLog(@"error:%@", error);
    }
    
    res = [res stringByAppendingString:urlPrefix];
    res = [res stringByAppendingString:[dic objectForKey:@"web_uri"]];
    res = [res stringByAppendingString:@"?fingerprint="];
    res = [res stringByAppendingString:[dic objectForKey:@"fingerprint"]];
    res = [res stringByAppendingString:@"?hash_id="];
    res = [res stringByAppendingString:[[dic objectForKey:@"hash_id"] stringValue]];
    res = [res stringByAppendingString:@"?md5="];
    res = [res stringByAppendingString:[dic objectForKey:@"md5"]];
    res = [res stringByAppendingString:@"?near_dup_id="];
    res = [res stringByAppendingString:[dic objectForKey:@"near_dup_id"]];
    res = [res stringByAppendingString:@"."];
    res = [res stringByAppendingString:[[dic objectForKey:@"mimetype"] substringFromIndex:6]];
    
    NSString *rest = [content substringFromIndex:(rangeSuf.location + rangeSuf.length + 29)];
    res = [res stringByAppendingString:rest];
    
    return res;
}


@end
