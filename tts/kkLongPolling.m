//
//  kkLongPolling.m
//  tts
//
//  Created by Wang Jinggang on 12-6-22.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

#import "kkLongPolling.h"
#import "SBJson.h"

@implementation kkLongPolling

@synthesize pollingURL;
@synthesize conn;

-(id) initWithPollingURL:(NSString *) _pollingURL moduleInfo:(NSArray *) array{
    self = [super init];
    if (self) {
        self.pollingURL = _pollingURL;
        _starting = NO;
    }
    return self;
}


-(NSURLRequest *) getRequest {
    NSURL* url = [[NSURL alloc] initWithString:@"http://www.toutoushuo.com/index.php/msg/lp?cr_id=100&info=345"];
    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:url];
    return request;
}

-(void) __realStartPolling {
    NSURLRequest* request = [self getRequest];
    NSURLConnection* newConn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.conn = newConn;
}

-(void) startPolling {
    if (_starting) {
        return;
    }
    
    [self __realStartPolling];
    
    _starting = YES;
}

-(void) stopPolling {
    if (!_starting) {
        return;
    }
    [self.conn cancel];
    _starting = NO;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    //NSLog(@"recevied response");
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (_starting) {
        [self __realStartPolling];
    }
    
    //NSLog(@"The data received:%@", data);
    id jsonValue = [data JSONValue];
    if ([jsonValue isKindOfClass:[NSArray class]]) {
        for (id obj in (NSArray *) jsonValue) {
            NSLog(@"the result:%@", obj);
        }
    }

}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if (_starting) {
        [self __realStartPolling];
    }

}
@end
