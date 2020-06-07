//
//  NetBottom.m
//  TuttiFrutti
//
//  Created by CodeColorist on 2020/2/29.
//  Copyright © 2020 me.chichou. All rights reserved.
//

#import "NetBottom.h"

@implementation NetBottom

+ (instancetype)shared {
    static NetBottom *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NetBottom alloc] init];
    });
    return sharedInstance;
}

- (void) start {
    void (^description_callback_block)(CFDictionaryRef) = ^(CFDictionaryRef desc) {
        // NSLog(@"%@", desc);
    };
    
    void (^removal_callback_block)(NWStatisticsSource *) = ^(NWStatisticsSource *src) {
        // NSLog(@"remove %@", src);
    };
    
    void (^events_callback_block)(NWStatisticsSource *) = ^(NWStatisticsSource *src) {
        // NSLog(@"event %@", src);
    };
    
    void (^callback_block)(void *, void *) = ^(NStatSourceRef src, void *arg2){
        // Arg is NWS[TCP/UDP]Source

        NStatSourceSetRemovedBlock(src, removal_callback_block);
        NStatSourceSetEventsBlock(src, events_callback_block);
        NStatSourceSetDescriptionBlock(src, description_callback_block);
        NStatSourceQueryDescription(src);
    };
    
    NStatSourceRef nm = NStatManagerCreate(kCFAllocatorDefault, dispatch_get_main_queue(), callback_block);
    int rc = NStatManagerSetFlags(nm, 0);
    NSString *filename = [NSTemporaryDirectory()
                          stringByAppendingString:[NSProcessInfo.processInfo.globallyUniqueString
                                                   stringByAppendingString:@"-netbottom.trace"]];
    
    self.fd = open(filename.UTF8String, O_RDWR | O_CREAT | O_TRUNC);
    rc = NStatManagerSetInterfaceTraceFD(nm, self.fd);
    rc = NStatManagerAddAllUDPWithFilter(nm, 0, 0);
    rc = NStatManagerAddAllTCPWithFilter(nm, 0, 0);

    self.nm = nm;
}

- (void) end {
    NStatManagerDestroy(self.nm);
    close(self.fd);
}

@end
