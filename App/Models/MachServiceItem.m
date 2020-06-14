//
//  MachServiceItem.m
//  TuttiFrutti
//
//  Created by CodeColorist on 2020/2/28.
//  Copyright © 2020 me.chichou. All rights reserved.
//

#import "MachServiceItem.h"
#import "MachServices.h"

@implementation MachServiceItem

@synthesize info;
@synthesize services;
@synthesize identifier;

+ (id)groupWithName:(NSString *)name {
    MachServiceItem *group = [MachServiceItem new];
    group.identifier = name;
    
    NSUInteger domain = kSystemServices;
    if ([name isEqualToString:@"User"]) {
        domain = kUserServices;
    } else if (![name isEqualToString:@"System"]) {
        @throw [NSException exceptionWithName:@"InvalidArgument" reason:@"Unknown domain" userInfo:nil];
    }

    NSMutableArray<MachServiceItem*> *children = [NSMutableArray array];
    NSArray<NSDictionary *> *services = [MachServices copyForDomain:domain];
    for (NSDictionary *info in services) {
        [children addObject:[MachServiceItem itemWithInfo:info]];
    }

    group->children = [children copy];
    return group;
}

+ (id)itemWithInfo:(NSDictionary *)info {
    MachServiceItem *item = [MachServiceItem new];
    item->children = @[];
    item.identifier = info[@"Label"];
    item.info = info;
    return item;
}

- (BOOL)isGroup {
    return children.count > 0;
}

- (NSArray<MachServiceItem *>*)services {
    if (self.filter && self.filter.length) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:
                                  @"identifier CONTAINS [cd] %@ or info CONTAINS [cd] %@", self.filter, self.filter];
        return [children filteredArrayUsingPredicate:predicate];
    }

    return children;
}

- (NSString*)path {
    if (self.isGroup) return nil;
    if (!info) return nil;
    if (info[@"Program"]) return info[@"Program"];
    NSArray *args = info[@"ProgramArguments"];
    if (!args) return nil;
    return args.firstObject;
}

@end
