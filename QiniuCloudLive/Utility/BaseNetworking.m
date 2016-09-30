//
//  BaseNetworking.m
//  wisenjoyapp
//
//  Created by 范东 on 16/9/23.
//  Copyright © 2016年 wisenjoy. All rights reserved.
//

#import "BaseNetworking.h"

@implementation BaseNetworking

+ (BaseNetworking *)shareInstance{
    static BaseNetworking *shareInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareInstance = [[self alloc] init];
    });
    shareInstance.requestContentType = RequestContentTypeJSON;
    shareInstance.timeoutInterval = 30;
    return shareInstance;
}

- (void)GET:(NSString *)URLString dict:(id)dict succeed:(void (^)(id))succeed failure:(void (^)(NSError *))failure{
    //创建网络请求管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明请求的数据是json类型
    manager.requestSerializer = [self requestSerializerWithType:[BaseNetworking shareInstance].requestContentType];
    //申明返回的结果是json类型
    manager.responseSerializer = [self responseSerializerWithType:[BaseNetworking shareInstance].responseContentType];
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [self acceptableContentTypes];
    //超时时间
    manager.requestSerializer.timeoutInterval = [BaseNetworking shareInstance].timeoutInterval;
    //证书
//    manager.securityPolicy = [self customSecurityPolicy];
    //发送网络请求(请求方式为GET)
    [manager GET:URLString parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        succeed(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)POST:(NSString *)URLString dict:(id)dict succeed:(void (^)(id))succeed failure:(void (^)(NSError *))failure{
    //创建网络请求管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [self responseSerializerWithType:[BaseNetworking shareInstance].responseContentType];
    //申明请求的数据是json类型
    manager.requestSerializer = [self requestSerializerWithType:[BaseNetworking shareInstance].requestContentType];
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [self acceptableContentTypes];
    //超时时间
    manager.requestSerializer.timeoutInterval = [BaseNetworking shareInstance].timeoutInterval;
    //证书
//    manager.securityPolicy = [self customSecurityPolicy];
    //发送网络请求(请求方式为POST)
    [manager POST:URLString parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        succeed(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (AFHTTPRequestSerializer *)requestSerializerWithType:(RequestContentType)type{
    switch (type) {
        case RequestContentTypeJSON:
            return [AFJSONRequestSerializer serializer];
            break;
            
        default:
            break;
    }
}

- (AFHTTPResponseSerializer *)responseSerializerWithType:(ResponseContentType)type{
    switch (type) {
        case ResponseContentTypeJSON:
            return [AFJSONResponseSerializer serializer];
            break;
            
        default:
            return [AFHTTPResponseSerializer serializer];
            break;
    }
}

- (NSSet *)acceptableContentTypes{
    return [NSSet setWithObjects:@"application/json", @"text/html", @"text/json",nil];
}

- (AFSecurityPolicy *)customSecurityPolicy{
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"aa" ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
    securityPolicy.pinnedCertificates = [NSSet setWithArray:@[certData]];
    
    return securityPolicy;
}

@end
