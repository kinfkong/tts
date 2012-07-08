//
//  kkLoginController.m
//  tts
//
//  Created by Wang Jinggang on 12-7-7.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

#import "kkLoginController.h"
#import "kkAuthController.h"
#import <QuartzCore/QuartzCore.h>

@interface kkLoginController ()

@end

@implementation kkLoginController

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
    
    // Do any additional setup after loading the view from its nib.
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"logincell"];
    //[cell.imageView setTransform:CGAffineTransformMakeScale(0.8, 0.8)];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    //cell.imageView.layer.cornerRadius = 10;
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 40, 40)];
    [cell addSubview:imageView];
    imageView.layer.cornerRadius = 8;
    imageView.layer.masksToBounds = YES;
    if ([indexPath row] == 0) {
        imageView.image = [UIImage imageNamed:@"sina_icon.png"];
        cell.textLabel.text = @"                使用新浪微博帐号登录";
    } else {
        imageView.image = [UIImage imageNamed:@"tencent_icon.png"];
        cell.textLabel.text = @"                使用腾讯微博帐号登录";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    kkAuthController* controller = [[kkAuthController alloc] init];
    [self presentModalViewController:controller animated:YES];
}




@end
