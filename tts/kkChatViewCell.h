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

@interface kkChatViewCell : UITableViewCell {
    NSDictionary* msgData;
    kkBubbleLabel* msgLabel;
    int type;
    UIActivityIndicatorView * loadingView;
    kkProfileHeaderView* profileView;
    UILabel* timeLable;
}

@property(nonatomic, retain) NSDictionary* msgData;

+(CGFloat) heightForCell:(NSDictionary *) data;

@end
