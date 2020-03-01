//
//  MachServices.m
//  TuttiFrutti
//
//  Created by CodeColorist on 2020/2/28.
//  Copyright © 2020 me.chichou. All rights reserved.
//

#import "MachServices.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"


@implementation MachServices

+ (NSArray<NSDictionary *>*)copyForDomain:(ServiceDomain)domain {
    if (domain == kUserServices) {
        return (__bridge NSArray*)SMCopyAllJobDictionaries(kSMDomainUserLaunchd);
    } else {
        return (__bridge NSArray*)SMCopyAllJobDictionaries(kSMDomainSystemLaunchd);
    }
}

@end
