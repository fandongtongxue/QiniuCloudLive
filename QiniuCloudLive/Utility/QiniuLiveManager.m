//
//  QiniuLiveManager.m
//  Live
//
//  Created by 范东 on 16/8/9.
//  Copyright © 2016年 范东. All rights reserved.
//

#import "QiniuLiveManager.h"
#import <PLMediaStreamingKit/PLMediaStreamingKit.h>

@implementation QiniuLiveManager

+ (QiniuLiveManager *)manager{
    static QiniuLiveManager *manager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [PLStreamingEnv initEnv];
}

@end
