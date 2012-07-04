//
//  kkMsgDataMgr.h
//  tts
//
//  Created by Wang Jinggang on 12-6-30.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

typedef enum {
    kkMsgDataReceivedNewMsgs,
    kkMsgDataMsgUpdated,
    
    kkMsgDataMgrMsgSending,
    kkMsgDataMgrMsgDidSend,
} kkMsgDataEvent;

@interface kkMsgDataMgr : NSObject {
    FMDatabase* db;
    NSMutableDictionary* observers;
}

+(kkMsgDataMgr *) getInstance;

-(NSArray*) getChatRoomList;

-(NSArray*) getMsgsForChatRoom:(int) cr_id;
-(NSArray*) getMoreMsgsForChatRoom:(int) cr_id lastId:(int) last_id;

-(void) insertNewMsgs:(NSDictionary *) chatRoomInfo msgs:(NSArray *) msgs;
-(NSDictionary*) getChatRoomInfo:(int) cr_id;

-(void) addObserver:(NSObject *)observer event:(kkMsgDataEvent) event;

-(void) removeObserver:(NSObject *) observer event:(kkMsgDataEvent) event;

-(void) receivedMsgs:(NSArray *) msgs;

-(void) sendMsg:(NSString*) text inChatRoom:(int) cr_id;

@end
