//
//  main.m
//  TuttiFrutti
//
//  Created by CodeColorist on 2020/2/28.
//  Copyright © 2020 me.chichou. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NetBottom.h"

#if 0
#import "NaiveClassDump.h"
#endif

int main(int argc, const char * argv[]) {
    @autoreleasepool {
#if 0
        // test class dumper
        [[NaiveClassDump shared]
         dumpForPath:[NSURL fileURLWithPath:@"/System/Library/CoreServices/SubmitDiagInfo"]
         withReply:^(NSError * _Nonnull err, DumpResult * _Nonnull result) {
            NSLog(@"%@", result);
        }];
#endif
    }
    return NSApplicationMain(argc, argv);
}
