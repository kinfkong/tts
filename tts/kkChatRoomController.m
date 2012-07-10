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
#import "kkMsgDataMgr.h"

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

-(id) init {
    return [self initWithChatRoomId:-1];
}

-(id) initWithChatRoomId:(int)_cr_id {
    self = [super init];
    if (self) {
        cr_id = _cr_id;
    }
    return self;
}

-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) testing {
    [self.editTextView moveTo:100];
}

-(void) insertTestData {
    NSMutableDictionary* msg = [[NSMutableDictionary alloc] init];
    NSString* text = [NSString stringWithFormat:@"the s:%.3lf", [[NSDate date] timeIntervalSince1970]];
    [msg setObject:text forKey:@"text"];
    [msg setObject:@"2012-03-18 12:30:33" forKey:@"create_time"];
    
    [msg setObject:@"normal" forKey:@"status"];
    [msg setObject:[NSNumber numberWithInt:(rand() % 2) + 1] forKey:@"sender"];
    
    //[dataMgr insertMsg:msg toChatRoom:101];
    NSMutableDictionary* chatInfo = [[NSMutableDictionary alloc] init];
    [chatInfo setObject:[NSNumber numberWithInt:1] forKey:@"cr_id"];
    [chatInfo setObject:@"shenmiren001" forKey:@"user_name"];
    [chatInfo setObject:@"0" forKey:@"user_id"];
    [chatInfo setObject:@"www.baidu.com" forKey:@"user_profile_url"];
    [chatInfo setObject:[NSNumber numberWithInt:1] forKey:@"user_gender"];
    [chatInfo setObject:@"kinfkong" forKey:@"my_name"];
    [chatInfo setObject:@"www.google.com" forKey:@"my_profile_url"];
    //[dataMgr insertNewMsgs:chatInfo msgs:[NSArray arrayWithObjects:msg, nil]];
    
    kkMsgDataMgr* dataMgr = [kkMsgDataMgr getInstance];
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:chatInfo, @"chatinfo", [NSArray arrayWithObjects:msg, nil], @"msgs", nil];
    
    [dataMgr performSelector:@selector(receivedMsgs:) withObject:[NSArray arrayWithObjects:dict,nil]];
    //-(NSArray*) getMsgsForChatRoom:(int) cr_id 
    // [dataMgr getMsgsForChatRoom:101];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //UIImage* bgImage = [UIImage imageNamed:@"chat_bg.png"];
    //self.view.backgroundColor  = [UIColor colorWithPatternImage:bgImage];
/*
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(testing)];
	self.navigationItem.rightBarButtonItem = item;
  */  
    CGFloat textViewHeight = 52;
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
    
    if (cr_id > 0) {
        kkMsgDataMgr* dataMgr = [kkMsgDataMgr getInstance];
        NSDictionary* chatRoomInfo = [dataMgr getChatRoomInfo:cr_id];
        self.msgListView.chatRoomInfo = chatRoomInfo;
        NSArray* msgs = [[kkMsgDataMgr getInstance] getMsgsForChatRoom:cr_id];
        self.msgListView.msgArray = [NSMutableArray arrayWithArray:msgs];
        [self.msgListView reloadData];

        [self.msgListView moveToBottom];
        //[dataMgr markAllRead:cr_id];
    }
    
    
    
    
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

-(void) textView:(kkGrowTextView *) textView sendMsg:(NSString *)msg {
    /*
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
    [self performSelector:@selector(finishSendingMsg:) withObject:msgData afterDelay:3.0];*/
    [[kkMsgDataMgr getInstance] sendMsg:msg inChatRoom:cr_id];
}

-(void) clickedMsgListview:(kkMsgListView *) msgListview {
    [self.editTextView.msgTextView resignFirstResponder];
}

-(void) headerWillLoad:(kkMsgListView *)msgListView {
    if (cr_id < 0) {
        return;
    }
    kkMsgDataMgr* mgr = [kkMsgDataMgr getInstance];
    int last_id = -1;
    if ([self.msgListView.msgArray count] > 0) {
        last_id = [(NSNumber *) [(NSDictionary *) [self.msgListView.msgArray objectAtIndex:0] objectForKey:@"id"] intValue];
    }
    
    NSArray* olderMsgs = [mgr getMoreMsgsForChatRoom:cr_id lastId:last_id];
    [self.msgListView pushMsgs:olderMsgs];
    
}

-(void) viewDidAppear:(BOOL)animated {
    kkMsgDataMgr* mgr = [kkMsgDataMgr getInstance];
    [mgr markAllRead:cr_id];
    
    [[kkMsgDataMgr getInstance] addObserver:self event:kkMsgDataReceivedNewMsgs];
    [[kkMsgDataMgr getInstance] addObserver:self event:kkMsgDataMgrMsgSending];    
    [[kkMsgDataMgr getInstance] addObserver:self event:kkMsgDataMgrMsgDidSend];
}

-(void) viewDidDisappear:(BOOL)animated {
    [[kkMsgDataMgr getInstance] removeObserver:self event:kkMsgDataReceivedNewMsgs];
    [[kkMsgDataMgr getInstance] removeObserver:self event:kkMsgDataMgrMsgSending];    
    [[kkMsgDataMgr getInstance] removeObserver:self event:kkMsgDataMgrMsgDidSend];   
}


-(void) onReceivedMsgs:(NSArray *) msgs {
    for (int i = 0; i < [msgs count]; i++) {
        NSDictionary* chatInfo = [(NSDictionary *) [msgs objectAtIndex:i] objectForKey:@"chatinfo"];
        int new_cr_id = [(NSNumber *) [chatInfo objectForKey:@"cr_id"] intValue];
            //NSLog(@"%@:%d", chatInfo, cr_id);
        if (new_cr_id == cr_id) {
            NSArray* ms = [(NSDictionary *) [msgs objectAtIndex:i] objectForKey:@"msgs"];;    
            
            [self.msgListView appendMsgs:ms];
            kkMsgDataMgr* mgr = [kkMsgDataMgr getInstance];
            [mgr markAllRead:cr_id];
        
            break;
        }
    }
}

-(void) onMsgWillSend:(NSDictionary *) msg inChatRoom:(NSNumber *) new_cr_id {
    if ([new_cr_id intValue] != cr_id) {
        return;
    }
    [self.msgListView appendMsg:msg];
}

-(void) onMsgDidSend: (NSDictionary*) sendResult {
    //NSLog(@"the send result:%@", sendResult);
    int new_cr_id = [(NSNumber *) [sendResult objectForKey:@"cr_id"] intValue];
    if (new_cr_id != cr_id) {
        return;
    }
    NSString* status = [sendResult objectForKey:@"status"];
    int msg_id = [(NSNumber *) [sendResult objectForKey:@"msg_id"] intValue];
    [self.msgListView updateMsg:msg_id withStatus:status];
}
@end
