//
//  LiveManager.h
//  Live
//
//  Created by 范东 on 16/8/9.
//  Copyright © 2016年 范东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiveManager : NSObject

+ (LiveManager *)manager;

- (void)getRtmpAddress:(NSDictionary *)dict SuccessBlock:(void(^)(NSDictionary *responseDict))successBlock failBlock:(void(^)(NSError *error))failBlock;

@end
