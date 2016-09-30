//
//  AppConfig.h
//  Live
//
//  Created by 范东 on 16/8/15.
//  Copyright © 2016年 范东. All rights reserved.
//

#ifndef AppConfig_h
#define AppConfig_h

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define IOS8_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending )
#define kAppVersion                          ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])

#define OPEN_LOG
#ifdef  OPEN_LOG
#define DLOG(fmt, ...)                        NSLog((@"[Line %d] %s\r\n" fmt), __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__);
#define DLOG_POINT(fmt, Point, ...)           NSLog((@"[Line %d] %s" fmt @" Point :%@"), __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__, NSStringFromCGPoint(Point));
#define DLOG_SIZE(fmt, Size, ...)             NSLog((@"[Line %d] %s" fmt @" size :%@"), __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__, NSStringFromCGSize(Size));
#define DLOG_RECT(fmt, Rect, ...)             NSLog((@"[Line %d] %s" fmt @" Rect :%@"), __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__, NSStringFromCGRect(Rect));
#define DLOG_EDGEINSET(fmt, EdgeInsets, ...)  NSLog((@"[Line %d] %s" fmt @" EdgeInsets :%@"), __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__, NSStringFromUIEdgeInsets(EdgeInsets));
#define DLOG_OFFSET(fmt, Offset, ...)         NSLog((@"[Line %d] %s" fmt @" Offset :%@"), __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__, NSStringFromUIOffset(Offset));
#define DLOG_CLASS(fmt, Class, ...)           NSLog((@"[Line %d] %s" fmt @" Class :%@"), __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__, NSStringFromClass(Class));
#define DLOG_SELECTOR(fmt, Selector, ...)     NSLog((@"[Line %d] %s" fmt @" Selector :%@"), __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__, NSStringFromSelector(Selector));
#define DLOG_RANGE(fmt, Range, ...)           NSLog((@"[Line %d] %s" fmt @" Range :%@"), __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__, NSStringFromRange(Range));
#else
#define DLOG(fmt, ...)
#define DLOG_POINT(fmt, Point, ...)
#define DLOG_SIZE(fmt, Size, ...)
#define DLOG_RECT(fmt, Rect, ...)
#define DLOG_EDGEINSET(fmt, EdgeInsets, ...)
#define DLOG_OFFSET(fmt, Offset, ...)
#define DLOG_CLASS(fmt, Class, ...)
#define DLOG_SELECTOR(fmt, Selector, ...)
#define DLOG_RANGE(fmt, Range, ...)
#endif

#endif /* AppConfig_h */
