//
//  LiveManager.m
//  Live
//
//  Created by 范东 on 16/8/9.
//  Copyright © 2016年 范东. All rights reserved.
//

#import "LiveManager.h"

#define kGetStreamJsonUrl @"http://fandong.me/live/example/getStreamJson.php"

@implementation LiveManager

+ (LiveManager *)manager{
    static LiveManager *manager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)getRtmpAddresssuccessBlock:(void(^)(NSDictionary *responseDict))successBlock failBlock:(void(^)(NSError *error))failBlock{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:kGetStreamJsonUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        successBlock(dict);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error);
    }];
}

@end
