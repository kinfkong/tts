//
//  kkChatListController.m
//  tts
//
//  Created by Wang Jinggang on 12-6-24.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

#import "kkChatListController.h"
#import "kkChatRoomController.h"
#import "kkRecentCell.h"
#import "kkMsgDataMgr.h"

@interface kkChatListController ()

@end

@implementation kkChatListController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) testMethod:(id) sender {
    kkChatRoomController* chatRoom = [[kkChatRoomController alloc] init];
    chatRoom.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatRoom animated:YES];
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
    kkMsgDataMgr* dataMgr = [kkMsgDataMgr getInstance];
    
    chatList = [dataMgr getChatRoomList];
    
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:tableView];
    
    [dataMgr addObserver:self event:kkMsgDataReceivedNewMsgs];
    [dataMgr addObserver:self event:kkMsgDataMgrMsgSending];
    [dataMgr addObserver:self event:kkMsgDataMgrMsgDidSend];
    [dataMgr addObserver:self event:kkMsgDataMgrUnReadChange];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(insertTestData)];
	self.navigationItem.rightBarButtonItem = item;
    
    //[self insertTestData];
    
    
    // these are testing method:
    /*
    UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(100, 100, 100, 100);
    button.showsTouchWhenHighlighted = YES;
    [button addTarget:self action:@selector(testMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
     */
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[kkMsgDataMgr getInstance] removeObserver:self event:kkMsgDataReceivedNewMsgs];
    [[kkMsgDataMgr getInstance] removeObserver:self event:kkMsgDataMgrMsgDidSend];
        [[kkMsgDataMgr getInstance] removeObserver:self event:kkMsgDataMgrMsgSending];
    [[kkMsgDataMgr getInstance] removeObserver:self event:kkMsgDataMgrUnReadChange];
    // Release any retained subviews of the main view.
}

-(void) updateTotalUnRead {
    int sum = 0;
    for (int i = 0; i < [chatList count]; i++) {
        sum += [(NSNumber *) [(NSDictionary *) [chatList objectAtIndex:i] objectForKey:@"unread"] intValue];
    }
    //NSLog(@"the sum:%d", sum);
    //self.tabBarController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", sum];
    //self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", sum];
    if (sum > 0) {
        self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", sum];
    } else {
        self.navigationController.tabBarItem.badgeValue = nil;
    }
}
-(void) onReceivedMsgs:(NSArray *) msgs {
    //NSLog(@"recevied msgs ... controller");
    kkMsgDataMgr* dataMgr = [kkMsgDataMgr getInstance];
    chatList = [dataMgr getChatRoomList];
    [tableView reloadData];
    [self updateTotalUnRead];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [kkRecentCell heightForCell];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [chatList count];
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary* dict = [chatList objectAtIndex:[indexPath row]];
    NSString* reuseid = @"kkChatListItem";
    
    kkRecentCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseid];
    if (cell == nil) {
        cell =  [[kkRecentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseid];
    }
    
    [cell setData:dict];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //[self testMethod:self];
    int cr_id = [(NSNumber *) [(NSDictionary *) [chatList objectAtIndex:[indexPath row]] objectForKey:@"cr_id"] intValue];
    //NSLog(@"the cr_id:%d", cr_id);
    kkChatRoomController* chatRoom = [[kkChatRoomController alloc] initWithChatRoomId:cr_id];
    chatRoom.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatRoom animated:YES];
}

-(void) onMsgWillSend:(NSDictionary *) msg inChatRoom:(NSNumber *) new_cr_id {
    kkMsgDataMgr* dataMgr = [kkMsgDataMgr getInstance];
    chatList = [dataMgr getChatRoomList];
    [tableView reloadData];
}

-(void) onMsgDidSend:(NSDictionary*) sendResult {
    kkMsgDataMgr* dataMgr = [kkMsgDataMgr getInstance];
    chatList = [dataMgr getChatRoomList];
    [tableView reloadData];
}

-(void) onUnreadChange:(NSNumber *) cr_id {
    //NSLog(@"unread changed..");
    kkMsgDataMgr* dataMgr = [kkMsgDataMgr getInstance];
    chatList = [dataMgr getChatRoomList];
    [tableView reloadData];
    [self updateTotalUnRead];
   
}

@end
