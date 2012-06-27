//
//  kkProfileHeaderView.m
//  tts
//
//  Created by Wang Jinggang on 12-6-26.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

#import "kkProfileHeaderView.h"

@implementation kkProfileHeaderView

-(id) initWithFrame:(CGRect)frame image:(UIImage *) image type:(int) theType {
    self = [super initWithFrame:frame];
    if (self) {
        type = theType;
        if (image == nil) {
            image = [UIImage imageNamed:@"DefaultProfileHead.png"];
        }
        UIImageView* view = [[UIImageView alloc] initWithImage:image];
        view.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:view];
        questionMark = [[UIImageView alloc] initWithFrame:CGRectZero];
        questionMark.hidden = YES;
        questionMark.image = [UIImage imageNamed:@"question_mark.png"];
        [self addSubview:questionMark];
        [self setType:theType];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame image:nil type:0];
}

-(void) setType:(int) theType {
    type = theType;
    if (type == 1) {
        questionMark.hidden = NO;
        questionMark.frame = CGRectMake(self.frame.size.width - 18, self.frame.size.height - 18, 20, 20);
    } else {
        questionMark.hidden = YES;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
