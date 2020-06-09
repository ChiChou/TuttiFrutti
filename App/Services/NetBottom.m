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

- (instancetype)init {
    self = [super init];
    self.active = [NSMutableDictionary new];
    return self;
}

- (NSArray *)connections {
    NSPredicate *filter = [NSPredicate predicateWithBlock:
                           ^BOOL(NSDictionary * _Nullable item, id bindings) {
        NSString *provider = item[(__bridge NSString *)kNStatSrcKeyProvider];
        if (!provider) return NO;
        if ([provider isEqualToString:(__bridge NSString *)kNStatProviderTCP]) {
            return self.includesTCP;
        } else if ([provider isEqualToString:(__bridge NSString*)kNStatProviderUDP]) {
            return self.includesUDP;
        }
        return NO;
    }];
    
    return [self.active.allValues filteredArrayUsingPredicate:filter];
}

- (void)start {
    NStatSourceRef nm = NStatManagerCreate(kCFAllocatorDefault, dispatch_get_main_queue(), ^(void *src, void *arg2){
        // Arg is NWS[TCP/UDP]Source

        NSValue *key = [NSValue valueWithPointer:src];
        NStatSourceSetRemovedBlock(src, ^() {
            NSDictionary *dict = self.active[key];
            if (dict && [self.delegate respondsToSelector:@selector(didRemove:)]) {
                [self.delegate didRemove:dict[(__bridge NSString *)kNStatSrcKeyUUID]];
            }
            [self.active removeObjectForKey:key];
        });

        NStatSourceSetDescriptionBlock(src, ^(CFDictionaryRef desc) {
            NSDictionary *dict = (__bridge NSDictionary *)desc;
            if ([self.delegate respondsToSelector:@selector(didChange)]) {
                [self.delegate didChange];
            }

            if ([self.delegate respondsToSelector:@selector(didUpdate:)]) {
                [self.delegate didUpdate:dict];
            }
            
            if (!self.active[key] &&
                [self.delegate respondsToSelector:@selector(didAdd:)]) {
                [self.delegate didAdd:dict];
            }

            self.active[key] = dict;
        });
        NStatSourceQueryDescription(src);
    });

    int rc = NStatManagerSetFlags(nm, 0);
    NSString *filename = [NSTemporaryDirectory()
                          stringByAppendingString:[NSProcessInfo.processInfo.globallyUniqueString
                                                   stringByAppendingString:@"-netbottom.trace"]];
    self.filename = filename.UTF8String;
    self.fd = open(self.filename, O_RDWR | O_CREAT | O_TRUNC);

    // todo: check result
    rc = NStatManagerSetInterfaceTraceFD(nm, self.fd);
    rc = NStatManagerAddAllUDPWithFilter(nm, 0, 0);
    rc = NStatManagerAddAllTCPWithFilter(nm, 0, 0);

    self.nm = nm;
}

- (void)stop {
    NStatManagerDestroy(self.nm);
    close(self.fd);
    unlink(self.filename);
}

@end
