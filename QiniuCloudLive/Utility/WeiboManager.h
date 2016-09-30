//
//  WeiboManager.h
//  SocialDemo
//
//  Created by 范东 on 16/7/2.
//  Copyright © 2016年 范东. All rights reserved.
//

@class WeiboManager;

#import <Foundation/Foundation.h>

@protocol WeiboManagerDelegate <NSObject>

//登陆成功回调
- (void)weiboManager:(WeiboManager *)manager userInfo:(NSDictionary *)userInfo;

@end

@interface WeiboManager : NSObject

@property (nonatomic, weak)id<WeiboManagerDelegate>delegate;

+ (WeiboManager *)manager;

- (void)application:(id)application didFinishLaunchingWithOptions:(id)launchOptions;

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;

- (void)signIn;

- (void)logout;

@end
