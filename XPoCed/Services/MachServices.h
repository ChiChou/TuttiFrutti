//
//  MachServices.h
//  XPoCed
//
//  Created by CodeColorist on 2020/2/28.
//  Copyright © 2020 me.chichou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ServiceManagement/ServiceManagement.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ServiceDomain) {
    kUserServices = 0x1337,
    kSystemServices
};

@interface MachServices : NSObject

+ (NSArray<NSDictionary*>*) copyForDomain:(ServiceDomain)domain;

@end

NS_ASSUME_NONNULL_END
