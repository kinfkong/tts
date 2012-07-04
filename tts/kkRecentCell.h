//
//  kkRecentCell.h
//  tts
//
//  Created by Wang Jinggang on 12-6-30.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "kkBadgeView.h"
#import "kkLastMsgView.h"

@interface kkRecentCell : UITableViewCell {
    kkBadgeView* badge;
    kkLastMsgView* lastMsgLabel;
    UILabel* nameLabel;
    UILabel* timeLabel;
}

-(void) setData:(NSDictionary *) data;


+(CGFloat) heightForCell;

@end
