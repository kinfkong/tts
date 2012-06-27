//
//  kkTestViewController.h
//  tts
//
//  Created by Wang Jinggang on 12-6-23.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "kkLongPolling.h"

@interface kkTestViewController : UIViewController {
    kkLongPolling* longPolling;
}

@property(nonatomic,retain) kkLongPolling* longPolling;

@end
