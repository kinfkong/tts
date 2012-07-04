//
//  kkBadgeView.m
//  tts
//
//  Created by Wang Jinggang on 12-6-30.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

#import "kkBadgeView.h"

@implementation kkBadgeView

#define KKBADGE_FONT ([UIFont boldSystemFontOfSize:14])

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImage* rawImage = [UIImage imageNamed:@"badge.png"];
        UIImage* image = [rawImage stretchableImageWithLeftCapWidth:rawImage.size.width / 2 topCapHeight:rawImage.size.height / 2];
        imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:imageView];
        //imageView.backgroundColor = [UIColor blackColor];
        NSString* testBadge = @"1";
        CGSize theSize = [testBadge sizeWithFont:KKBADGE_FONT
                           constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) 
                               lineBreakMode:UILineBreakModeWordWrap];

        margin = imageView.frame.size.width - theSize.width;
        
        CGRect rect = CGRectMake((imageView.frame.size.width - theSize.width) / 2., (imageView.frame.size.height - theSize.height) / 2., theSize.width, theSize.height);
        
        label = [[UILabel alloc] initWithFrame:rect];
        label.text = testBadge;
        // label.textAlignment = UITextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.font = KKBADGE_FONT;
        label.textColor = [UIColor whiteColor];
        [imageView addSubview:label];
        
        imageView.hidden = YES;
    }
    return self;
}

-(void) setBadge:(NSString *) badge {
    if (badge != nil) {
        imageView.hidden = NO;
    } else {
        imageView.hidden = YES;
        return;
    }
    CGSize theSize = [badge sizeWithFont:KKBADGE_FONT
                           constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) 
                               lineBreakMode:UILineBreakModeWordWrap];
    CGFloat imageViewWidth = theSize.width + margin;
    if (imageViewWidth < imageView.frame.size.height) {
        imageViewWidth = imageView.frame.size.height;
    }
    CGRect rect = CGRectMake(imageView.frame.origin.x + imageView.frame.size.width - imageViewWidth, imageView.frame.origin.y, imageViewWidth, imageView.frame.size.height);
    imageView.frame = rect;
    rect = CGRectMake((imageView.frame.size.width - theSize.width) / 2., (imageView.frame.size.height - theSize.height) / 2., theSize.width, theSize.height);
    label.frame = rect;
    label.text = badge;
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
