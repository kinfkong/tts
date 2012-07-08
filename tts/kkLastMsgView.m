//
//  kkLastMsgView.m
//  tts
//
//  Created by Wang Jinggang on 12-7-1.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

#import "kkLastMsgView.h"

@implementation kkLastMsgView

@synthesize label;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.height, frame.size.height)];
        [self addSubview:imageView];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:label];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor grayColor];
    }
    return self;
}


-(void) setText:(NSString *) text status:(NSString*) status {
    //NSLog(@"the status:%@", status);
    CGFloat orix = 0;
    if ([status isEqualToString:@"sending"] || [status isEqualToString:@"send_failed"] ) {
        NSString* imageName = [NSString stringWithFormat:@"%@_status.png", status];
        imageView.image = [UIImage imageNamed:imageName];
        orix += imageView.frame.size.width;
        imageView.hidden = NO;
    } else {
        imageView.hidden = YES;
    }
    label.frame = CGRectMake(orix, 0, self.frame.size.width - orix, self.frame.size.height);
    label.text = text;
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
