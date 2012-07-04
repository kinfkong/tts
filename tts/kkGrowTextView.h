//
//  kkGrowTextView.h
//  tts
//
//  Created by Wang Jinggang on 12-6-24.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GradientButton.h"
#import "UIGlossyButton.h"

#import "HPGrowingTextView.h"


@protocol kkGrowTextViewDelegate;

@interface kkGrowTextView : UIView <HPGrowingTextViewDelegate> {
    HPGrowingTextView* msgTextView;
    //CGFloat oriHeight;
    //CGFloat maxHeight;
    UIGlossyButton* sendButton;
    id<kkGrowTextViewDelegate> delegate;
}


@property (nonatomic, retain) id<kkGrowTextViewDelegate> delegate;
@property (readonly) HPGrowingTextView* msgTextView;

-(void) moveTo:(CGFloat) y;

@end

@protocol kkGrowTextViewDelegate <NSObject>

@optional

-(void) textView:(kkGrowTextView *) textView frameDidChanged:(CGRect) frame;
-(void) textView:(kkGrowTextView *) textview sendMsg:(NSString *) msg;

@end

