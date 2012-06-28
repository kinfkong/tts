//
//  kkMainTabController.m
//  tts
//
//  Created by Wang Jinggang on 12-6-24.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

#import "kkMainTabController.h"
#import "kkChatListController.h"

@interface kkMainTabController ()

@end

@implementation kkMainTabController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    kkChatListController* chatList = [[kkChatListController alloc] init];
    UINavigationController* chat = [[UINavigationController alloc] initWithRootViewController:chatList];
    chat.navigationBar.tintColor = [UIColor grayColor];
    self.viewControllers = [NSArray arrayWithObjects:chat, nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.viewControllers = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
