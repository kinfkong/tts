//
//  kkBubbleLabel.h
//  tts
//
//  Created by Wang Jinggang on 12-6-27.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kkBubbleGrayStyle,
    kkBubbleGreenStyle
} kkBubbleLabelStyle;

@interface kkBubbleLabel : UIView {
    NSArray* rs;
    NSArray* cs;
    NSArray* images;
    CGSize minSize;
    UILabel* label;
    CGPoint labelOrigin;
}

@property (nonatomic, retain) NSArray* padding;
@property (nonatomic, retain) NSArray* rs;
@property (nonatomic, retain) NSArray* cs;
@property (nonatomic, retain) NSArray* images;

-(void) useStype:(kkBubbleLabelStyle) stype;

-(void) setText:(NSString *)text align:(int) isLeft;

+(CGFloat) heightForText:(NSString *) text;

@end
