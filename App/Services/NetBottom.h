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


@interface NetBottom : NSObject
@property(nonatomic, assign) int fd;
@property(nonatomic, assign) NStatManagerRef nm;

+ (instancetype)shared;
- (void)start;
- (void)end;

@end

NS_ASSUME_NONNULL_END
