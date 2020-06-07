//
//  URLItem.m
//  TuttiFrutti
//
//  Created by CodeColorist on 2020/3/1.
//  Copyright © 2020 me.chichou. All rights reserved.
//

#import <AppKit/AppKit.h>

#import "URLItem.h"
#import "CodeSignChecker.h"

extern OSStatus _LSCopySchemesAndHandlerURLs(CFArrayRef *outSchemes, CFArrayRef *outApps);
extern OSStatus _LSCopyAllApplicationURLs(CFArrayRef *theList);


@implementation URLItem

@synthesize children;
@synthesize title;
@synthesize icon;

- (NSString *)title {
    if (self.type == kURLItemSchemeGroup) {
        return [NSString stringWithFormat:@"%@://", self.identifier];
    }
    return self.identifier;
}

- (void)setTitle:(NSString *)newTitle {
    title = newTitle;
}

- (BOOL)isGroup {
    return self.children.count;
}

+ (NSArray<URLItem *>*)allURLs {
    CFArrayRef schemes = NULL;
    CFArrayRef apps = NULL;

    NSMutableArray *list = [NSMutableArray array];
    _LSCopySchemesAndHandlerURLs(&schemes, &apps);
    
    for (CFIndex i = 0, count = CFArrayGetCount(schemes); i < count; i++) {
        CFStringRef scheme = CFArrayGetValueAtIndex(schemes, i);
        URLItem *child = [URLItem groupWithScheme:scheme];
        if (child.children.count)
            [list addObject:child];
    }

    CFRelease(schemes);
    CFRelease(apps);

    return [list copy];;
}

+ (instancetype)groupWithScheme:(CFStringRef)scheme {
    URLItem *instance = [[URLItem alloc] init];
    instance.type = kURLItemSchemeGroup;
    instance.identifier = (__bridge NSString *)scheme;

    NSMutableArray *children = [NSMutableArray array];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CFArrayRef handlers = LSCopyAllHandlersForURLScheme(scheme);
#pragma clang diagnostic pop

    for (CFIndex j = 0, bundle_count = CFArrayGetCount(handlers); j < bundle_count; j++) {
        CFStringRef handler = CFArrayGetValueAtIndex(handlers, j);
        URLItem *child = [URLItem appItemWithBundleId:handler];
        child.path = [[NSWorkspace sharedWorkspace] URLForApplicationWithBundleIdentifier:(__bridge NSString *)handler];
        [children addObject:child];
    }

    CFRelease(handlers);
    instance.children = [children copy];
    return instance;
}

+ (instancetype)appItemWithBundleId:(CFStringRef)bundle {
    URLItem *instance = [[URLItem alloc] init];
    instance.type = kURLItemApp;
    instance.identifier = (__bridge NSString *)bundle;
    return instance;
}

- (NSImage *)icon {
    if (self.type == kURLItemSchemeGroup) {
        return [NSImage imageNamed:NSImageNameFolder];
    }

    NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
    NSString *path = [workspace absolutePathForAppBundleWithIdentifier:self.identifier];
    return [workspace iconForFile:path];
}

@end
