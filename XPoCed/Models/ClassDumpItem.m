//
//  ClassDumpItem.m
//  XPoCed
//
//  Created by CodeColorist on 2020/2/29.
//  Copyright © 2020 me.chichou. All rights reserved.
//

#import "ClassDumpItem.h"

@implementation ClassDumpItem

@synthesize type;

+ (instancetype)nodeWithClass:(ClassInfo *)info {
    ClassDumpItem *instance = [[ClassDumpItem alloc] init];
    if (instance) {
        instance.type = kClassNode;
        // todo: refactor
        NSMutableArray *allMethods = [NSMutableArray array];
        for (NSString *method in info.instanceMethods) {
            ClassDumpItem *item = [[ClassDumpItem alloc] init];
            item.type = kMethodNode;
            item.name = [NSString stringWithFormat:@"- %@", method];
            [allMethods addObject:item];
        }
        
        for (NSString *method in info.classMethods) {
            ClassDumpItem *item = [[ClassDumpItem alloc] init];
            item.type = kMethodNode;
            item.name = [NSString stringWithFormat:@"+ %@", method];
            [allMethods addObject:item];
        }
        
        instance.children = [allMethods copy];

        NSString *protocols = @"";
        if (info.protocols) {
            NSString *chain = [info.superClasses componentsJoinedByString:@", "];
            protocols = [NSString stringWithFormat:@" <%@>", chain];
        }
        NSString *superClass = info.superClasses ? [NSString stringWithFormat:@" : %@", info.superClasses.firstObject] : @"";
        instance.name = [NSString stringWithFormat:@"@interface %@%@%@", info.name, superClass, protocols];
    }
    
    return instance;
}

+ (instancetype)nodeWithProtocol:(ProtocolInfo *)info {
    ClassDumpItem *instance = [[ClassDumpItem alloc] init];
    if (instance) {
        instance.type = kProtocolNode;

        // todo: refactor
        NSMutableArray *allMethods = [NSMutableArray array];
        for (NSString *method in info.instanceMethods) {
            ClassDumpItem *item = [[ClassDumpItem alloc] init];
            item.type = kMethodNode;
            item.name = [NSString stringWithFormat:@"- %@", method];
            [allMethods addObject:item];
        }
        
        for (NSString *method in info.classMethods) {
            ClassDumpItem *item = [[ClassDumpItem alloc] init];
            item.type = kMethodNode;
            item.name = [NSString stringWithFormat:@"+ %@", method];
            [allMethods addObject:item];
        }
        instance.children = [allMethods copy];
        instance.name = [NSString stringWithFormat:@"@protocol %@", info.name];
    }
    return instance;
}

- (BOOL)isGroup {
    return self.type != kMethodNode;
}

@end
