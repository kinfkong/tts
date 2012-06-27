//
//  kkBubbleLabel.m
//  tts
//
//  Created by Wang Jinggang on 12-6-27.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

#import "kkBubbleLabel.h"

#define KKCHATCELL_FONT ([UIFont systemFontOfSize:17])
#define KKCHATCELL_MAX_WIDTH 200


@interface kkGlobalChatInfo : NSObject {
    UIImage* image;
    CGFloat vPadding;
    CGFloat hPadding;
}

@property(nonatomic, retain) UIImage* image;
@property(atomic, assign) CGFloat vPadding;
@property(atomic, assign) CGFloat hPadding;

@end

@implementation kkGlobalChatInfo

@synthesize image;
@synthesize vPadding;
@synthesize hPadding;

@end



@implementation kkBubbleLabel

@synthesize images;
@synthesize rs;
@synthesize cs; 
@synthesize padding;

static kkGlobalChatInfo* gInfo = nil;

+(kkGlobalChatInfo *) getInfo {
    if (gInfo == nil) {
        gInfo = [[kkGlobalChatInfo alloc] init];
        UIImage* image = [UIImage imageNamed:@"chat_bubbles.png"];
        gInfo.image = image;
        gInfo.vPadding = 25;
        gInfo.hPadding = 30;
    }
    return gInfo;
}

- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect {
    rect.size.height = rect.size.height * [image scale];
    rect.size.width = rect.size.width * [image scale];
    rect.origin.x = rect.origin.x * [image scale];
    rect.origin.y = rect.origin.y * [image scale];
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:[image scale] orientation:[image imageOrientation]];
    CGImageRelease(newImageRef);
    return newImage;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void) useBackgrouImage:(UIImage *) _image rowSplit:(NSArray*) _rs columnSplit:(NSArray *) _cs labelOrigin:(CGPoint) _labelOrigin {
   
    CGSize bgSize = _image.size;
    
    //NSLog(@"bg size:%.3lf,%.3lf", bgSize.width, bgSize.height);
    minSize = bgSize;
    NSMutableArray* theRs = [[NSMutableArray alloc] init];
    [theRs addObject:[NSNumber numberWithFloat:0]];
    for (int i = 0; i < 2; i++) {
        [theRs addObject:[_rs objectAtIndex:i]];
    }
    [theRs addObject:[NSNumber numberWithFloat:bgSize.height]];
    
    
    NSMutableArray* theCs = [[NSMutableArray alloc] init];
    [theCs addObject:[NSNumber numberWithFloat:0]];
    for (int i = 0; i < 2; i++) {
        [theCs addObject:[_cs objectAtIndex:i]];
    }
    [theCs addObject:[NSNumber numberWithFloat:bgSize.width]];
    
    self.rs = theRs;
    self.cs = theCs;
    labelOrigin = _labelOrigin;
    NSMutableArray* array = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.rs count] - 1; i++) {
        for (int j = 0; j < [self.cs count] - 1; j++) {
            CGFloat width = [(NSNumber *) [self.cs objectAtIndex:(j + 1)] floatValue]- [(NSNumber *) [self.cs objectAtIndex:j] floatValue];
            CGFloat height = [(NSNumber *) [self.rs objectAtIndex:(i + 1)] floatValue]- [(NSNumber *) [self.rs objectAtIndex:i] floatValue];
            CGFloat x = [(NSNumber *) [self.cs objectAtIndex:j] floatValue];
            CGFloat y = [(NSNumber *) [self.rs objectAtIndex:i] floatValue];
            CGRect rect = CGRectMake(x, y, width, height);
            //NSLog(@"width, height:%.3lf,%3.lf", width, height);
            UIImage* splitImage = [self imageFromImage:_image inRect:rect];
            UIImageView* imageView = [[UIImageView alloc] initWithImage:splitImage];
            imageView.frame = rect;
            [self addSubview:imageView];
            [array addObject:imageView];
        }
    }
    CGRect newFrame = self.frame;
    newFrame.size = bgSize;
    self.frame = newFrame;
    self.images = array;
    
    
    // Initialization code
    label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.font = KKCHATCELL_FONT;
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.lineBreakMode = UILineBreakModeWordWrap;
    
    [self addSubview:label];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void) useStype:(kkBubbleLabelStyle) stype {
     kkGlobalChatInfo* info = [kkBubbleLabel getInfo];
    UIImage* image = info.image;
    CGRect rect;
    NSArray* rowSplit = nil;
    NSArray* columnSplit = nil; 
    CGPoint _labelOrigin;
    if (stype == kkBubbleGrayStyle) {
        rect = CGRectMake(0, 0, image.size.width / 2, image.size.height);
        rowSplit = [NSArray arrayWithObjects:[NSNumber numberWithFloat:30], [NSNumber numberWithFloat:32], nil];
        columnSplit = [NSArray arrayWithObjects:[NSNumber numberWithFloat:12], [NSNumber numberWithFloat:40], nil];
        _labelOrigin = CGPointMake(11, 10);
    } else {
        rect = CGRectMake(image.size.width / 2, 0, image.size.width / 2, image.size.height);
        rowSplit = [NSArray arrayWithObjects:[NSNumber numberWithFloat:30], [NSNumber numberWithFloat:32], nil];
        columnSplit = [NSArray arrayWithObjects:[NSNumber numberWithFloat:21], [NSNumber numberWithFloat:50], nil];
        _labelOrigin = CGPointMake(20, 10);
    }
    UIImage* splitImage = [self imageFromImage:image inRect:rect];

    [self useBackgrouImage:splitImage rowSplit:rowSplit columnSplit:columnSplit labelOrigin:_labelOrigin];
    // [self reSetFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, 200, 100)];
}

-(void) reSetFrame:(CGRect) frame {
    if (frame.size.width < minSize.width) {
        frame.size.width = minSize.width;
    }
    if (frame.size.height < minSize.height) {
        frame.size.height = minSize.height; 
    }
    self.frame = frame;
    CGFloat x1 = [(NSNumber *) [self.cs objectAtIndex:1] floatValue];
    CGFloat x2 = frame.size.width - minSize.width + [(NSNumber *) [self.cs objectAtIndex:2] floatValue];
    
    
    
    CGFloat y1 = [(NSNumber *) [self.rs objectAtIndex:1] floatValue];
    CGFloat y2 = frame.size.height - minSize.height + [(NSNumber *) [self.rs objectAtIndex:2] floatValue];
    
    //NSLog(@"x[%.3lf,%.3lf]y[%.3lf,%.3lf]", x1, x2, y1, y2);
    UIImageView* view = [images objectAtIndex:0];
    view.frame = CGRectMake(0, 0, x1, y1);
    view = [images objectAtIndex:1];
    view.frame = CGRectMake(x1, 0, x2 - x1, y1);
    view = [images objectAtIndex:2];
    view.frame = CGRectMake(x2, 0, frame.size.width - x2, y1);
    
    view = [images objectAtIndex:3];
    view.frame = CGRectMake(0, y1, x1, y2 - y1);
    view = [images objectAtIndex:4];
    view.frame = CGRectMake(x1, y1, x2 - x1, y2 - y1);
    view = [images objectAtIndex:5];
    view.frame = CGRectMake(x2, y1, frame.size.width - x2, y2 - y1);
    
    view = [images objectAtIndex:6];
    view.frame = CGRectMake(0, y2, x1, frame.size.height - y2);
    view = [images objectAtIndex:7];
    view.frame = CGRectMake(x1, y2, x2 - x1, frame.size.height - y2);
    view = [images objectAtIndex:8];
    view.frame = CGRectMake(x2, y2, frame.size.width - x2, frame.size.height - y2);
    
}

-(void) setText:(NSString *)text align:(int) isLeft {
    kkGlobalChatInfo* info = [kkBubbleLabel getInfo];
    CGFloat maxTextWidth = KKCHATCELL_MAX_WIDTH - info.hPadding;
    CGSize labelSize = [text sizeWithFont:KKCHATCELL_FONT
                       constrainedToSize:CGSizeMake(maxTextWidth, MAXFLOAT) 
                           lineBreakMode:UILineBreakModeWordWrap];
    CGRect rect = self.frame;
    rect.size.width = labelSize.width + info.hPadding;
    rect.size.height = labelSize.height + info.vPadding;
    if (rect.size.width < minSize.width) {
        rect.size.width = minSize.width;
    }
    if (rect.size.height < minSize.height) {
        rect.size.height = minSize.height; 
    }
    if (!isLeft) {
        rect.origin.x = self.frame.origin.x + self.frame.size.width - rect.size.width;
    }
    [self reSetFrame:rect];
    label.frame = CGRectMake(labelOrigin.x, labelOrigin.y, labelSize.width, labelSize.height);
    //NSLog(@"frame[%.3lf,%.3lf,%.3lf,%.3lf", label.frame.origin.x, label.frame.origin.y, label.frame.size.width, label.frame.size.height);
    label.text = text;
}

+(CGFloat) heightForText:(NSString *) text {
    kkGlobalChatInfo* info = [kkBubbleLabel getInfo];
    CGFloat maxTextWidth = KKCHATCELL_MAX_WIDTH - info.hPadding;
    CGSize labelSize = [text sizeWithFont:KKCHATCELL_FONT
                        constrainedToSize:CGSizeMake(maxTextWidth, MAXFLOAT) 
                            lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat height = labelSize.height + info.vPadding;
    CGSize minSize = info.image.size;
    if (height < minSize.height) {
        height = minSize.height;
    }
    return height;
}

@end
