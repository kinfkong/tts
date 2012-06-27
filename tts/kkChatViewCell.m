//
//  kkChatViewCell.m
//  tts
//
//  Created by Wang Jinggang on 12-6-26.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

#import "kkChatViewCell.h"

#define KKCHATCELL_TIME_FONT ([UIFont systemFontOfSize:14])
#define KKCHATCELL_TIME_HEIGHT (20)
#define KKCHATCELL_PROFILEVIEW_HEIGHT (50)


@implementation kkChatViewCell

@synthesize msgData;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        type = 0;
        if ([reuseIdentifier isEqualToString:@"kkMyChatView"]) {
            type = 1;
        }
        
        /*
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor blueColor];
        label.font = KKCHATCELL_FONT;
        label.numberOfLines = 0;
		label.lineBreakMode = UILineBreakModeWordWrap;
        
        [self addSubview:label];
        msgLabel = label;*/
        
        
		loadingView = 
            [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        loadingView.frame = CGRectMake(0, 0, 10, 10);
        [loadingView stopAnimating];
        [self addSubview:loadingView];
        
        profileView = [[kkProfileHeaderView alloc] initWithFrame:
                                            CGRectMake(0, 0, KKCHATCELL_PROFILEVIEW_HEIGHT, KKCHATCELL_PROFILEVIEW_HEIGHT)];
        [self addSubview:profileView];
        
        timeLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self addSubview:timeLable];
        timeLable.backgroundColor = [UIColor clearColor];
        timeLable.font = KKCHATCELL_TIME_FONT;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        kkBubbleLabel* bLabel = [[kkBubbleLabel alloc] initWithFrame:CGRectZero];
        if (type == 0) {
            [bLabel useStype:kkBubbleGreenStyle];
        } else {
            [bLabel useStype:kkBubbleGrayStyle];
        }
        
        [self addSubview:bLabel];
        msgLabel = bLabel;
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setMsgData:(NSDictionary *)newMsgData {
    if (msgData == newMsgData) {
        return;
    }
    msgData = newMsgData;
    NSString* msg = [msgData objectForKey:@"msg"];
    
    timeLable.text = [msgData objectForKey:@"time"];
    CGSize TimeLabelSize = [timeLable.text sizeWithFont:KKCHATCELL_TIME_FONT
                                  constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) 
                                      lineBreakMode:UILineBreakModeWordWrap];
    timeLable.frame = CGRectMake((320 - TimeLabelSize.width) / 2, 5, TimeLabelSize.width, KKCHATCELL_TIME_HEIGHT);
                                 
    CGPoint ori;
    if (type == 0) {
        ori.x = 10;
        ori.y = 5 + timeLable.frame.origin.y + timeLable.frame.size.height;
    } else if (type == 1) {
        ori.x = 320 - profileView.frame.size.width - 10;
        ori.y = 5 + timeLable.frame.origin.y + timeLable.frame.size.height;;
    }
    profileView.frame = CGRectMake(ori.x, ori.y, profileView.frame.size.width, profileView.frame.size.height);
    
    if (type == 0) {
        ori.x = profileView.frame.origin.x + profileView.frame.size.width + 15;
        ori.y = 5 + timeLable.frame.origin.y + timeLable.frame.size.height;;
    } else if (type == 1) {
        ori.x = profileView.frame.origin.x - 15;
        ori.y = 5 + timeLable.frame.origin.y + timeLable.frame.size.height;;
    }
    
    msgLabel.frame = CGRectMake(ori.x, ori.y, 0, 0);
    if (type == 0) {
        [msgLabel setText:msg align:1];
    } else {
        [msgLabel setText:msg align:0];
    }
        
    NSString* status = [msgData objectForKey:@"status"];
    if ([status isEqualToString:@"sending"]) {
        loadingView.frame = CGRectMake(msgLabel.frame.origin.x - loadingView.frame.size.width - 10, 
                                       msgLabel.frame.origin.y + (msgLabel.frame.size.height - loadingView.frame.size.height) / 2, loadingView.frame.size.width, loadingView.frame.size.height);
        [loadingView startAnimating];
    } else {
        [loadingView stopAnimating];
    }
    
    if (type == 0) {
        [profileView setType:1];
    } else {
        [profileView setType:0];
    }

    
}

+(CGFloat) heightForCell:(NSDictionary *) data {
    NSString* msg = [data objectForKey:@"msg"];
    CGFloat height = [kkBubbleLabel heightForText:msg];
    height += KKCHATCELL_TIME_HEIGHT;
    if (height < KKCHATCELL_PROFILEVIEW_HEIGHT) {
        height = KKCHATCELL_PROFILEVIEW_HEIGHT;
    }
    height += 20;
    return height;
}

@end
