//
//  QiniuLiveManager.h
//  Live
//
//  Created by 范东 on 16/8/9.
//  Copyright © 2016年 范东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QiniuLiveManager : NSObject

+ (QiniuLiveManager *)manager;

- (void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

@end
