//
//  main.m
//  XPoCed
//
//  Created by CodeColorist on 2020/2/28.
//  Copyright © 2020 me.chichou. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NaiveClassDump.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        [[NaiveClassDump shared] dumpForPath:[NSURL fileURLWithPath:@"/System/Library/CoreServices/SubmitDiagInfo"] withReply:^(NSError * _Nonnull err, DumpResult * _Nonnull result) {
            NSLog(@"%@", result);
        }];
    }
    return NSApplicationMain(argc, argv);
}
