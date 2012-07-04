//
//  kkLastMsgView.h
//  tts
//
//  Created by Wang Jinggang on 12-7-1.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface kkLastMsgView : UIView {
    UIImageView* imageView;
    UILabel* label;
}

@property(nonatomic, retain) UILabel* label;

-(void) setText:(NSString *) text status:(NSString*) status;

@end
