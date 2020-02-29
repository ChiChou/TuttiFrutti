//
//  NaiveClassDump.h
//  XPoCed
//
//  Created by CodeColorist on 2020/2/29.
//  Copyright © 2020 me.chichou. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ClassDumperProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface NaiveClassDump : NSObject
@property (nonatomic, strong) NSXPCConnection *connection;

- (void)dumpFor:(NSURL *)path withReply:(void (^)(NSError *err, DumpResult*))reply;

+ (id)shared;
@end

NS_ASSUME_NONNULL_END
