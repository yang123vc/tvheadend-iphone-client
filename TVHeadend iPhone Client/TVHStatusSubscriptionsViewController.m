//
//  TVHStatusSubscriptionsViewController.m
//  TVHeadend iPhone Client
//
//  Created by zipleen on 2/18/13.
//  Copyright (c) 2013 zipleen. All rights reserved.
//

#import "TVHStatusSubscriptionsViewController.h"
#import "CKRefreshControl.h"
#import "WBErrorNoticeView.h"
#import "TVHCometPollStore.h"

@interface TVHStatusSubscriptionsViewController ()
@property (strong, nonatomic) TVHStatusSubscriptionsStore *statusStore;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation TVHStatusSubscriptionsViewController

- (TVHStatusSubscriptionsStore*) statusStore {
    if ( _statusStore == nil) {
        _statusStore = [TVHStatusSubscriptionsStore sharedInstance];
    }
    return _statusStore;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self.statusStore setDelegate:self];
    [self.statusStore fetchStatusSubscriptions];
    
    //pull to refresh
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(pullToRefreshViewShouldRefresh) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didLoadStatusSubscriptions {
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (void)pullToRefreshViewShouldRefresh
{
    [self.tableView reloadData];
    [self.statusStore fetchStatusSubscriptions];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.statusStore count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SubscriptionStoreTableItems";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    
    // Configure the cell...
    TVHStatusSubscription *subscription = [self.statusStore objectAtIndex:indexPath.row];
    
    UILabel *hostnameLabel = (UILabel *)[cell viewWithTag:100];
    // username
	UILabel *titleLabel = (UILabel *)[cell viewWithTag:102];
    UILabel *channelLabel = (UILabel *)[cell viewWithTag:103];
    UILabel *serviceLabel = (UILabel *)[cell viewWithTag:104];
    UILabel *startLabel = (UILabel *)[cell viewWithTag:105];
    UILabel *stateLabel = (UILabel *)[cell viewWithTag:106];
    UILabel *errorsLabel = (UILabel *)[cell viewWithTag:107];
	UILabel *bandwidthLabel = (UILabel *)[cell viewWithTag:108];
    
    hostnameLabel.text = subscription.hostname;
    titleLabel.text = subscription.title;
    channelLabel.text = subscription.channel;
    serviceLabel.text = subscription.service;
    startLabel.text = [subscription.start description];
    stateLabel.text = subscription.state;
    errorsLabel.text = [NSString stringWithFormat:@"Errors: %d", subscription.errors];
    bandwidthLabel.text = [NSString stringWithFormat:@"Bw: %d", subscription.bw];
    
    UIImageView *separator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separator.png"]];
    [cell.contentView addSubview: separator];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)didLoadTags {
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (void)didErrorStatusSubscriptionsStore:(NSError *)error {
    WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView:self.view title:NSLocalizedString(@"Network Error", nil) message:error.localizedDescription];
    [notice setSticky:true];
    [notice show];
    
    [self.refreshControl endRefreshing];
}


- (IBAction)toggleStatusRefreshing:(UIBarButtonItem *)sender {
    if(self.timer) {
        sender.style = UIBarButtonItemStyleBordered;
        [self.timer invalidate];
        self.timer = nil;
    } else {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:[TVHCometPollStore sharedInstance] selector:@selector(fetchCometPollStatus) userInfo:nil repeats:YES];
        sender.style = UIBarButtonItemStyleDone;
    }
}
@end
