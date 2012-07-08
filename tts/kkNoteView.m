//
//  kkNoteView.m
//  tts
//
//  Created by Wang Jinggang on 12-7-8.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

#import "kkNoteView.h"

@implementation kkNoteView

@synthesize label;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImage* rawImage = [UIImage imageNamed:@"bianqian.png"];
        UIImage* image = [rawImage stretchableImageWithLeftCapWidth:rawImage.size.width / 2 topCapHeight:rawImage.size.height / 2];
        UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:imageView];
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        [self addSubview:label];
        
    }
    return self;
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
