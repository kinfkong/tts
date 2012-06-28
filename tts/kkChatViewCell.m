//
//  kkChatViewCell.m
//  tts
//
//  Created by Wang Jinggang on 12-6-26.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

#import "kkChatViewCell.h"
#import "NSDate-Utilities.h"

#define KKCHATCELL_TIME_FONT ([UIFont systemFontOfSize:12])
#define KKCHATCELL_TIME_HEIGHT (20)
#define KKCHATCELL_STATUS_WIDTH (250)
#define KKCHATCELL_STATUS_FONT ([UIFont systemFontOfSize:12]) 
#define KKCHATCELL_PROFILEVIEW_HEIGHT (50)


@implementation kkChatViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        type = 0;
        if ([reuseIdentifier isEqualToString:@"kkMyChatView"]) {
            type = 1;
        }

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
        
        statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:statusLabel];
        statusLabel.backgroundColor = [UIColor clearColor];
        statusLabel.font = KKCHATCELL_STATUS_FONT;
        statusLabel.numberOfLines = 0;
        statusLabel.lineBreakMode = UILineBreakModeWordWrap;
        
        
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

-(NSString*) getTimeString:(NSString*) theTime {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* date = [dateFormatter dateFromString:theTime];
    
    NSInteger hour = [date hour];
    NSInteger min = [date minute];
    
    NSString* result = nil;
    if ([date isToday]) {
        result = [NSString stringWithFormat:@"%@ %02d:%02d", @"今天", hour, min];
    } else if ([date isYesterday]) {
        result = [NSString stringWithFormat:@"%@ %02d:%02d", @"昨天", hour, min];
    } else if ([date isThisWeek]) {
        NSInteger weekDay = [date weekday];
         NSArray* weekName = [NSArray arrayWithObjects:
                                    @"星期日", 
                                    @"星期一",
                             @"星期二",
                             @"星期三",
                             @"星期四",
                             @"星期五",
                             @"星期六",
                                nil];
        result = [NSString stringWithFormat:@"%@ %02d:%02d", [weekName objectAtIndex:(weekDay - 1)], hour, min];
    } else if ([date isThisYear]) {
        NSInteger month = [date month];
        NSInteger day = [date day];
        result = [NSString stringWithFormat:@"%02d-%02d %02d:%02d", month, day, hour, min];
    } else {
        NSInteger year = [date year];
        NSInteger month = [date month];
        NSInteger day = [date day];
        result = [NSString stringWithFormat:@"%d-%02d-%02d %02d:%02d", year, month, day, hour, min];
    }
    return result;
}

-(CGFloat) showTime:(NSDictionary *) msgData currentHeight:(CGFloat) currentHeight {
    timeLable.text = [self getTimeString:[msgData objectForKey:@"time"]];
    CGSize TimeLabelSize = [timeLable.text sizeWithFont:KKCHATCELL_TIME_FONT
                                      constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) 
                                          lineBreakMode:UILineBreakModeWordWrap];
    timeLable.frame = CGRectMake((320 - TimeLabelSize.width) / 2, currentHeight, TimeLabelSize.width, KKCHATCELL_TIME_HEIGHT);
    return timeLable.frame.size.height;
}

-(CGFloat) showMsg:(NSDictionary *) msgData currentHeight:(CGFloat) currentHeight {
    CGFloat profileMargin = 10;
    CGFloat labelMargin = 10;
    CGFloat loadingViewMargin = 10;
    CGFloat x = 0;
    if (type == 0) {
        x = profileMargin;
    } else {
        x = 320 - profileMargin - profileView.frame.size.width;
    }
    profileView.frame = CGRectMake(x, currentHeight, profileView.frame.size.width, profileView.frame.size.height);
    
    
    if (type == 0) {
        [profileView setType:1];
    } else {
        [profileView setType:0];
    }
    
    
    if (type == 0) {
        x = profileView.frame.origin.x + profileView.frame.size.width + labelMargin;
    } else if (type == 1) {
        x = profileView.frame.origin.x - labelMargin;
    }
    
    msgLabel.frame = CGRectMake(x, currentHeight, 0, 0);
    NSString* msg = [msgData objectForKey:@"msg"];
    if (type == 0) {
        [msgLabel setText:msg align:1];
    } else {
        [msgLabel setText:msg align:0];
    }
    
    NSString* status = [msgData objectForKey:@"status"];
    if ([status isEqualToString:@"sending"]) {
        loadingView.frame = CGRectMake(msgLabel.frame.origin.x - loadingView.frame.size.width - loadingViewMargin, 
                                       msgLabel.frame.origin.y + (msgLabel.frame.size.height - loadingView.frame.size.height) / 2, loadingView.frame.size.width, loadingView.frame.size.height);
        [loadingView startAnimating];
    } else {
        [loadingView stopAnimating];
    }
    
    return MAX(profileView.frame.size.height, msgLabel.frame.size.height);
    
}

+(CGSize) sizeForStatus:(NSString *) statusMsg {
    CGSize theSize = [statusMsg sizeWithFont:KKCHATCELL_STATUS_FONT
                                      constrainedToSize:CGSizeMake(KKCHATCELL_STATUS_WIDTH, MAXFLOAT) 
                                          lineBreakMode:UILineBreakModeWordWrap];
    return theSize;
}

-(CGFloat) showStatusMsg:(NSDictionary *) msgData currentHeight:(CGFloat) currentHeight {
    NSString* msg = [msgData objectForKey:@"statusmsg"];
    CGSize theSize = [kkChatViewCell sizeForStatus:msg];
    CGFloat x = (320 - theSize.width) / 2;
    statusLabel.frame = CGRectMake(x, currentHeight, theSize.width, theSize.height);
    statusLabel.text = msg;
    return theSize.height;
    
}

-(void) setMsgData:(NSDictionary *)msgData show:(int) what {
    
    CGFloat currentHeight = 0;
    if (what & kkChatViewShowTime) {
        timeLable.hidden = NO;
        currentHeight += [self showTime:msgData currentHeight:currentHeight];
    } else {
        timeLable.hidden = YES;
    }
    
    if (what & kkChatViewShowMsg) {
        currentHeight += [self showMsg:msgData currentHeight:currentHeight];
        profileView.hidden = NO;
        msgLabel.hidden = NO;
    } else {
        profileView.hidden = YES;
        msgLabel.hidden = YES;
    }
    
    if ((what & kkChatViewShowStatus) && [msgData objectForKey:@"statusmsg"] != nil) {
        currentHeight += [self showStatusMsg:msgData currentHeight:currentHeight];
        statusLabel.hidden = NO;
    } else {
        statusLabel.hidden = YES;
    }
    
}

+(CGFloat) heightForCell:(NSDictionary *) data {
    return [kkChatViewCell heightForCell:data show:kkChatViewShowAll];
}

+(CGFloat) heightForCell:(NSDictionary *) data show:(int) what {
    NSString* msg = [data objectForKey:@"msg"];
    CGFloat height = 0;
    if (what & kkChatViewShowMsg) {
        height += MAX([kkBubbleLabel heightForText:msg], KKCHATCELL_PROFILEVIEW_HEIGHT);
    }
    if (what & kkChatViewShowTime) {
        height += KKCHATCELL_TIME_HEIGHT;
    }
    
    NSString* statusMsg = [data objectForKey:@"statusmsg"];
    if ((what & kkChatViewShowStatus) && statusMsg != nil) {
        height += [kkChatViewCell sizeForStatus:statusMsg].height;
    }
    
    height += 20;
    return height;
}

@end
