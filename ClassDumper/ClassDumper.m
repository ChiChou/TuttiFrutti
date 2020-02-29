//
//  ClassDumper.m
//  ClassDumper
//
//  Created by CodeColorist on 2020/2/29.
//  Copyright © 2020 me.chichou. All rights reserved.
//

#import "ClassDumper.h"
#import "DumpResult.h"

#include <dlfcn.h>
#include <objc/runtime.h>
#include <xpc/xpc.h>


@implementation ClassDumper

- (void)copyClassesForMachO:(NSURL*)url withReply:(void (^)(NSError * err, DumpResult *))reply {
    const char *path = url.path.UTF8String;
    void *handle = dlopen(path, RTLD_LAZY | RTLD_GLOBAL);
    if (!handle) {
        NSError *err = [NSError errorWithDomain:NSPOSIXErrorDomain code:NSExecutableLoadError userInfo:@{
            NSUnderlyingErrorKey: [NSString stringWithUTF8String:dlerror()]
        }];
        reply(err, nil);
    }
    
    // todo: check imports
    // xpc_connection_copy_entitlement_value
    // xpc_connection_create_mach_service

    // todo: find LC_MAIN
    // const struct mach_header *header = (struct mach_header *)dlsym(handle, "_mh_execute_header");

    // naive classdump
    NSMutableSet *uniqueProcotols = [NSMutableSet set];
    DumpResult *result = [[DumpResult alloc] init];
    
    NSMutableArray *resultClasses = [NSMutableArray array];
    unsigned int count = 0;
    const char** classes = objc_copyClassNamesForImage(path, &count);
    for (int i = 0; i < count; i++) {
        Class klass = objc_getClass(classes[i]);
        
        ClassInfo *classInfo = [[ClassInfo alloc] init];
        classInfo.name = [NSString stringWithUTF8String:classes[i]];

        // protocols
        unsigned int protocolsCount = 0;
        NSMutableArray *classConfirmsTo = [NSMutableArray array];
        Protocol *__unsafe_unretained *protocols = class_copyProtocolList(klass, &protocolsCount);
        for (int j = 0; j < protocolsCount; j++) {
            Protocol *protocol = protocols[j];
            NSString *protocolName = [NSString stringWithUTF8String:protocol_getName(protocol)];
            [uniqueProcotols addObject:protocolName];
            [classConfirmsTo addObject:protocolName];
        }
        free(protocols);

        if (![klass conformsToProtocol:@protocol(NSXPCListenerDelegate)])
            continue;
        
        // super classes
        Class superKlass = klass;
        NSMutableArray *superClassesChain = [NSMutableArray array];
        while ((superKlass = class_getSuperclass(superKlass))) {
            [superClassesChain addObject:NSStringFromClass(superKlass)];
        }
        classInfo.superClasses = [superClassesChain copy];

        // dump methods
        unsigned int instanceMethodCount = 0;
        Method *instanceMethods = class_copyMethodList(klass, &instanceMethodCount);
        NSMutableArray *methods = [NSMutableArray array];
        for (int j = 0; j < instanceMethodCount; j++) {
            Method method = instanceMethods[j];
            NSString *methodName = NSStringFromSelector(method_getName(method));
            [methods addObject:methodName];
        }
        free(instanceMethods);

        classInfo.instanceMethods = [methods copy];
        [methods removeAllObjects];
        
        unsigned int classMethodCount = 0;
        Method *classMethods = class_copyMethodList(object_getClass(klass), &classMethodCount);
        // todo: MACRO
        for (int j = 0; j < classMethodCount; j++) {
            Method method = classMethods[j];
            NSString *methodName = NSStringFromSelector(method_getName(method));
            [methods addObject:methodName];
            
        }
        free(classMethods);
        classInfo.classMethods = [methods copy];
        [resultClasses addObject:classInfo];
    }
    free(classes);
    result.classes = [resultClasses copy];
    
    NSMutableArray *resultProtocols = [NSMutableArray array];
    for (NSString *protocolName in uniqueProcotols) {
        ProtocolInfo *info = [ProtocolInfo new];
        info.name = protocolName;

        Protocol *protocol = objc_getProtocol(protocolName.UTF8String);
        NSMutableArray *protocolMethods = [NSMutableArray array];
        
        void (^add)(BOOL, BOOL) = ^(BOOL isRequiredMethod, BOOL isInstanceMethod) {
            unsigned int methodsCount = 0;
            struct objc_method_description *methods = protocol_copyMethodDescriptionList(protocol, isRequiredMethod, isInstanceMethod, &methodsCount);
            for (int k = 0; k < methodsCount; k++) {
                NSString *name = NSStringFromSelector(methods[k].name);
                [protocolMethods addObject:name];
            }
            free(methods);
        };
        
        [protocolMethods removeAllObjects];
        add(YES, YES);
        add(NO, YES);
        info.instanceMethods = [protocolMethods copy];

        [protocolMethods removeAllObjects];
        add(YES, NO);
        add(NO, NO);
        info.classMethods = [protocolMethods copy];
        
        [resultProtocols addObject:info];
    }

    result.protocols = [resultProtocols copy];
    
    reply(nil, result);

    // do not reuse this process
    exit(0);
}

@end
