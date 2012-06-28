//
//  kkChatRoomController.m
//  tts
//
//  Created by Wang Jinggang on 12-6-24.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

#import "kkChatRoomController.h"
#import "kkMsgListView.h"
#import "kkGrowTextView.h"

@interface kkChatRoomController ()

@end

@implementation kkChatRoomController

@synthesize msgListView;
@synthesize editTextView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        srand(time(NULL));
    }
    return self;
}

-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) testing {
    [self.editTextView moveTo:100];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // self.view.backgroundColor = [UIColor whiteColor];
    //UIImage* bgImage = [UIImage imageNamed:@"chat_bg.png"];
    //self.view.backgroundColor  = [UIColor colorWithPatternImage:bgImage];
/*
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(testing)];
	self.navigationItem.rightBarButtonItem = item;
  */  
    CGFloat textViewHeight = 48;
    CGFloat navBarHeight = 44;
    // the table view
    kkMsgListView* mlv = [[kkMsgListView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - navBarHeight - textViewHeight)];
    mlv.delegate = self;
    [self.view addSubview:mlv];
    
    self.msgListView = mlv;
    
    // the text view editor
    kkGrowTextView* textView = [[kkGrowTextView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - navBarHeight - textViewHeight, self.view.frame.size.width, textViewHeight)];
    textView.delegate = self;
    [self.view addSubview:textView];
    
    self.editTextView = textView;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];  
    

    float version = [[[UIDevice currentDevice] systemVersion] floatValue];  
    if (version >= 5.0) {  
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];  
    }  
    
 
    
    currentUser = @"kinfkong";
    
}

-(void) keyboardWillShow:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];  
    
    // Get the origin of the keyboard when it's displayed.  
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];  
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.  
    CGRect keyboardRect = [aValue CGRectValue];  
    
    // Get the duration of the animation.  
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];  
    NSTimeInterval animationDuration;  
    [animationDurationValue getValue:&animationDuration];  
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.  
    //[self moveInputBarWithKeyboardHeight:keyboardRect.size.height withDuration:animationDuration];  
    
    CGFloat msgHeight = self.view.frame.size.height - self.editTextView.frame.size.height - keyboardRect.size.height;
    keyboardHeight = keyboardRect.size.height;
    [self.editTextView moveTo:msgHeight];
    [self.msgListView resizeHeight:msgHeight];
}

-(void) keyboardWillHide:(NSNotification *)notification {
    keyboardHeight =  0;
    [self.editTextView moveTo:self.view.frame.size.height - self.editTextView.frame.size.height];
    [self.msgListView resizeHeight:self.view.frame.size.height - self.editTextView.frame.size.height];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.msgListView = nil;
    self.editTextView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) textView:(kkGrowTextView *) textView frameDidChanged:(CGRect) frame {
    CGFloat msgHeight = self.view.frame.size.height - self.editTextView.frame.size.height - keyboardHeight;
    [self.editTextView moveTo:msgHeight];
    [self.msgListView resizeHeight:msgHeight];
}

// a test method
-(void) finishSendingMsg:(NSDictionary *) msg {
    [self.msgListView updateMsg:[msg objectForKey:@"innerid"] withStatus:@"finished"];
}

-(void) textView:(kkGrowTextView *) textView sendMsg:(NSString *)msg {
    
    NSString* innerMsgId = [NSString stringWithFormat:@"%d", random()];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* timeString = [dateFormatter stringFromDate:[NSDate date]];
    NSDictionary* msgData = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", 
                             currentUser, @"userid",
                             @"sending", @"status", 
                             innerMsgId, @"innerid", 
                             timeString, @"time", nil];
    [self.msgListView appendMsg:msgData];
    // test
    [self performSelector:@selector(finishSendingMsg:) withObject:msgData afterDelay:3.0];
}

-(void) clickedMsgListview:(kkMsgListView *) msgListview {
    [self.editTextView.msgTextView resignFirstResponder];
}

@end
