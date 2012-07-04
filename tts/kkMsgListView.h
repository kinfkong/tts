//
//  kkMsgListView.h
//  tts
//
//  Created by Wang Jinggang on 12-6-24.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@protocol kkMsgListViewDelegate;

@interface kkMsgListView : UIView <UITableViewDelegate, UITableViewDataSource, EGORefreshTableHeaderDelegate> {
    UITableView* tableView;
    id<kkMsgListViewDelegate> delegate;
    EGORefreshTableHeaderView* _refreshHeaderView;
    BOOL _reloading;
    
    NSMutableArray* msgArray;
    NSString* currentUser;
    NSDictionary* chatRoomInfo;
}

@property(nonatomic, retain) id<kkMsgListViewDelegate> delegate;
@property(nonatomic, retain) NSMutableArray* msgArray;
@property(nonatomic, retain) NSString* currentUser;
@property(nonatomic, retain) NSDictionary* chatRoomInfo;

-(void) resizeHeight:(CGFloat) height;

-(void) appendMsgs:(NSArray *) newMsgs;

-(void) appendMsg:(id) msg;

-(void) updateMsg:(int) msg_id withStatus:(NSString *) status;

-(void) moveToBottom;

-(void) reloadData;

-(void) pushMsgs:(NSArray *) oldMsgs;
@end

@protocol kkMsgListViewDelegate <NSObject>

@optional
-(void) clickedMsgListview:(kkMsgListView *) msgListview;
-(void) headerWillLoad:(kkMsgListView *) msgListView;

@end
