//
//  AppHelper.m
//  QiniuCloudLive
//
//  Created by 范东 on 16/10/17.
//  Copyright © 2016年 范东. All rights reserved.
//

#import "AppHelper.h"
#import "SSKeychain.h"

@implementation AppHelper

+ (AppHelper *)shareInstance{
    static AppHelper *shareInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}

+ (NSString *)uuid{
    NSString * currentDeviceUUIDStr = [SSKeychain passwordForService:@" "account:@"uuid"];
    if (currentDeviceUUIDStr == nil || [currentDeviceUUIDStr isEqualToString:@""]){
        NSUUID * currentDeviceUUID  = [UIDevice currentDevice].identifierForVendor;
        currentDeviceUUIDStr = currentDeviceUUID.UUIDString;
        currentDeviceUUIDStr = [currentDeviceUUIDStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
        currentDeviceUUIDStr = [currentDeviceUUIDStr lowercaseString];
        [SSKeychain setPassword: currentDeviceUUIDStr forService:@" "account:@"uuid"];
    }
    return currentDeviceUUIDStr;
}

+ (BOOL)isLogin{
    return [UserDefault boolObjectForKey:kUserDefaultsKeyUserIsLogin];
}

@end
