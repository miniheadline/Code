//
//  FirstPageViewModel.m
//  MiniHeadline
//
//  Created by Booooby on 2019/5/22.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import "FirstPageViewModel.h"
#import "NewsModel.h"

@implementation FirstPageViewModel

- (void)getFeedsListWithSuccess:(void (^)(NSMutableArray *dataArray))success andFailure:(void (^)(NSError *error))failure {
    //1.创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    //2.根据会话对象创建task
    NSURL *url = [NSURL URLWithString:@"https://i.snssdk.com/course/article_feed"];
    
    //3.创建可变的请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //4.修改请求方法为POST
    request.HTTPMethod = @"POST";
    
    //5.设置请求体
    request.HTTPBody = [@"uid=4822&offset=0&count=20" dataUsingEncoding:NSUTF8StringEncoding];
    
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
        
        NSMutableArray *arr = [NSMutableArray array];
        NSMutableArray *dataArr = [[res objectForKey:@"data"] objectForKey:@"article_feed"];
        
        dispatch_group_t downloadTaskGroup = dispatch_group_create();
        for (int i = 0; i < 20; i++) {
            NSString *title = [dataArr[i] objectForKey:@"title"];
            NSLog(@"%@", title);
            
            NSString *groupID = [dataArr[i] objectForKey:@"group_id"];
            NSLog(@"%@", groupID);
            
            NSMutableArray *imageInfos = [dataArr[i] objectForKey:@"image_infos"];
            NSLog(@"%lu", imageInfos.count);
            NSString *urlPrefix = [imageInfos[0] objectForKey:@"url_prefix"];
            NSString *webUri = [imageInfos[0] objectForKey:@"web_uri"];
            NSString *imageType = [[[imageInfos[0] objectForKey:@"mime_type"] substringFromIndex:5] stringByReplacingOccurrencesOfString:@"/" withString:@"."];
            NSString *url = [[urlPrefix stringByAppendingString:webUri] stringByAppendingString:imageType];
            
            dispatch_group_enter(downloadTaskGroup);
            [self downloadImageWithURL:url index:i success:^(NSString * _Nonnull imagePath) {
                NewsModel *news = [NewsModel initWithTitle:title imagePath:imagePath groupID:groupID];
                [arr addObject:news];
                dispatch_group_leave(downloadTaskGroup);
            } failure:^(NSError * _Nonnull error) {
                NSLog(@"请求失败 error:%@",error.description);
                dispatch_group_leave(downloadTaskGroup);
            }];
        }
        dispatch_group_notify(downloadTaskGroup, dispatch_get_main_queue(), ^{
            NSLog(@"%@", @"完成");
            success(arr);
        });
    }];
    
    //7.执行任务
    [dataTask resume];
}

- (void)downloadImageWithURL:(NSString *)url index:(int)index success:(void (^)(NSString *imagePath))success failure:(void (^)(NSError *error))failure {
    NSLog(@"%@", url);
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        //下载完成后文件位于location处，我们需要移到沙盒中
        NSString *dirPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *imagePath = [dirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.jpg", index]];
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
}

@end
