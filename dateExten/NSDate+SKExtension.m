//
//  NSDate+SKExtension.m
//  DateExtension
//
//  Created by 纳里健康 on 2017/11/27.
//  Copyright © 2017年 songK. All rights reserved.
//

#import "NSDate+SKExtension.h"

@implementation NSDate (SKExtension)

//根据时间返回一个日历对象
-(NSDateComponents *)dateFrom:(NSDate *)from
{
    //拿到日历对象
    NSCalendar * calender = [NSCalendar currentCalendar];
    //比较时间
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return  [calender components:unit fromDate:from toDate:self options:kNilOptions];
}


/**
 判断是否是同一年
 */
-(BOOL)isThisYear
{
    //日历
    NSCalendar * calendar = [NSCalendar currentCalendar];
    
    NSInteger nowYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger selfYear = [calendar component:NSCalendarUnitYear fromDate:self];
    
    return nowYear == selfYear;
}



/**
 判断是否是同一天
 */
-(BOOL)isToday
{
    //日历
    NSCalendar * calendar = [NSCalendar currentCalendar];
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents * nowCmps = [calendar components:unit fromDate:[NSDate date]];
    NSDateComponents * selfCmps = [calendar components:unit fromDate:self];
    
    return nowCmps.year == selfCmps.year
    &&     nowCmps.month == selfCmps.month
    &&     nowCmps.day == selfCmps.day;
}


/**
 判断是否是昨天
 */
-(BOOL)isYesterday
{
    /*  24小时  思路:  清零时间  再比较时间戳
     2016-1-1     00:00:00
     2015-12-31   00:00:00
     */
    //日期格式化类
    NSDateFormatter * fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    //清空时间保留日期
    NSString * nowStr = [fmt stringFromDate:[NSDate date]];
    NSDate * nowDate = [fmt dateFromString:nowStr];
    
    NSString * selfStr = [fmt stringFromDate:self];
    NSDate * selfDate = [fmt dateFromString:selfStr];
    
    //日历类
    NSCalendar * calendar = [NSCalendar currentCalendar];
    //通过日历类比较日期
    NSDateComponents * cmps = [calendar components:NSCalendarUnitYear |NSCalendarUnitMonth | NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    return cmps.year == 0
    &&     cmps.month == 0
    &&     cmps.day == 1;
}

/**
 根据生日计算年龄
 
 @param birth 生日字符串
 @return NSInteger 年龄
 规则：计算出年份差，判断当前月份是否小于生日月份或者同一月中当天是否小于生日当天
 是 返回年份差-1  否 返回年份差
 */
- (NSInteger)getAgeFromBirthDay:(NSString*)birth
{
    //1992-07-02
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *myDate= [dateFormatter dateFromString:birth];
    if(myDate == nil){
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        myDate = [dateFormatter dateFromString:birth];
    }
    if (!myDate)
    {
        return 0;
    }
    // 出生日期转换 年月日
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:myDate];
    NSInteger brithDateYear  = [components1 year];
    NSInteger brithDateMonth = [components1 month];
    NSInteger brithDateDay   = [components1 day];

    // 获取系统当前 年月日
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger currentDateYear  = [components2 year];
    NSInteger currentDateMonth = [components2 month];
    NSInteger currentDateDay   = [components2 day];
    
    // 计算年龄
    NSInteger iAge = currentDateYear - brithDateYear;
    if ((currentDateMonth < brithDateMonth) || (currentDateMonth == brithDateMonth && currentDateDay < brithDateDay)) {
        //周岁是公历生日的第二天起算
        iAge--;
    }
    return iAge;
}

#pragma mark 字符串转成NSDate
/**
 字符串转成NSDate
 1: yyyy-MM-dd HH:mm:ss
 2: yyyy-MM-dd
 3: yyyy年MM月dd日
 4: yyyy-MM-dd HH:mm
 
*/
- (NSDate*)dateFromString:(NSString*)string withType:(NSInteger)type
{
    NSString *formatString;
    
    switch (type) {
        case 1:
            formatString = @"yyyy-MM-dd HH:mm:ss";
            break;
        case 2:
            formatString = @"yyyy-MM-dd";
            break;
        case 3:
            formatString = @"yyyy年MM月dd日";
            break;
        case 4:
            formatString = @"yyyy-MM-dd HH:mm";
            break;

        default:
            break;
    }
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:formatString];
    NSDate *date = [dateformatter dateFromString:string];
    return date;
}


#pragma mark  NSDate转成 "周几" 格式的字符串
/**
 NSDate转成 "周几" 格式的字符串
 
 @param date 传入的字符串
 @return NSString 生成的字符串
 */
- (NSString *)getweekStringFromDate:(NSDate *)date
{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];//设置成中国阳历
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;//设置时区
    comps = [calendar components:unitFlags fromDate:date];
    NSInteger weekNumber = [comps weekday]; //获取星期对应的长整形字符串
    
    NSString *weekDay;
    switch (weekNumber) {
        case 1:
            weekDay=@"周日";
            break;
        case 2:
            weekDay=@"周一";
            break;
        case 3:
            weekDay=@"周二";
            break;
        case 4:
            weekDay=@"周三";
            break;
        case 5:
            weekDay=@"周四";
            break;
        case 6:
            weekDay=@"周五";
            break;
        case 7:
            weekDay=@"周六";
            break;
            
        default:
            break;
    }
    return weekDay;
}

#pragma mark  生成 "刚刚/几分钟前/几小时前/几天前/" 格式的字符串
/**
 生成 "刚刚/几分钟前/几小时前/几天前/" 格式的字符串
 
 @param dateString 传入的字符串
 @return NSString 生成的字符串
 */
- (NSString*)prettyDateWithReference:(NSString*)dateString
{
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date = [dateformatter dateFromString:dateString];
    if (!date)
    {
        [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        date = [dateformatter dateFromString:dateString];
    }
    
    if (date)
    {
        NSTimeInterval secondsPerDay = 24 * 60 * 60;
        
        //修正8小时之差
        NSDate *date1 = [NSDate date];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate: date1];
        NSDate *localeDate = [date1  dateByAddingTimeInterval: interval];
        
        NSDate *today = localeDate;
        NSDate *yesterday;
        //今年
        yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
        
        // 10 first characters of description is the calendar date:
        NSString *todayString = [[today description] substringToIndex:10];
        NSString *yesterdayString = [[yesterday description] substringToIndex:10];
        
        NSString *dateDayString = [[date description] substringToIndex:10];
        
        NSString *dateContent;
        //今 昨 前天的时间
        NSString *time = [[date description] substringWithRange:(NSRange){11,5}];
        //其他时间
        NSString *time2 = [[date description] substringWithRange:(NSRange){5,11}];
        if ([dateDayString isEqualToString:todayString])
        {
            NSTimeInterval time = [today timeIntervalSinceDate:date];
            //******* 刚申请的时间应为1分钟内 *******
            if (time < 60) {
                dateContent = @"1分钟内";
            }
            else if(time >= 60 && time < 3600)
            {
                dateContent = [NSString stringWithFormat:@"%.f分钟前",time/60];
            }
            else if (time >= 3600)
            {
                dateContent = [NSString stringWithFormat:@"%.f小时前",time/3600];
            }
            return dateContent;
        }
        else if ([dateDayString isEqualToString:yesterdayString]){
            dateContent = [NSString stringWithFormat:@"昨天 %@",time];
            return dateContent;
        }
        else{
            return time2;
        }
        
    }
    else
        return dateString;
}

#pragma mark - 与当前时间做比较,判断是在当前时间之前，还是之后
/**
 与当前时间做比较,判断是在当前时间之前，还是之后
 
 @param compareTime 传入的字符串
 @return 布尔值 早于当前时间 NO   晚于当前时间 YES
 */
- (BOOL)compareNow:(NSString *)compareTime
{
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *compareDate = [dateformatter dateFromString:compareTime];
    
    NSDate *nowDate = [NSDate date];
    
    NSTimeInterval _comT = [compareDate timeIntervalSince1970]*1;
    NSTimeInterval _nowT = [nowDate timeIntervalSince1970]*1;
    
    if (_comT - _nowT > 0) {
        return YES;
    }else{
        return NO;
    }
}




@end
