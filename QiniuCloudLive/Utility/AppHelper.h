//
//  AppHelper.h
//  QiniuCloudLive
//
//  Created by 范东 on 16/10/17.
//  Copyright © 2016年 范东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppHelper : NSObject

+ (AppHelper *)shareInstance;

+ (NSString *)uuid;

+ (BOOL)isLogin;

@end
