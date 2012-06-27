//
//  kkProfileHeaderView.h
//  tts
//
//  Created by Wang Jinggang on 12-6-26.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface kkProfileHeaderView : UIView {
    UIImageView* questionMark;
    int type;
}
-(id) initWithFrame:(CGRect)frame image:(UIImage *) image type:(int) type;

-(void) setType:(int) type;

@end
