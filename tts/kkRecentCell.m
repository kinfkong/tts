//
//  kkRecentCell.m
//  tts
//
//  Created by Wang Jinggang on 12-6-30.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

#import "kkRecentCell.h"
#import "kkProfileHeaderView.h"
#import "kkBadgeView.h"
#import "kkDateUtil.h"

#define KKRECENT_CELL_HEIGHT 62

@implementation kkRecentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        CGFloat vMargin = 8;
        CGFloat hMargin = 5;
        CGRect rect = CGRectMake(vMargin, hMargin, KKRECENT_CELL_HEIGHT - vMargin * 2, KKRECENT_CELL_HEIGHT - vMargin * 2);
        kkProfileHeaderView* profileView = [[kkProfileHeaderView alloc] initWithFrame:rect image:nil];
        [profileView setShowQuestionMark:YES];
        [self addSubview:profileView];
        
        badge = [[kkBadgeView alloc] initWithFrame:CGRectMake(36 , 0, 24, 24)];
        [self addSubview:badge];
        
        rect = CGRectMake(profileView.frame.origin.x + profileView.frame.size.width + 15, profileView.frame.origin.y, 200, 22);
        nameLabel = [[UILabel alloc] initWithFrame:rect];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.text = @"王景刚";
        nameLabel.font = [UIFont boldSystemFontOfSize:18];
        [self addSubview:nameLabel];
        
        CGFloat timeLabelWidth = 90;
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(320 - timeLabelWidth - 5, profileView.frame.origin.y, timeLabelWidth, 22)];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.textColor = [UIColor grayColor];
        timeLabel.text = @"星期四 22:30";
        timeLabel.font = [UIFont systemFontOfSize:14];
        timeLabel.textAlignment = UITextAlignmentRight;
        [self addSubview:timeLabel];
        
        lastMsgLabel = [[kkLastMsgView alloc] initWithFrame:CGRectMake(profileView.frame.origin.x + profileView.frame.size.width + 15, nameLabel.frame.origin.y + nameLabel.frame.size.height + 5, 220, 22)];
        [self addSubview:lastMsgLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (selected) {
        nameLabel.textColor = [UIColor whiteColor];
        timeLabel.textColor = [UIColor whiteColor];
        lastMsgLabel.label.textColor = [UIColor whiteColor];
    } else {
        nameLabel.textColor = [UIColor blackColor];
        timeLabel.textColor = [UIColor grayColor];
        lastMsgLabel.label.textColor = [UIColor grayColor];
    }
}


+(CGFloat) heightForCell {
    return KKRECENT_CELL_HEIGHT;
}

-(void) setBadge:(NSString *) badgeStr {
    [badge setBadge:badgeStr];
}
-(void) setText:(NSString *) text status:(NSString*) status {
    [lastMsgLabel setText:text status:status];
}

-(void) setData:(NSDictionary *) data {
    NSString* text = [data objectForKey:@"text"];
    NSString* name = [data objectForKey:@"user_name"];
    NSString* status = [data objectForKey:@"status"];
    int unread = [(NSNumber *) [data objectForKey:@"unread"] intValue];
    NSString* time = [data objectForKey:@"create_time"];
    
    nameLabel.text = name;
    [lastMsgLabel setText:text status:status];
    timeLabel.text = [kkDateUtil getTimeString:time forShort:YES];
    if (unread > 0) {
        [badge setBadge:[NSString stringWithFormat:@"%d", unread]];
    } else {
        [badge setBadge:nil];
    }
}

@end
