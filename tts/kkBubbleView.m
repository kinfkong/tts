//
//  kkBubbleView.m
//  tts
//
//  Created by Wang Jinggang on 12-6-24.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

#import "kkBubbleView.h"

@implementation kkBubbleView


- (id)initWithFrame:(CGRect)frame
{
    
    images = [[NSMutableArray alloc] init];
    for (int i = 0; i < 9; i++) {
        NSString* imageName = [NSString stringWithFormat:@"chat_bubble_green_%02d.png", i + 1];
        UIImage* image = [UIImage imageNamed:imageName];
        [images addObject:image];
    }
    minHeight = 0;
    minWidth = 0;
    for (int i = 0; i < 3; i++) {
        minWidth += ((UIImage *) [images objectAtIndex:i]).size.width;
    }
    for (int i = 0; i < 3; i++) {
        minHeight += ((UIImage *) [images objectAtIndex:i * 3]).size.height;
    }
    

    
    topMargin = 5;
    leftMargin = 5;
    buttomMargin = 5;
    rightMargin = 5;
    
    if (frame.size.width < minWidth) {
        frame.size.width = minWidth;
    }
    if (frame.size.height < minHeight) {
        frame.size.height = minHeight;
    }
    
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat curY = 0;
        for (int i = 0; i < 3; i++) {
            CGFloat curX = 0;
            CGFloat lineHeight = 0;
            if (i == 0 || i == 2) {
                lineHeight = ((UIImage *) [images objectAtIndex:i * 3]).size.height;
            } else {
                lineHeight = frame.size.height - ((UIImage *) [images objectAtIndex:0]).size.height - ((UIImage *) [images objectAtIndex:6]).size.height;
            }
            
            for (int j = 0; j < 3; j ++) {
                CGFloat columnWidth = 0;
                if (j == 0 || j == 2) {
                    columnWidth = ((UIImage *) [images objectAtIndex:j]).size.width;
                } else {
                    columnWidth = frame.size.width - ((UIImage *) [images objectAtIndex:0]).size.width - ((UIImage *) [images objectAtIndex:2]).size.width;
                }
                UIImageView* imageView = [[UIImageView alloc] initWithImage:[images objectAtIndex:i * 3 + j]];
                CGRect rect;
                rect.size.width = columnWidth;
                rect.size.height = lineHeight;
                rect.origin.x = curX;
                rect.origin.y = curY;
                imageView.frame = rect;
                imageView.contentMode = UIViewContentModeScaleToFill;
                [self addSubview:imageView];
                
                curX += rect.size.width;
            }
            curY += lineHeight;
        }    
    }
    
    return self;
}

-(void) setFrame:(CGRect)frame {
    if (frame.size.width < minWidth) {
        frame.size.width = minWidth;
    }
    if (frame.size.height < minHeight) {
        frame.size.height = minHeight;
    }
    
    [super setFrame:frame];
    
        CGFloat curY = 0;
        for (int i = 0; i < 3; i++) {
            CGFloat curX = 0;
            CGFloat lineHeight = 0;
            if (i == 0 || i == 2) {
                lineHeight = ((UIImage *) [images objectAtIndex:i * 3]).size.height;
            } else {
                lineHeight = frame.size.height - ((UIImage *) [images objectAtIndex:0]).size.height - ((UIImage *) [images objectAtIndex:6]).size.height;
            }
            
            for (int j = 0; j < 3; j ++) {
                CGFloat columnWidth = 0;
                if (j == 0 || j == 2) {
                    columnWidth = ((UIImage *) [images objectAtIndex:j]).size.width;
                } else {
                    columnWidth = frame.size.width - ((UIImage *) [images objectAtIndex:0]).size.width - ((UIImage *) [images objectAtIndex:2]).size.width;
                }
                UIImageView* imageView = [[UIImageView alloc] initWithImage:[images objectAtIndex:i * 3 + j]];
                CGRect rect;
                rect.size.width = columnWidth;
                rect.size.height = lineHeight;
                rect.origin.x = curX;
                rect.origin.y = curY;
                imageView.frame = rect;
                imageView.contentMode = UIViewContentModeScaleToFill;
                [self addSubview:imageView];
                
                curX += rect.size.width;
            }
            curY += lineHeight;
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
