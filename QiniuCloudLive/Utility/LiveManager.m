//
//  LiveManager.m
//  Live
//
//  Created by 范东 on 16/8/9.
//  Copyright © 2016年 范东. All rights reserved.
//

#import "LiveManager.h"

#define kGetStreamJsonUrl @"http://fandong.me/App/QiniuCloudLive/pili-sdk-php-master/example/createStream.php"

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
    [[BaseNetworking shareInstance] GET:kGetStreamJsonUrl dict:nil succeed:^(id data) {
        if (data && [data isKindOfClass:[NSDictionary class]] && [[(NSDictionary *)data objectForKey:@"status"] integerValue] == 1) {
            successBlock([(NSDictionary *)data objectForKey:@"data"]);
        }else{
            failBlock([NSError errorWithDomain:@"com.QiniuCloudLive" code:1 userInfo:@{@"info":@"获取直播地址失败"}]);
        }
    } failure:^(NSError *error) {
        failBlock(error);
    }];
}

@end
