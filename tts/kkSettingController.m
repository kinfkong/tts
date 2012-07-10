//
//  kkSettingController.m
//  tts
//
//  Created by Wang Jinggang on 12-7-10.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

#import "kkSettingController.h"
#import "GradientButton.h"
#import "kkAppDelegate.h"
#import "kkMsgDataMgr.h"

@interface kkSettingController ()

@end

@implementation kkSettingController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void) logout {
    [kkMsgDataMgr removeUserInfo];
    kkAppDelegate *delegate = (kkAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate useLoginController];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    GradientButton* loginButton = [[GradientButton alloc] initWithFrame:CGRectMake(10, 10, 300, 40)];
    [loginButton useRedDeleteStyle];
    [loginButton setTitle:@"退出登陆" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



@end
