//
//  kkAuthController.m
//  tts
//
//  Created by Wang Jinggang on 12-7-7.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

#import "kkAuthController.h"
#import "kkNoteView.h"

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
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString* url = @"https://api.weibo.com/oauth2/authorize?client_id=1685183673&response_type=code&display=mobile&redirect_uri=http://www.toutoushuo.com/index.php/login/mobile/sina";
    //NSString* url = @"www.toutoushuo.com";
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(clearWeiboCookie:)
     name:NSHTTPCookieManagerCookiesChangedNotification
     object:nil];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSHTTPCookieManagerCookiesChangedNotification object:nil];
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
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [loadingView stopAnimating];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

@end
