//
//  NetBottom.h
//  TuttiFrutti
//
//  Created by CodeColorist on 2020/2/29.
//
//  Originally taken from http://newosxbook.com/src.jl?tree=listings&file=netbottom.c
// 
//

#import <Foundation/Foundation.h>

#include <arpa/inet.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>

#include "NetworkStatistics.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ConnectionsRefreshDelegate <NSObject>
@optional
- (void)didAdd:(NSDictionary *)info;
- (void)didUpdate:(NSDictionary *)info;
- (void)didRemove:(NSString *)uuid;
- (void)didChange;
@end


@interface NetBottom : NSObject
@property(nonatomic, assign) const char *filename;
@property(nonatomic, assign) int fd;
@property(nonatomic, assign) NStatManagerRef nm;
@property(nonatomic) NSMutableDictionary<NSValue *, NSDictionary *> *active;
@property(nonatomic) id<ConnectionsRefreshDelegate> delegate;
@property(nonatomic, assign) BOOL includesTCP;
@property(nonatomic, assign) BOOL includesUDP;

+ (instancetype)shared;
- (void)start;
- (void)stop;
- (NSArray *)connections;

@end

NS_ASSUME_NONNULL_END
