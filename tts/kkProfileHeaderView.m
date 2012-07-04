//
//  kkProfileHeaderView.m
//  tts
//
//  Created by Wang Jinggang on 12-6-26.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

#import "kkProfileHeaderView.h"

@implementation kkProfileHeaderView 


-(id) initWithFrame:(CGRect)frame image:(UIImage *) image {
    self = [super initWithFrame:frame];
    if (self) {
        if (image == nil) {
            image = [UIImage imageNamed:@"DefaultProfileHead.png"];
        }
        UIImageView* view = [[UIImageView alloc] initWithImage:image];
        view.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:view];
        
        CGFloat questMarkSize = self.frame.size.width * 2 / 5;
        CGRect questFrame = CGRectMake(self.frame.size.width - questMarkSize * 0.8f, 
                                        self.frame.size.height - questMarkSize * 0.8f, questMarkSize, questMarkSize);
        questionMark = [[UIImageView alloc] initWithFrame:questFrame];
        questionMark.hidden = YES;
        questionMark.image = [UIImage imageNamed:@"question_mark.png"];
        [self addSubview:questionMark];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame image:nil];
}

-(void) setShowQuestionMark:(bool)showQuestionMark {
    questionMark.hidden = !showQuestionMark;
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
