//
//  kkGrowTextView.m
//  tts
//
//  Created by Wang Jinggang on 12-6-24.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

#import "kkGrowTextView.h"
#import <QuartzCore/QuartzCore.h>
#import "GradientButton.h"

@implementation kkGrowTextView

@synthesize delegate;
@synthesize msgTextView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //UIImage* image = [kkImageUtil drawGradientInRect:frame.size withColors:[NSArray arrayWithObjects:[UIColor whiteColor], [UIColor grayColor], nil]];
        //self.backgroundColor = [UIColor blueColor];
        //self.backgroundColor = [UIColor colorWithPatternImage:image];
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = self.bounds;
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:0.4 alpha:1.0] CGColor], (id)[[UIColor grayColor] CGColor], nil];
        [self.layer insertSublayer:gradient atIndex:0];
        
        
        /*
        CGFloat buttonWidth = 60;
        CGRect buttonframe = CGRectMake(frame.size.width - buttonWidth - 10, 6, buttonWidth, frame.size.height - 6 * 2);
        sendButton = [[GradientButton alloc] initWithFrame:buttonframe];
        [sendButton useWhiteStyle];
        sendButton.titleLabel.font = [UIFont systemFontOfSize:14];
        sendButton.titleLabel.textColor = [UIColor whiteColor];
        [sendButton setTitle:@"发送" forState:UIControlStateNormal];
        //sendButton.enabled = NO;
        [sendButton addTarget:self action:@selector(sendButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:sendButton];
         */
        CGFloat buttonWidth = 60;
        CGRect buttonframe = CGRectMake(frame.size.width - buttonWidth - 10, 10, buttonWidth, frame.size.height - 10 * 2);
        sendButton = [[UIGlossyButton alloc] initWithFrame:buttonframe];
        sendButton.tintColor = [UIColor doneButtonColor];
        [sendButton useWhiteLabel: YES];
        sendButton.innerBorderWidth = 0.0f;
        sendButton.buttonBorderWidth = 0.0f;
        sendButton.buttonCornerRadius = 12.0f;
        [sendButton setGradientType: kUIGlossyButtonGradientTypeLinearGlossyStandard];
        [sendButton setStrokeType: kUIGlossyButtonStrokeTypeInnerBevelDown];
        [sendButton setTitle:@"发送" forState:UIControlStateNormal];
        sendButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [sendButton addTarget:self action:@selector(sendButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:sendButton];
        
        // Initialization code
        /*
        CGRect textFrame = CGRectMake(10, 10, frame.size.width - buttonWidth - 10 * 3, frame.size.height - 10 * 2);
        UITextView* textView = [[UITextView alloc] initWithFrame:textFrame];
        textView.layer.cornerRadius = 6;
        textView.layer.masksToBounds = YES;
        textView.layer.shadowOffset=CGSizeMake(1, 1);
        textView.layer.shadowRadius=3.0;
        textView.layer.shadowColor=[UIColor blackColor].CGColor;
        textView.layer.shadowOpacity=.8f;
        textView.layer.borderColor=[UIColor grayColor].CGColor;
        textView.layer.borderWidth=1.0;
        textView.font = [UIFont systemFontOfSize:14];
        textView.delegate = self;
        [textView setClipsToBounds:YES];
        //textView.layer.borderWidth = 1.0;
        [self addSubview:textView];
        msgTextView = textView;
         */
        CGRect textFrame = CGRectMake(12, 10, frame.size.width - buttonWidth - 10 - 12 * 2, frame.size.height - 10 * 2);
        msgTextView = [[HPGrowingTextView alloc] initWithFrame:textFrame];
        msgTextView.maxNumberOfLines = 5;
        msgTextView.minNumberOfLines = 1;
        msgTextView.delegate = self;
        msgTextView.font = [UIFont systemFontOfSize:15];
        [self addSubview:msgTextView];
        msgTextView.layer.cornerRadius = 8;
        msgTextView.layer.masksToBounds = YES;
        /*
        oriHeight = frame.size.height - 10 * 2;
        maxHeight = 120;
         */
    }
    return self;
}

-(void) moveTo:(CGFloat) y {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];     
    [UIView setAnimationBeginsFromCurrentState:YES];
    CGRect rect = self.frame;
    rect.origin.y = y;
    self.frame = rect;
    [UIView commitAnimations];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
/*
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
 */

/*
- (void)textViewDidChange:(UITextView *)tv {
    if (tv != msgTextView) {
        return;
    }
    NSLog(@"current height:%.3lf, content height:%.3lf oriHeight:%.3lf", 
          tv.frame.size.height, tv.contentSize.height, oriHeight);
    CGFloat newHeight = tv.frame.size.height;
    if ([tv.text isEqualToString:@""]) {
        newHeight = oriHeight;
    } else if (tv.contentSize.height != tv.frame.size.height && tv.contentSize.height >= oriHeight && tv.contentSize.height <= maxHeight) {
        newHeight = tv.contentSize.height;
    }
    if (newHeight != tv.frame.size.height) {
        // NSLog(@"frame changed...");
        NSLog(@"the more height:%.3lf", newHeight - tv.frame.size.height);
        CGRect rect = tv.frame;
        rect.size.height = newHeight;
        CGFloat moreHeight = newHeight - tv.frame.size.height;
        tv.frame = rect;
        CGRect wholeFrame = self.frame;
        wholeFrame.size.height += moreHeight;
        self.frame = wholeFrame;
        tv.contentInset = UIEdgeInsetsZero;
        
        wholeFrame = sendButton.frame;
        wholeFrame.origin.y += moreHeight;
        sendButton.frame = wholeFrame;
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = self.bounds;
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor grayColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
        CALayer* layer = [[self.layer sublayers] objectAtIndex:0];
        [self.layer replaceSublayer:layer with:gradient];
        //[self.layer insertSublayer:gradient atIndex:0];
        
        if (delegate != nil && [delegate respondsToSelector:@selector(textView:frameDidChanged:)]) {
            [delegate textView:self frameDidChanged:self.frame];
        }
    }
}*/

-(void) sendButtonClicked:(id) sender {
    NSString* sendText = self.msgTextView.text;
    if ([sendText isEqualToString:@""]) {
        return;
    }
    [self.msgTextView resignFirstResponder];
    self.msgTextView.text = @"";
    //[self textViewDidChange:self.msgTextView];
    if (delegate != nil && [delegate respondsToSelector:@selector(textView:sendMsg:)]) {
        [delegate textView:self sendMsg:sendText]; 
    }
}


- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
	CGRect r = self.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	self.frame = r;
    
    if (delegate != nil && [delegate respondsToSelector:@selector(textView:frameDidChanged:)]) {
        [delegate textView:self frameDidChanged:self.frame];
    }
    
    
    CGRect wholeFrame = sendButton.frame;
    wholeFrame.origin.y -= diff;
    sendButton.frame = wholeFrame;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:0.4 alpha:1.0] CGColor], (id)[[UIColor grayColor] CGColor], nil];
    CALayer* layer = [[self.layer sublayers] objectAtIndex:0];
    [self.layer replaceSublayer:layer with:gradient];

    
}




@end
