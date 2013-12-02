//
//  TVHEpgStore.h
//  TvhClient
//
//  Created by zipleen on 02/12/13.
//  Copyright (c) 2013 zipleen. All rights reserved.
//

#import "TVHChannel.h"

#define MAX_REQUEST_EPG_ITEMS 300 // tvheadend has a limit of how much items you can request at one time
#define DEFAULT_REQUEST_EPG_ITEMS 50 // this is the default query limit on the webUI
#define SECONDS_TO_FETCH_AHEAD_EPG_ITEMS 21600

@class TVHServer;
@class TVHEpgStore;

@protocol TVHEpgStoreDelegate <NSObject>
- (void)didLoadEpg;
@optional
- (void)willLoadEpg;
- (void)didErrorLoadingEpgStore:(NSError*)error;
@end

@protocol TVHEpgStore <NSObject>
@property (nonatomic, weak) TVHServer *tvhServer;
@property (nonatomic, strong) NSString *statsEpgName;
- (id)initWithStatsEpgName:(NSString*)statsEpgName withTvhServer:(TVHServer*)tvhServer;
- (NSString*)getApiEpg;

- (void)setFilterToProgramTitle:(NSString *)filterToProgramTitle;
- (void)setFilterToChannelName:(NSString *)filterToChannelName;
- (void)setFilterToTagName:(NSString *)filterToTagName;
- (void)setFilterToContentTypeId:(NSString *)filterToContentTypeId;

- (void)downloadAllEpgItems;
- (void)downloadEpgList;
- (void)downloadMoreEpgList;
- (void)clearEpgData;
- (NSArray*)epgStoreItems;
- (void)setDelegate:(id <TVHEpgStoreDelegate>)delegate;
- (void)removeOldProgramsFromStore;
- (BOOL)isLastEpgFromThePast;
@end
