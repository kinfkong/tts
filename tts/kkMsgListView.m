//
//  kkMsgListView.m
//  tts
//
//  Created by Wang Jinggang on 12-6-24.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

#import "kkMsgListView.h"
#import "kkChatViewCell.h"


@interface kkMsgListView (private)
-(void) pushMsgs:(NSArray *) msgs;
@end

@implementation kkMsgListView

@synthesize msgArray;

@synthesize delegate;

@synthesize currentUser;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:tableView];
        
        EGORefreshTableHeaderView *headerView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - tableView.bounds.size.height, self.frame.size.width, tableView.bounds.size.height)];
		headerView.delegate = self;
        headerView.backgroundColor = [UIColor clearColor];
        _reloading = NO;
		[tableView addSubview:headerView];
		_refreshHeaderView = headerView;
        
        // Initialization code
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        tableView.delegate = self;
        tableView.dataSource = self;
        
        currentUser = @"kinfkong";
        
        // test code
        msgArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < 0; i++) {
            NSMutableDictionary* msgData = [[NSMutableDictionary alloc] init];
            [msgData setObject:@"jdfkdfkdjkfjdkjfkdjfkdjfkdjfkdjfkdjfkdjkfjdkfjdkfjdkjfkdjfkdjfkdjfkdjfkkdjfkdjfkdjfkdjkf" forKey:@"msg"];
            if (i % 2 != 0) {
                [msgData setObject:@"kinfkong" forKey:@"userid"];
            } else {
                [msgData setObject:@"dalitt" forKey:@"userid"];
            }
            [msgArray addObject:msgData];
        }
        // end test code
        
        [tableView reloadData];
        [self moveToBottom];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(int) getWhatToShow:(NSIndexPath *)indexPath {
    int what = kkChatViewShowAll;
    int index = [indexPath row];
    if (index != 0) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString* theTime = [(NSDictionary *) [self.msgArray objectAtIndex:index] objectForKey:@"time"];
        NSDate* date1 = [dateFormatter dateFromString:theTime];
        theTime = [(NSDictionary *) [self.msgArray objectAtIndex:index - 1] objectForKey:@"time"];
        NSDate* date2 = [dateFormatter dateFromString:theTime];
        if (abs(date1.timeIntervalSince1970 - date2.timeIntervalSince1970) < 60) {
            what ^= kkChatViewShowTime;
        }
    }
    return what;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [kkChatViewCell heightForCell:[self.msgArray objectAtIndex:[indexPath row]] show:[self getWhatToShow:indexPath]];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.msgArray == nil) {
        return 0;
    }
    return [self.msgArray count];
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* msgUser = [(NSDictionary *) [self.msgArray objectAtIndex:[indexPath row]] objectForKey:@"userid"];
    NSString* identifier = @"kkOtherChatView";
    if ([msgUser isEqualToString:currentUser]) {
        identifier = @"kkMyChatView";
    }
    
    kkChatViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[kkChatViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    //cell.msgData = [self.msgArray objectAtIndex:[indexPath row]];
    [cell setMsgData:[self.msgArray objectAtIndex:[indexPath row]] show:[self getWhatToShow:indexPath]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (delegate != nil && [delegate respondsToSelector:@selector(clickedMsgListview:)]) {
        [delegate clickedMsgListview:self];
    }
}

-(void) moveToBottom {
    if ([msgArray count] == 0) {
        return;
    }
    NSIndexPath * ndxPath= [NSIndexPath indexPathForRow:[msgArray count] - 1 inSection:0];
    [tableView scrollToRowAtIndexPath:ndxPath atScrollPosition:UITableViewScrollPositionBottom  animated:NO];
}

-(void) resizeHeight:(CGFloat)height {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];     
    [UIView setAnimationBeginsFromCurrentState:YES];
    CGRect rect = self.frame;
    rect.size.height = height;
    tableView.frame = rect;
    [self moveToBottom];
    [UIView commitAnimations];
}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadHeaderTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
	[self performSelector:@selector(doneHeaderLoadingTableViewData) withObject:nil afterDelay:3.0];
}

- (void)doneHeaderLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:tableView];
	
    // test code
    NSMutableArray* newMsgArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 2; i++) {
        NSMutableDictionary* msgData = [[NSMutableDictionary alloc] init];
        [msgData setObject:@"new msg lalalallalalallalalalalallalalal" forKey:@"msg"];
        if (i % 2 != 0) {
            [msgData setObject:@"kinfkong" forKey:@"userid"];
        } else {
            [msgData setObject:@"dalitt" forKey:@"userid"];
        }
        [msgData setObject:@"2012-06-22 12:10:10" forKey:@"time"];
        //[msgData setObject:@"对方还没查看你的信息,请稍候" forKey:@"statusmsg"];
        [newMsgArray addObject:msgData];
    }
    [self pushMsgs:newMsgArray];
    // end test code
}



#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadHeaderTableViewDataSource];
	
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}


- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

-(void) appendMsgs:(NSArray *) newMsgs {
    for (int i = 0; i < [newMsgs count]; i++) {
        [self.msgArray addObject:[newMsgs objectAtIndex:i]];
    }
    [tableView reloadData];
    [self moveToBottom];
}

-(void) appendMsg:(id) msg {
    [self.msgArray addObject:msg];
    [tableView reloadData];
    [self moveToBottom];
}

-(void) pushMsgs:(NSArray *)msgs {
    for (int i = 0; i < [msgs count]; i++) {
        [self.msgArray insertObject:[msgs objectAtIndex:i] atIndex:0];
    }
    [tableView reloadData];
}

-(void) updateMsg:(NSString*) innerMsgId withStatus:(NSString *) status {
    for (int i = [msgArray count] - 1; i >= 0; i--) {
        NSDictionary* msg = [msgArray objectAtIndex:i];
        NSString* theId = [msg objectForKey:@"innerid"];
        if ([theId isEqualToString:innerMsgId]) {
            NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary:msg];
            [dict setObject:status forKey:@"status"];
            [msgArray replaceObjectAtIndex:i withObject:dict];
            break;
        }
    }
    [tableView reloadData];
    
}

@end
