//
//  kkLongPolling.h
//  tts
//
//  Created by Wang Jinggang on 12-6-22.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface kkLongPolling : NSObject <NSURLConnectionDataDelegate, NSURLConnectionDelegate> {
    NSString* pollingURL;
    NSURLConnection* conn;
    BOOL _starting;
}

@property (nonatomic, retain) NSString* pollingURL;
@property (nonatomic, retain) NSURLConnection* conn;

-(id) initWithPollingURL:(NSString *) pollingURL moduleInfo:(NSArray *) array;
-(void) startPolling;
-(void) stopPolling;



@end
