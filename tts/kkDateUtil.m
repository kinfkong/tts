//
//  kkDateUtil.m
//  tts
//
//  Created by Wang Jinggang on 12-7-1.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

#import "kkDateUtil.h"
#import "NSDate-Utilities.h"

@implementation kkDateUtil

+(NSString*) getTimeString:(NSString*) theTime forShort:(BOOL) isShort {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* date = [dateFormatter dateFromString:theTime];
    
    NSInteger hour = [date hour];
    NSInteger min = [date minute];
    
    NSString* result = nil;
    if ([date isToday]) {
        result = [NSString stringWithFormat:@"%@ %02d:%02d", @"今天", hour, min];
    } else if ([date isYesterday]) {
        result = [NSString stringWithFormat:@"%@ %02d:%02d", @"昨天", hour, min];
    } else if ([date isThisWeek]) {
        NSInteger weekDay = [date weekday];
        NSArray* weekName = [NSArray arrayWithObjects:
                             @"星期日", 
                             @"星期一",
                             @"星期二",
                             @"星期三",
                             @"星期四",
                             @"星期五",
                             @"星期六",
                             nil];
        result = [NSString stringWithFormat:@"%@ %02d:%02d", [weekName objectAtIndex:(weekDay - 1)], hour, min];
    } else if ([date isThisYear]) {
        NSInteger month = [date month];
        NSInteger day = [date day];
        result = [NSString stringWithFormat:@"%02d-%02d %02d:%02d", month, day, hour, min];
    } else {
        NSInteger year = [date year];
        NSInteger month = [date month];
        NSInteger day = [date day];
        if (!isShort) {
            result = [NSString stringWithFormat:@"%d-%02d-%02d %02d:%02d", year, month, day, hour, min];
        } else {
            result = [NSString stringWithFormat:@"%d-%02d-%02d", year, month, day];
        }
    }
    return result;
}

+(NSString*) getTimeString:(NSString*) theTime {
    return [kkDateUtil getTimeString:theTime forShort:NO];
}


@end
