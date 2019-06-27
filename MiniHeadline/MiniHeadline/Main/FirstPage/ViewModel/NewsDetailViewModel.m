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
    // 创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 根据会话对象创建task
    NSURL *url = [NSURL URLWithString:@"https://i.snssdk.com/course/article_content"];
    
    // 创建可变的请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // 修改请求方法为POST
    request.HTTPMethod = @"POST";
    
    // 设置请求体
    NSString *arg = [NSString stringWithFormat:@"groupId=%@", groupID];
    request.HTTPBody = [arg dataUsingEncoding:NSUTF8StringEncoding];
    
    // 根据会话对象创建一个Task(发送请求）
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 解析数据
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
    
    // 执行任务
    [dataTask resume];
}

// 是否已点赞
- (void)getIsLikeWithUid:(NSInteger)uid nid:(NSInteger)nid success:(void (^)(BOOL))success failure:(void (^)(NSError * _Nonnull))failure {
    // 确定请求路径
    NSString *urlString = [NSString stringWithFormat:@"http://149.28.26.98:8082/miniheadline/isUserConnect?uid=%ld&nid=%ld&type=1", (long)uid, (long)nid];
    NSURL *url = [NSURL URLWithString:urlString];
    
    // 创建请求对象，请求对象内部默认已经包含了请求头和请求方法（GET）
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 根据会话对象创建一个Task(发送请求）
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            // 解析服务器返回的数据
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSInteger status = (NSInteger)[dict objectForKey:@"status"];
            success(status == 1);
        }
    }];
    
    // 执行任务
    [dataTask resume];
}

// 是否已收藏
- (void)getIsStarWithUid:(NSInteger)uid nid:(NSInteger)nid success:(void (^)(BOOL))success failure:(void (^)(NSError * _Nonnull))failure {
    // 确定请求路径
    NSString *urlString = [NSString stringWithFormat:@"http://149.28.26.98:8082/miniheadline/isUserConnect?uid=%ld&nid=%ld&type=2", (long)uid, (long)nid];
    NSURL *url = [NSURL URLWithString:urlString];
    
    // 创建请求对象，请求对象内部默认已经包含了请求头和请求方法（GET）
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 根据会话对象创建一个Task(发送请求）
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            // 解析服务器返回的数据
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSInteger status = (NSInteger)[dict objectForKey:@"status"];
            success(status == 1);
        }
    }];
    
    // 执行任务
    [dataTask resume];
}

// 浏览
- (void)readNewsWithUid:(NSInteger)uid nid:(NSInteger)nid success:(void (^)(void))success failure:(void (^)(NSError * _Nonnull))failure {
    // 确定请求路径
    NSString *urlString = [NSString stringWithFormat:@"http://149.28.26.98:8082/miniheadline/UserWithNews?uid=%ld&nid=%ld&type=0", (long)uid, (long)nid];
    NSURL *url = [NSURL URLWithString:urlString];
    
    // 创建请求对象，请求对象内部默认已经包含了请求头和请求方法（GET）
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 根据会话对象创建一个Task(发送请求）
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            // 解析服务器返回的数据
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSLog(@"%@", dict);
        }
    }];
    
    // 执行任务
    [dataTask resume];
}

// 点赞
- (void)likeNewsWithUid:(NSInteger)uid nid:(NSInteger)nid success:(void (^)(void))success failure:(void (^)(NSError * _Nonnull))failure {
    // 确定请求路径
    NSString *urlString = [NSString stringWithFormat:@"http://149.28.26.98:8082/miniheadline/UserWithNews?uid=%ld&nid=%ld&type=1", (long)uid, (long)nid];
    NSURL *url = [NSURL URLWithString:urlString];
    
    // 创建请求对象，请求对象内部默认已经包含了请求头和请求方法（GET）
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 根据会话对象创建一个Task(发送请求）
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            // 解析服务器返回的数据
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSLog(@"%@", dict);
        }
    }];
    
    // 执行任务
    [dataTask resume];
}

// 收藏
- (void)starNewsWithUid:(NSInteger)uid nid:(NSInteger)nid success:(void (^)(void))success failure:(void (^)(NSError * _Nonnull))failure {
    // 确定请求路径
    NSString *urlString = [NSString stringWithFormat:@"http://149.28.26.98:8082/miniheadline/UserWithNews?uid=%ld&nid=%ld&type=2", (long)uid, (long)nid];
    NSURL *url = [NSURL URLWithString:urlString];
    
    // 创建请求对象，请求对象内部默认已经包含了请求头和请求方法（GET）
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 根据会话对象创建一个Task(发送请求）
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            // 解析服务器返回的数据
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSLog(@"%@", dict);
        }
    }];
    
    // 执行任务
    [dataTask resume];
}


#pragma mark - AuxiliaryFunction

// 解析图片src
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

// 将参数由JSON转为字符串
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
