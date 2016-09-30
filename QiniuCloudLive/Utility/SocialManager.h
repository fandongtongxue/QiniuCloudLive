//
//  SocialManager.h
//  SocialDemo
//
//  Created by 范东 on 16/6/30.
//  Copyright © 2016年 范东. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SocialManager : NSObject

@property (nonatomic, assign) SocialLoginType loginType;

+ (SocialManager *)manager;

- (void)application:(id)application didFinishLaunchingWithOptions:(id)launchOptions;

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;

- (void)loginFromViewController:(UIViewController *)viewController Successed:(void(^)(NSDictionary *userInfo))successBlock failed:(void(^)(NSError *error))failBlock;

- (void)logout;

@end
