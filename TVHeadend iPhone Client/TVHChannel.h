//
//  Channel.h
//  TVHeadend iPhone Client
//
//  Created by zipleen on 2/3/13.
//  Copyright (c) 2013 zipleen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TVHEpg.h"

@class TVHEpg;

@protocol TVHChannelDelegate <NSObject>
- (void) didLoadEpgChannel;
@optional
-(void) didErrorLoadingEpgChannel:(NSError*)error;
@end

@interface TVHChannel : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSData *image;
@property (nonatomic) NSInteger chid;
@property (nonatomic, strong) NSArray *tags;

-(void)setCh_id:(NSString*)value;
-(bool) hasTag:(NSInteger)tag;
-(NSString*) streamURL;
-(void) addEpg:(TVHEpg*)epg;
-(TVHEpg*) currentPlayingProgram;

-(void) downloadRestOfEpg;
-(NSInteger) countEpg;
-(NSString*) dateStringForDay:(NSInteger)day;
-(NSArray*) programsForDay:(NSInteger)day;
-(TVHEpg*) programDetailForDay:(NSInteger)day index:(NSInteger)program;
-(NSInteger) numberOfProgramsInDay:(NSInteger)section;
-(NSInteger) totalCountOfDaysEpg;

-(void)setDelegate:(id <TVHChannelDelegate>) delegate;
@end
