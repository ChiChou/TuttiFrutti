//
//  ClassDumperProtocol.h
//  ClassDumper
//
//  Created by CodeColorist on 2020/2/29.
//  Copyright © 2020 me.chichou. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DumpResult.h"

// The protocol that this service will vend as its API. This header file will also need to be visible to the process hosting the service.
@protocol ClassDumperProtocol

// Replace the API of this protocol with an API appropriate to the service you are vending.
- (void)copyClassesForMachO:(NSURL*_Nonnull)url withReply:(void (^_Nonnull)(NSError * _Nullable err, DumpResult *_Nullable))reply;

@end

/*
 To use the service from an application or other process, use NSXPCConnection to establish a connection to the service by doing something like this:

     _connectionToService = [[NSXPCConnection alloc] initWithServiceName:@"me.chichou.ClassDumper"];
     _connectionToService.remoteObjectInterface = [NSXPCInterface interfaceWithProtocol:@protocol(ClassDumperProtocol)];
     [_connectionToService resume];

Once you have a connection to the service, you can use it like this:

     [[_connectionToService remoteObjectProxy] upperCaseString:@"hello" withReply:^(NSString *aString) {
         // We have received a response. Update our text field, but do it on the main thread.
         NSLog(@"Result string was: %@", aString);
     }];

 And, when you are finished with the service, clean up the connection like this:

     [_connectionToService invalidate];
*/
