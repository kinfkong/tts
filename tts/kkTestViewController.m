//
//  kkTestViewController.m
//  tts
//
//  Created by Wang Jinggang on 12-6-23.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

#import "kkTestViewController.h"

@interface kkTestViewController ()

@end

@implementation kkTestViewController

@synthesize longPolling;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) beginTask:(id) sender {
    [self.longPolling startPolling];
}

-(void) cancelTask:(id) sender {
    [self.longPolling stopPolling];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(100, 100, 100, 100);
    button.showsTouchWhenHighlighted = YES;
    [button addTarget:self action:@selector(beginTask:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton* button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button2.frame = CGRectMake(100, 300, 100, 100);
    button2.showsTouchWhenHighlighted = YES;
    [button2 addTarget:self action:@selector(cancelTask:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    self.longPolling = [[kkLongPolling alloc] initWithPollingURL:nil moduleInfo:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.longPolling = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
