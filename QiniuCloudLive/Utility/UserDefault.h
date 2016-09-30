//
//  UserDefault.h
//  PLPlayerKit
//
//  Created by 范东 on 16/7/14.
//  Copyright © 2016年 0dayZh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefault : NSObject

+ (void)saveObject:(id)object ForKey:(NSString *)key;

+ (id)objectForKey:(NSString *)key;

@end
