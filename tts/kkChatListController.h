//
//  kkChatListController.h
//  tts
//
//  Created by Wang Jinggang on 12-6-24.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface kkChatListController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    UITableView* tableView;
    NSArray* chatList;
}

@end
