//
//  kkMsgDataMgr.m
//  tts
//
//  Created by Wang Jinggang on 12-6-30.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

#import "kkMsgDataMgr.h"


@interface kkMsgDataMgr (private) 
-(void) initDB:(NSString*) dbName;
@end

@implementation kkMsgDataMgr

static kkMsgDataMgr* theInstance = nil;

-(id) init {
    self = [super init];
    if (self) {
        NSString* user_id = @"11111111";
        NSString* dbName = [NSString stringWithFormat:@"%@.db", user_id];
        [self initDB:dbName];
        observers = [[NSMutableDictionary alloc] init];
    }
    return self;
}
+(kkMsgDataMgr *) getInstance {
    if (theInstance == nil) {
        theInstance = [[kkMsgDataMgr alloc] init];
    }
    return theInstance;
}


-(void) dealloc {
    [db close];
}

-(void) initDB:(NSString*) dbName {
    NSArray *documentsPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory   
                                                                    , NSUserDomainMask    
                                                                    , YES);    
    NSString *databaseFilePath = [[documentsPaths objectAtIndex:0] stringByAppendingPathComponent:dbName];
    
    db = [FMDatabase databaseWithPath:databaseFilePath];
    
    if (![db open]) {
        return;
    }
    
    // create the tables
    NSString* createChatRoomSql = @"CREATE TABLE if not exists chat_room ( \
        cr_id bigint not null, \
        user_id bigint not null default 0, \
        user_name varchar(128) not null,\
        user_gender int not null, \
        my_name varchar(128) not null,\
        unread int not null default 0,\
        msg_id bigint not null, \
        user_profile_url varchar(512) not null default '', \
        my_profile_url varchar(512) not null default '', \
        primary key (cr_id)\
        );";
    NSString* createMsgSql = @"CREATE TABLE if not exists msg (\
            id integer not null primary key autoincrement, \
            text varchar(2048) not null default '', \
            status varchar(64) not null default 'normal',\
            create_time timestamp not null default CURRENT_TIMESTAMP,\
            sender int not null, \
            cr_id bigint not null);";
    if (![db executeUpdate:createChatRoomSql]) {
        NSLog(@"failed to create table:%@", [db lastErrorMessage]);
    } 
    if (![db executeUpdate:createMsgSql]) {
        NSLog(@"failed to create msg table:%@", [db lastErrorMessage]);
    }
}


-(NSArray*) getChatRoomList {
    NSMutableArray* array = [[NSMutableArray alloc] init];
    NSString* sql = @"select chat_room.cr_id,text,user_name,user_profile_url,create_time,status,unread from chat_room inner join msg on chat_room.msg_id = msg.id order by msg_id desc limit 50;";
    
    FMResultSet *s = [db executeQuery:sql];
    while ([s next]) {
        //retrieve values for each record
        int cr_id = [s intForColumnIndex:0];
        NSString *text = [s stringForColumnIndex:1];
        NSString* user_name = [s stringForColumnIndex:2];
        NSString* user_profile_url = [s stringForColumnIndex:3];
        NSString* create_time = [s stringForColumnIndex:4];
        NSString* status = [s stringForColumnIndex:5];
        int unread = [s intForColumnIndex:6];
        NSDictionary* item = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:cr_id], @"cr_id",
                              text, @"text",
                              user_name, @"user_name",
                              user_profile_url, @"user_profile_url",
                              create_time, @"create_time",
                              status, @"status",
                              [NSNumber numberWithInt:unread], @"unread",
                              nil];
        [array addObject:item];
        
    }
    return array;
    
}

-(NSDictionary*) getChatRoomInfo:(int) cr_id {
    NSString* sql = @"select * from chat_room where cr_id=%d order by msg_id DESC";
    FMResultSet* s = [db executeQueryWithFormat:sql, cr_id];
    NSDictionary* dict = nil;
    if ([s next]) {
        dict = [s resultDictionary];
    }
    //NSLog(@"the result dict:%@", dict);
    return dict;
}

-(NSArray*) getMoreMsgsForChatRoom:(int) cr_id lastId:(int) last_id {
    
    NSMutableArray* result = [[NSMutableArray alloc] init];
    FMResultSet* s = nil;
    if (last_id >= 0) {
        NSString* sql = @"select * from (select * from msg where cr_id=%d and id < %d order by id DESC limit 10) order by id ASC";
        s = [db executeQueryWithFormat:sql, cr_id, last_id]; 
    } else {
        NSString* sql = @"select * from (select * from msg where cr_id=%d order by id DESC limit 10) order by id ASC";
        s = [db executeQueryWithFormat:sql, cr_id]; 
    }
    if (!s) {
        NSLog(@"failed to do sql:%@", [db lastErrorMessage]);
        return result;
    }
    
    while ([s next]) {
        [result addObject:[s resultDictionary]];
    }
    //NSLog(@"the chat room msgs: %@", result);
    return result;
}


-(void) insertChatRoomInfo:(NSDictionary*) dict {
    NSString* sql = @"insert or replace into chat_room (cr_id,user_id,user_name,user_gender,user_profile_url,my_name,my_profile_url,msg_id,unread) values (:cr_id,:user_id,:user_name,:user_gender,:user_profile_url,:my_name,:my_profile_url,:msg_id,:unread);";
    if (![db executeUpdate:sql withParameterDictionary:dict]) {
        NSLog(@"failed to insert to chat room:%@", [db lastErrorMessage]);
        return;
    }
}

-(int) insertMsg:(NSDictionary*) msg toChatRoom:(int) cr_id {
    NSMutableDictionary* newMsg = [NSMutableDictionary dictionaryWithDictionary:msg];
    [newMsg setObject:[NSNumber numberWithInt:cr_id] forKey:@"cr_id"];
    if (![db executeUpdate:@"insert into msg (text, create_time, status, sender, cr_id) values(:text, DATETIME(:create_time), :status, :sender, :cr_id);" withParameterDictionary:newMsg]) {
        NSLog(@"failed to insert msg:%@", [db lastErrorMessage]);
        return -1;
    }
    //NSLog(@"success to insert msg.");
    NSString* sql = @"select last_insert_rowid()";
    FMResultSet *s = [db executeQuery:sql];
    int msg_id = -1;
    if ([s next]) {
        msg_id = [s intForColumnIndex:0];
        if (msg_id <= 0) {
            return -1;
        }
        
    }
    return msg_id;
}

-(void) receivedMsgs:(NSArray *) msgs {
    for (int i = 0; i < [msgs count]; i++) {
        NSDictionary* msg = [msgs objectAtIndex:i];
        NSDictionary* chatInfo = [msg objectForKey:@"chatinfo"];
        NSArray* ms = [msg objectForKey:@"msgs"];
        [self insertNewMsgs:chatInfo msgs:ms];
    }

    NSArray* os = [observers objectForKey:[NSNumber numberWithInt:kkMsgDataReceivedNewMsgs]];
    
    for (int i = 0; i < [os count]; i++) {
        id o = [os objectAtIndex:i];
        //NSLog(@"the observer:%@", o);
        if (o && [o respondsToSelector:@selector(onReceivedMsgs:)]) {
           
            [o performSelector:@selector(onReceivedMsgs:) withObject:msgs];
        }
    }
}

-(void) insertNewMsgs:(NSDictionary *) chatRoomInfo msgs:(NSArray *) msgs {
    if ([msgs count] == 0) {
        return;
    }
    int unread = [msgs count];
    NSMutableDictionary* info = [NSMutableDictionary dictionaryWithDictionary:chatRoomInfo];
    int cr_id = [[chatRoomInfo objectForKey:@"cr_id"] intValue];
    NSDictionary* dict = [self getChatRoomInfo:cr_id];
    if (dict != nil) {
        unread += [(NSNumber *)[dict objectForKey:@"unread"] intValue];
    }
    [info setObject:[NSNumber numberWithInt:unread] forKey:@"unread"];
    for (int i = 0; i < [msgs count]; i++) {
        NSDictionary* msg = [msgs objectAtIndex:i];
        int msg_id = [self insertMsg:msg toChatRoom:cr_id];
        if (msg_id < 0) {
            NSLog(@"failed to insert msg");
            continue;
        }
        if (i + 1 == [msgs count]) {
            [info setObject:[NSNumber numberWithInt:msg_id]  forKey:@"msg_id"];
        }
    }
    [self insertChatRoomInfo:info];
}

-(void) addObserver:(NSObject *)observer event:(kkMsgDataEvent) event {
    NSMutableArray* eventObs = [observers objectForKey:[NSNumber numberWithInt:event]];
    if (eventObs == nil) {
        eventObs = [[NSMutableArray alloc] init];
    }
    if (![eventObs containsObject:observer]) {
        [eventObs addObject:observer];
    }
    [observers setObject:eventObs forKey:[NSNumber numberWithInt:event]];
}

-(void) removeObserver:(NSObject *) observer event:(kkMsgDataEvent) event {
    NSMutableArray* eventObs = [observers objectForKey:[NSNumber numberWithInt:event]];
    if (eventObs == nil) {
        return;
    }
    [eventObs removeObject:observer];
    [observers setObject:eventObs forKey:[NSNumber numberWithInt:event]];
}

-(NSArray*) getMsgsForChatRoom:(int) cr_id {
    NSMutableArray* result = [[NSMutableArray alloc] init];
    NSString* sql = @"select * from (select * from msg where cr_id=%d order by id DESC limit 10) order by id ASC";
    FMResultSet* s = [db executeQueryWithFormat:sql, cr_id]; 
    if (!s) {
        NSLog(@"failed to do sql:%@", [db lastErrorMessage]);
        return result;
    }
    
    while ([s next]) {
        [result addObject:[s resultDictionary]];
    }
    //NSLog(@"the chat room msgs: %@", result);
    return result;
}

-(void) updateChatRoom:(int) cr_id lastMsgId:(int) msg_id {
    NSString* sql = @"update chat_room set msg_id=%d where cr_id=%d";
    if (![db executeUpdateWithFormat:sql, msg_id, cr_id]) {
        NSLog(@"failed to update the sql:%@", sql);
        return;
    }
}

-(void) updateMsg:(int) msg_id status:(NSString*) status {
    NSString* sql = @"update msg set status=%@ where id=%d";
    if (![db executeUpdateWithFormat:sql, status, msg_id]) {
        NSLog(@"failed to update the sql:%@", sql);
        return;
    }
}

-(void) finishedSendingMsg:(NSDictionary *) sendResult {
    int msg_id = [(NSNumber *) [sendResult objectForKey:@"msg_id"] intValue];
    NSString* status = [sendResult objectForKey:@"status"];
    [self updateMsg:msg_id status:status];
    NSArray* os = [observers objectForKey:[NSNumber numberWithInt:kkMsgDataMgrMsgDidSend]];
    
    for (int i = 0; i < [os count]; i++) {
        id o = [os objectAtIndex:i];
        //NSLog(@"the observer:%@", o);
        if (o && [o respondsToSelector:@selector(onMsgDidSend:)]) {
            
            [o performSelector:@selector(onMsgDidSend:) withObject:sendResult];
        }
    }
}

-(void) sendMsg:(NSString*) text inChatRoom:(int) cr_id {
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:text forKey:@"text"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* timeString = [dateFormatter stringFromDate:[NSDate date]];
    [dict setObject:timeString forKey:@"create_time"];
    [dict setObject:@"sending" forKey:@"status"];
    [dict setObject:[NSNumber numberWithInt:1] forKey:@"sender"];
    int msg_id = [self insertMsg:dict toChatRoom:cr_id];
    if (msg_id <= 0) {
        NSLog(@"failed to insert msg");
        return;
    }
    [dict setObject:[NSNumber numberWithInt:msg_id] forKey:@"id"];
    [self updateChatRoom:cr_id lastMsgId:msg_id];
    
    NSArray* os = [observers objectForKey:[NSNumber numberWithInt:kkMsgDataMgrMsgSending]];
    
    for (int i = 0; i < [os count]; i++) {
        id o = [os objectAtIndex:i];
        //NSLog(@"the observer:%@", o);
        if (o && [o respondsToSelector:@selector(onMsgWillSend:inChatRoom:)]) {
            
            [o performSelector:@selector(onMsgWillSend:inChatRoom:) withObject:dict withObject:[NSNumber numberWithInt:cr_id]];
        }
    }
    
    // send the msg remote: TODO
    // mock here
    NSMutableDictionary* sendResult = [[NSMutableDictionary alloc] init];
    [sendResult setObject:[NSNumber numberWithInt:msg_id] forKey:@"msg_id"];
    [sendResult setObject:@"send_failed" forKey:@"status"];
    [sendResult setObject:[NSNumber numberWithInt:cr_id] forKey:@"cr_id"];
    [self performSelector:@selector(finishedSendingMsg:) withObject:sendResult afterDelay:3];
}

-(void) markAllRead:(int) cr_id {
    NSString* sql = @"update chat_room set unread=0 where cr_id=%d";
    if (![db executeUpdateWithFormat:sql, cr_id]) {
        NSLog(@"failed to mark all read.");
        return;
    }
    
    // send the remote TODO
    NSArray* os = [observers objectForKey:[NSNumber numberWithInt:kkMsgDataMgrUnReadChange]];
    
    for (int i = 0; i < [os count]; i++) {
        id o = [os objectAtIndex:i];
        //NSLog(@"the observer:%@", o);
        if (o && [o respondsToSelector:@selector(onUnreadChange:)]) {
            
            [o performSelector:@selector(onUnreadChange:) withObject:[NSNumber numberWithInt:cr_id]];
        }
    }
}


@end
