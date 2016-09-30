//
//  BaseNetworking.h
//  wisenjoyapp
//
//  Created by 范东 on 16/9/23.
//  Copyright © 2016年 wisenjoy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RequestContentType){
    RequestContentTypeJSON,
};

typedef NS_ENUM(NSInteger, ResponseContentType){
    ResponseContentTypeJSON,
    ResponseContentTypeText,
};

@interface BaseNetworking : NSObject

/**
* 获取单例
* @return BaseNetworking单例对象
 */
+ (BaseNetworking *)shareInstance;

/*!
 *   @brief 超时时间,默认30秒
 */
@property (assign, nonatomic) NSTimeInterval timeoutInterval;

/*!
 *   @brief 请求内容类型，默认JSON
 */
@property (assign, nonatomic) RequestContentType requestContentType;

/*!
 *   @brief 返回数据内容类型，默认JSON
 */
@property (assign, nonatomic) ResponseContentType responseContentType;


/**
 *  GET请求
 *
 *  @param URLString 网络请求地址
 *  @param dict      参数(可以是字典或者nil)
 *  @param succeed   成功后执行success block
 *  @param failure   失败后执行failure block
 */
- (void)GET:(NSString *)URLString dict:(id)dict succeed:(void (^)(id data))succeed failure:(void (^)(NSError *error))failure;

/**
 *  POST请求
 *
 *  @param URLString 网络请求地址
 *  @param dict      参数(可以是字典或者nil)
 *  @param succeed   成功后执行success block
 *  @param failure   失败后执行failure block
 */
- (void)POST:(NSString *)URLString dict:(id)dict succeed:(void (^)(id data))succeed failure:(void (^)(NSError *error))failure;


@end
