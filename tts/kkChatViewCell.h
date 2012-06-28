//
//  kkChatViewCell.h
//  tts
//
//  Created by Wang Jinggang on 12-6-26.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "kkProfileHeaderView.h"
#import "kkBubbleLabel.h"

enum {
    kkChatViewShowTime = (1 << 0),
    kkChatViewShowMsg = (1 << 1),
    kkChatViewShowStatus = (1 << 2),
    kkChatViewShowAll = (1 << 10) - 1,
};

@interface kkChatViewCell : UITableViewCell {
    kkBubbleLabel* msgLabel;
    int type;
    UIActivityIndicatorView * loadingView;
    kkProfileHeaderView* profileView;
    UILabel* timeLable;
    UILabel* statusLabel;
}

-(void) setMsgData:(NSDictionary *)msgData show:(int) what;

+(CGFloat) heightForCell:(NSDictionary *) data show:(int) what;
+(CGFloat) heightForCell:(NSDictionary *) data;

@end
