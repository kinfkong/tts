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
}

@property(nonatomic, retain) id<kkMsgListViewDelegate> delegate;
@property(nonatomic, retain) NSMutableArray* msgArray;
@property(nonatomic, retain) NSString* currentUser;

-(void) resizeHeight:(CGFloat) height;

-(void) appendMsgs:(NSArray *) newMsgs;

-(void) appendMsg:(id) msg;

-(void) updateMsg:(NSString*) innerMsgId withStatus:(NSString *) status;

-(void) moveToBottom;

@end

@protocol kkMsgListViewDelegate <NSObject>

@optional
-(void) clickedMsgListview:(kkMsgListView *) msgListview;

@end
