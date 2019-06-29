//
//  ChildPageNetworkModel.m
//  MiniHeadline
//
//  Created by Vicent Zhang on 2019/6/28.
//  Copyright © 2019 Booooby. All rights reserved.
//


#import "ChildPageNetworkModel.h"
#import "NewsModel.h"

@implementation ChildPageNetworkModel

- (void)getFeedsListWithOffset:(NSInteger)offset count:(NSInteger)count success:(void (^)(NSMutableArray *dataArray))success failure:(void (^)(NSError *error))failure {
    //1.创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    //2.根据会话对象创建task
    NSURL *url = [NSURL URLWithString:@"https://i.snssdk.com/course/article_feed"];
    
    //3.创建可变的请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //4.修改请求方法为POST
    request.HTTPMethod = @"POST";
    
    //5.设置请求体
    NSString *body = [NSString stringWithFormat:@"uid=4822&offset=%ld&count=%ld", offset, count];
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    
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
        for (NSInteger i = 0; i < count; i++) {
            NewsModel *temp = [[NewsModel alloc] init];
            [arr addObject:temp];
        }
        
        NSMutableArray *dataArr = [[res objectForKey:@"data"] objectForKey:@"article_feed"];
        
        dispatch_group_t downloadTaskGroup = dispatch_group_create();
        for (NSInteger i = 0; i < count; i++) {
            NSString *title = [dataArr[i] objectForKey:@"title"];
            
            // urlencode
            NSString *groupID = [dataArr[i] objectForKey:@"group_id"];
            NSString *charaters = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
            NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:charaters] invertedSet];
            NSString *encodedGroupID = [groupID stringByAddingPercentEncodingWithAllowedCharacters:characterSet];
            
            NSMutableArray *imageInfos = [dataArr[i] objectForKey:@"image_infos"];
            dispatch_group_t imagesDownloadTaskGroup = dispatch_group_create();
            NSMutableArray *imagesArray = [NSMutableArray array];
            for (int j = 0; j < 3; j++) {
                NSString *temp = [[NSString alloc] init];
                [imagesArray addObject:temp];
            }
            for (int j = 0; j < 3 && j < imageInfos.count; j++) {
                NSString *urlPrefix = [imageInfos[j] objectForKey:@"url_prefix"];
                NSString *webUri = [imageInfos[j] objectForKey:@"web_uri"];
                NSString *imageType = [[[imageInfos[j] objectForKey:@"mime_type"] substringFromIndex:5] stringByReplacingOccurrencesOfString:@"/" withString:@"."];
                NSString *url = [[urlPrefix stringByAppendingString:webUri] stringByAppendingString:imageType];
                
                dispatch_group_enter(imagesDownloadTaskGroup);
                NSString *index = [NSString stringWithFormat:@"%ld_%ld_%d", (offset + i),(long)i, j];
                [self downloadImageWithURL:url index:index success:^(NSString * _Nonnull imagePath) {
                    [imagesArray replaceObjectAtIndex:j withObject:imagePath];
                    dispatch_group_leave(imagesDownloadTaskGroup);
                } failure:^(NSError * _Nonnull error) {
                    NSLog(@"请求失败 error:%@", error.description);
                    dispatch_group_leave(imagesDownloadTaskGroup);
                }];
            }
            
            dispatch_group_enter(downloadTaskGroup);
            dispatch_group_notify(imagesDownloadTaskGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                if (imageInfos.count == 0) {
                    NSLog(@"%ld:Feed without image", (long)i);
                    NewsModel *model = [NewsModel initWithTitle:title type:0 groupID:encodedGroupID offset:(offset + i)];
                    [arr replaceObjectAtIndex:i withObject:model];
                    dispatch_group_leave(downloadTaskGroup);
                }
                else if (imageInfos.count == 1 || imageInfos.count == 2) {
                    NSLog(@"%ld:Feed with one image", (long)i);
                    NewsModel *model = [NewsModel initWithTitle:title type:1 imagePath:imagesArray[0] groupID:encodedGroupID offset:(offset + i)];
                    [arr replaceObjectAtIndex:i withObject:model];
                    dispatch_group_leave(downloadTaskGroup);
                }
                else if (imageInfos.count >= 3) {
                    NSLog(@"%ld:Feed with more than two images", (long)i);
                    NewsModel *model = [NewsModel initWithTitle:title type:2 firstImagePath:imagesArray[0] secondImagePath:imagesArray[1] thirdImagePath:imagesArray[2] groupID:encodedGroupID offset:(offset + i)];
                    [arr replaceObjectAtIndex:i withObject:model];
                    dispatch_group_leave(downloadTaskGroup);
                }
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
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        //下载完成后文件位于location处，我们需要移到沙盒中
        NSString *dirPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *imagePath = [dirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", index]];
        
        NSFileManager *manager = [NSFileManager defaultManager];
        BOOL isDirectory;
        if ([manager fileExistsAtPath:imagePath isDirectory:&isDirectory]) {
            [manager removeItemAtPath:imagePath error:nil];
        }
        
        [manager moveItemAtPath:[location path] toPath:imagePath error:nil];
        
        success(imagePath);
    }];
    
    //开始任务
    [task resume];
}


@end
