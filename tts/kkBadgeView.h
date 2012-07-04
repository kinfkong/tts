//
//  kkBadgeView.h
//  tts
//
//  Created by Wang Jinggang on 12-6-30.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface kkBadgeView : UIView {
    UIImageView* imageView;
    UILabel* label;
    CGFloat margin;
}

-(void) setBadge:(NSString *) badge;

@end
