//
//  NaiveClassDump.m
//  XPoCed
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
        self.connection.invalidationHandler = ^{
            
        };
        self.connection.interruptionHandler = ^{
            
        };
        self.connection.remoteObjectInterface = [NSXPCInterface interfaceWithProtocol:@protocol(ClassDumperProtocol)];
        [self.connection resume];
    }
    return self;
}

- (void)dumpForPath:(NSURL *)url withReply:(void (^)(NSError * err, DumpResult*))reply {
    [self.connection.remoteObjectProxy copyClassesForMachO:url withReply:^(NSError * _Nullable err, DumpResult* _Nullable result) {
        NSLog(@"%@\n%@", err, result);
        reply(err, result);
        
//        [result appendFormat:@"@interface %s", classes[i]];
//
//        if (dumpThisClass)
//            [result appendString:@">"];
//            [result appendFormat:@"\t-%@\n", methodName];
//        [result appendString:@"@end\n"];
//        [result appendString:@"\n\n"];
//        [result appendFormat:@"\t+%@\n", methodName];
//        [result appendFormat:@"@protocol %@\n", protocolName];
//        [result appendFormat:@"\t-%s\n", sel_getName(method.name)];
//        [result appendString:@"@end\n"];
    }];
}

@end
