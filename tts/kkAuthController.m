//
//  kkAuthController.m
//  tts
//
//  Created by Wang Jinggang on 12-7-7.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

#import "kkAuthController.h"
#import "kkNoteView.h"
#import "SBJson.h"
#import "kkMsgDataMgr.h"
#import "kkAppDelegate.h"

@interface kkAuthController ()

@end

@implementation kkAuthController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) clearWeiboCookie:(id) sender {
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [cookieJar cookies]) {
        //NSLog(@"%@", cookie);
        if (![cookie.domain isEqualToString:@".toutoushuo.com"]) {
            // [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString* url = @"https://api.weibo.com/oauth2/authorize?client_id=1685183673&response_type=code&display=mobile&redirect_uri=http://www.toutoushuo.com/index.php/login/mobile/sina";
    //NSString* url = @"www.toutoushuo.com";
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyNever];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                         timeoutInterval:60.0];
    [webView loadRequest:request];
    
    
    loadingView = 
    [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loadingView.center = self.view.center;
    [self.view addSubview:loadingView];
    [loadingView startAnimating];
    
    noteView = [[kkNoteView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    noteView.center = self.view.center;
    [self.view addSubview:noteView];
    noteView.hidden = YES;

    
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


-(IBAction) dismiss:(id) sender {
    [self  dismissModalViewControllerAnimated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [loadingView stopAnimating];
    noteView.hidden = NO;
    noteView.label.text = @"加载失败";
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [loadingView startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *) _webView {
    [loadingView stopAnimating];
    //NSLog(@"finish request:%@", [_webView request]);
}

-(void) loginSuccess:(NSDictionary *) info {

}

-(void) loginCancel {
    [self dismiss:self];
}

-(void) loadUserInfo:(NSMutableDictionary *) parameters {
    [loadingView startAnimating];
    NSString* app_key = @"1685183673";
    NSString* url = [NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json?uid=%@&access_token=%@&source=%@",
                     [parameters objectForKey:@"source_uid"], [parameters objectForKey:@"source_access_token"], app_key];
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection connectionWithRequest:request delegate:self];
    userInfo = [NSMutableDictionary dictionaryWithDictionary:parameters];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (userInfo == nil) {
        // failed, invalid status
    }
    //NSLog(@"the data:%@", [NSString stringWithUTF8String:[data bytes]]);
    id result = [data JSONValue];
    if (result == nil || ![result isKindOfClass:[NSDictionary class]]) {
        // failed
    }
    NSString* gender = [result objectForKey:@"gender"];
    if (gender == nil) {
        // failed
    }
    if ([gender isEqualToString:@"m"]) {
        [userInfo setObject:[NSNumber numberWithInt:1] forKey:@"gender"];
    } else if ([gender isEqualToString:@"f"]) {
        [userInfo setObject:[NSNumber numberWithInt:2] forKey:@"gender"];
    } else {
        [userInfo setObject:[NSNumber numberWithInt:0] forKey:@"gender"];
    }
    NSString* profile_image_url = [result objectForKey:@"profile_image_url"];
    if (profile_image_url  == nil) {
        // failed
    }
    [userInfo setObject:profile_image_url forKey:@"profile_image_url"];
    NSString* name = [result objectForKey:@"screen_name"];
    if (name == nil) {
        // failed
    }
    [userInfo setObject:name forKey:@"name"];
    
    [kkMsgDataMgr resetCurrentUser:userInfo];
    
    kkAppDelegate *delegate = (kkAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate useTabController];
    [self dismiss:self];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {    
    if ([[[request URL] lastPathComponent] isEqualToString:@"login_result"]
        && [[[request URL] host] isEqualToString:@"www.toutoushuo.com"]) {
        NSString *query = [[request URL] query];
        NSArray *components = [query componentsSeparatedByString:@"&"];
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        for (NSString *component in components) {
            NSArray* kv = [component componentsSeparatedByString:@"="];
            if ([kv count] != 2) {
                continue;
            }
            [parameters setObject:[kv objectAtIndex:1] forKey:[kv objectAtIndex:0]];
        }
        //NSLog(@"params:%@", parameters);
        if ([parameters objectForKey:@"uid"] != nil && [parameters objectForKey:@"source_uid"] != nil 
            && [parameters objectForKey:@"source"] != nil && [parameters objectForKey:@"source_access_token"] != nil) {
            [self loadUserInfo:parameters];
        } else {
            [self loginCancel];
        }
        return NO;
    }
    
    return YES;
}

@end
