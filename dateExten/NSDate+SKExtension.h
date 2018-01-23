//
//  NSDate+SKExtension.h
//  DateExtension
//
//  Created by 纳里健康 on 2017/11/27.
//  Copyright © 2017年 songK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (SKExtension)

/** 求出时间差值 */
-(NSDateComponents *)dateFrom:(NSDate *)from;

/**
 *  是否为今年
 */
-(BOOL)isThisYear;
/**
 *  是否为今天
 */
-(BOOL)isToday;

/**
 *  是否为昨天
 */
-(BOOL)isYesterday;

/**
 * 根据生日计算年龄
 */
- (NSInteger)getAgeFromBirthDay:(NSString*)birth;

/**
 字符串转成NSDate
 1: yyyy-MM-dd HH:mm:ss
 2: yyyy-MM-dd
 3: yyyy年MM月dd日
 4: yyyy-MM-dd HH:mm
 */
- (NSDate*)dateFromString:(NSString*)string withType:(NSInteger)type;

/**
 * NSDate转成 "周几" 格式的字符串
 */
- (NSString *)getweekStringFromDate:(NSDate *)date;
/**
 * 生成 "刚刚/几分钟前/几小时前/几天前/" 格式的字符串
 */
- (NSString*)prettyDateWithReference:(NSString*)dateString;

/**
 * 与当前时间做比较,判断是在当前时间之前，还是之后
 * 早于当前时间 NO   晚于当前时间 YES
 */
- (BOOL)compareNow:(NSString *)compareTime;
@end
