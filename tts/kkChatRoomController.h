//
//  kkChatRoomController.h
//  tts
//
//  Created by Wang Jinggang on 12-6-24.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "kkMsgListView.h"
#import "kkGrowTextView.h"

@interface kkChatRoomController : UIViewController <kkGrowTextViewDelegate,kkMsgListViewDelegate> {
    kkMsgListView* msgListView;
    kkGrowTextView* editTextView;
    CGFloat keyboardHeight;
    int cr_id;
}
-(id) initWithChatRoomId:(int) cr_id;


@property (nonatomic, retain) kkMsgListView* msgListView;
@property (nonatomic, retain) kkGrowTextView* editTextView;

@end
