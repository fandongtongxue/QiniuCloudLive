//
//  UserDefault.m
//  PLPlayerKit
//
//  Created by 范东 on 16/7/14.
//  Copyright © 2016年 0dayZh. All rights reserved.
//

#import "UserDefault.h"

#define UserDefaults [NSUserDefaults standardUserDefaults]

@implementation UserDefault

+ (void)saveObject:(id)object ForKey:(NSString *)key{
    [UserDefaults setObject:object forKey:key];
    [UserDefaults synchronize];
}

+ (id)objectForKey:(NSString *)key{
    id object = [UserDefaults valueForKey:key];
    return object;
}

+ (void)saveBoolObject:(BOOL)object ForKey:(NSString *)key{
    [UserDefaults setBool:object forKey:key];
    [UserDefaults synchronize];
}

+ (BOOL)boolObjectForKey:(NSString *)key{
    BOOL object = [UserDefaults boolForKey:key];
    return object;
}

@end
