//
//  WeiboManager.m
//  SocialDemo
//
//  Created by 范东 on 16/7/2.
//  Copyright © 2016年 范东. All rights reserved.
//

#import "WeiboManager.h"
#import <WeiboSDK/WeiboSDK.h>

static NSString * const appKey = @"1286666776";
static NSString * const appSecret = @"25c716826862398e64a9de8342c577e8";
static NSString * const appRedictUrl = @"http://fandong.me";

@implementation WeiboManager

+ (WeiboManager *)manager
{
    static WeiboManager *manager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)application:(id)application didFinishLaunchingWithOptions:(id)launchOptions{
    [WeiboSDK registerApp:appKey];
    [WeiboSDK enableDebugMode:YES];
}

- (BOOL)application:(UIApplication *)application
                    openURL:(NSURL *)url
          sourceApplication:(NSString *)sourceApplication
                 annotation:(id)annotation{
    return [WeiboSDK handleOpenURL:url delegate:(id<WeiboSDKDelegate>)self];
}

- (void)signIn{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = appRedictUrl;
    request.scope = @"all";
    [WeiboSDK sendRequest:request];
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    if ([response isKindOfClass:WBAuthorizeResponse.class]) {
        switch (response.statusCode) {
            case WeiboSDKResponseStatusCodeSuccess:
            {
                NSDictionary *dict = @{@"userID":[(WBAuthorizeResponse *)response userID],
                                       @"accessToken":[(WBAuthorizeResponse *)response accessToken],
                                       @"expirationDate":[(WBAuthorizeResponse *)response expirationDate]};
                if (self.delegate && [self.delegate respondsToSelector:@selector(weiboManager:userInfo:)]) {
                    [self.delegate weiboManager:[WeiboManager manager] userInfo:dict];
                }
                break;
            }
            case WeiboSDKResponseStatusCodeUnknown:
                DLOG(@"未知错误");
                break;
            case WeiboSDKResponseStatusCodeAuthDeny:
                DLOG(@"用户拒绝授权");
                break;
            case WeiboSDKResponseStatusCodeUserCancel:
                DLOG(@"用户取消授权");
                break;
            default:
                break;
        }
    }
}

- (void)logout{
    
}

@end
