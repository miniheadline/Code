//
//  VideoListViewModel.m
//  MiniHeadline
//
//  Created by huangscar on 2019/6/19.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import "VideoListViewModel.h"
#import "../Model/MyVideo.h"

@implementation VideoListViewModel
- (void)getFeedsListWithOffset:(int)offset size:(int)size success:(void (^)(NSMutableArray *dataArray))success failure:(void (^)(NSError *error))failure {
    //1.创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    //2.根据会话对象创建task
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://149.28.26.98:8082/miniheadline/getVideosForAllUser?uid=%d&num=%d&offset=%d&type=0", 3, offset, size]];
    
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
        NSMutableArray *arr = [NSMutableArray array];
        
        
        
        
        NSMutableArray *dataArr = [res objectForKey:@"videoList"];
        NSInteger count = offset + size < dataArr.count ? size : dataArr.count;
        for (int i = 0; i < count; i++) {
            MyVideo *temp = [[MyVideo alloc] init];
            [arr addObject:temp];
        }
        
        dispatch_group_t downloadTaskGroup = dispatch_group_create();
        for (int i = 0; i < count; i++) {
            
            NSString *title = [dataArr[i] objectForKey:@"title"];
            NSString *url = [dataArr[i] objectForKey:@"url"];
            NSString *detail = [dataArr[i] objectForKey:@"introduction"];
            NSString *userPicURL = [dataArr[i] objectForKey:@"user_pic"];
            NSString *userName = [dataArr[i] objectForKey:@"username"];
            BOOL isFollow = [[dataArr[i] objectForKey:@"statusWithUser"] boolValue];
            int userID = [[dataArr[i] objectForKey:@"from_uid"] integerValue];
            NSString *index = [NSString stringWithFormat:@"icon_%d", userID];
            int vid = [[dataArr[i] objectForKey:@"vid"] integerValue];
            int likeNum = [[dataArr[i] objectForKey:@"likeNum"] integerValue];
            static NSString *picPath;
            dispatch_group_t imagesDownloadTaskGroup = dispatch_group_create();
            dispatch_group_enter(imagesDownloadTaskGroup);
            [self downloadImageWithURL:userPicURL index:index success:^(NSString *imagePath) {
                picPath = [imagePath copy];
                dispatch_group_leave(imagesDownloadTaskGroup);
            } failure:^(NSError *error) {
                dispatch_group_leave(imagesDownloadTaskGroup);
            }];
            dispatch_group_enter(downloadTaskGroup);
            dispatch_group_notify(imagesDownloadTaskGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage *pic = [[UIImage alloc] initWithContentsOfFile:picPath];
                MyVideo *video = [[MyVideo alloc] initWithVideo:title video:url authorName:userName icon:pic commentNum:0 isFollow:isFollow playNum:0];
                video.vid = vid;
                video.detail = detail;
                video.likeNum = likeNum;
                [arr replaceObjectAtIndex:i withObject:video];
                dispatch_group_leave(downloadTaskGroup);
            });
        }
        dispatch_group_notify(downloadTaskGroup, dispatch_get_main_queue(), ^{
            NSLog(@"notify");
            success(arr);
        });
    }];
    
    //7.执行任务
    [dataTask resume];
}

- (void)downloadImageWithURL:(NSString *)url index:(NSString *)index success:(void (^)(NSString *imagePath))success failure:(void (^)(NSError *error))failure {
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
}

@end
