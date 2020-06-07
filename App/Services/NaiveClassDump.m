//
//  NaiveClassDump.m
//  TuttiFrutti
//
//  Created by CodeColorist on 2020/2/29.
//  Copyright © 2020 me.chichou. All rights reserved.
//

#import "NaiveClassDump.h"

@implementation NaiveClassDump
@synthesize connection;

+ (id)shared {
    static NaiveClassDump *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.connection = [[NSXPCConnection alloc] initWithServiceName:@"me.chichou.ClassDumper"];
        self.connection.invalidationHandler = ^{};
        self.connection.interruptionHandler = ^{};
        self.connection.remoteObjectInterface = [NSXPCInterface interfaceWithProtocol:@protocol(ClassDumperProtocol)];
        [self.connection resume];
    }
    return self;
}

- (void)dumpFor:(NSURL *)url withReply:(void (^)(NSError * err, DumpResult*))reply {
    [self.connection.remoteObjectProxy copyClassesForMachO:url withReply:reply];
}

@end
