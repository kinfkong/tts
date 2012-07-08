//
//  kkAuthController.h
//  tts
//
//  Created by Wang Jinggang on 12-7-7.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "kkNoteView.h"

@interface kkAuthController : UIViewController {
    IBOutlet UIWebView* webView;
    UIActivityIndicatorView* loadingView;
    kkNoteView* noteView;
}

-(IBAction) dismiss:(id) sender;

@end
