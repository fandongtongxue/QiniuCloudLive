//
//  NetworkManager.h
//  Live
//
//  Created by 范东 on 16/8/15.
//  Copyright © 2016年 范东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkManager : NSObject

+ (NetworkManager *)manager;

- (void)GET:(NSString *)URLString
        parameters:(id)parameters
        success:(void (^)(NSDictionary *responseDict))success
        failure:(void (^)(NSError *error))failure;

@end
