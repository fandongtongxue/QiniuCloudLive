//
//  SocialManager.m
//  SocialDemo
//
//  Created by 范东 on 16/6/30.
//  Copyright © 2016年 范东. All rights reserved.
//

#import "SocialManager.h"
#import "WeiboManager.h"

@implementation SocialManager

+ (SocialManager *)manager
{
    static SocialManager *manager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)application:(id)application didFinishLaunchingWithOptions:(id)launchOptions{
    [[WeiboManager manager] application:application didFinishLaunchingWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    BOOL ret = NO;
    switch ([SocialManager manager].loginType) {
        case SocialLoginTypeWeibo:
            ret |= [[WeiboManager manager] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
            break;
        default:
            break;
    }
    return ret;
}

- (void)loginFromViewController:(UIViewController *)viewController Successed:(void(^)(NSDictionary *userInfo))successBlock failed:(void(^)(NSError *error))failBlock{
    switch ([SocialManager manager].loginType) {
        case SocialLoginTypeWeibo:
            [[WeiboManager manager] signIn];
            [WeiboManager manager].delegate = (id<WeiboManagerDelegate>)viewController;
            break;
        default:
            break;
    }
}

- (void)logout{
    [[WeiboManager manager] logout];
}
@end
