//
//  kkDateUtil.h
//  tts
//
//  Created by Wang Jinggang on 12-7-1.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface kkDateUtil : NSObject
+(NSString*) getTimeString:(NSString*) theTime;
+(NSString*) getTimeString:(NSString*) theTime forShort:(BOOL) isShort;
@end
