//
//  NewsModel.m
//  MiniHeadline
//
//  Created by Booooby on 2019/4/23.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import "NewsModel.h"

@implementation NewsModel

+ (instancetype)myNewsModel {
    NewsModel *cellModel = [[NewsModel alloc] init];
    cellModel.title = @"测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试";
    cellModel.publisher = @"中山大学";
    cellModel.comments = @"432评论";
    cellModel.time = @"5小时前";
    cellModel.firstImageName = @"logo.png";
    return cellModel;
}

- (void)initWithUid:(NSString *)uid andOffset:(NSInteger)offset {
    // NSDictionary *data = [self HttpPost];
}

#pragma mark - NSURLSession

- (void)HttpPost {
    //1.创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    //2.根据会话对象创建task
    NSURL *url = [NSURL URLWithString:@"https://i.snssdk.com/course/article_feed"];
    
    //3.创建可变的请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //4.修改请求方法为POST
    request.HTTPMethod = @"POST";
    
    //5.设置请求体
    request.HTTPBody = [@"uid=4822&offset=0&count=1" dataUsingEncoding:NSUTF8StringEncoding];
    
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
        NSLog(@"%@", data);
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"%@", res);
        NSString *temp = [[[res objectForKey:@"data"] objectForKey:@"article_feed"] objectForKey:@"group_id"];
        NSLog(@"%@", temp);
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    }];
    
    //7.执行任务
    [dataTask resume];
}

- (void)downloadPicture {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:[NSURL URLWithString:@"http://p3-tt.bytecdn.cn/large/f8e0002317d5fd18447.jpg"] completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        //下载完成后文件位于location处，我们需要移到沙盒中
        NSString *dirPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *path = [dirPath stringByAppendingPathComponent:@"1.jpg"];
        
        NSFileManager *manager = [NSFileManager defaultManager];
        if ([manager fileExistsAtPath:path isDirectory:NO]) {
            [manager removeItemAtPath:path error:nil];
        }
        
        [manager moveItemAtPath:[location path] toPath:path error:nil];
    }];
    
    //开始任务
    [task resume];
}

@end
