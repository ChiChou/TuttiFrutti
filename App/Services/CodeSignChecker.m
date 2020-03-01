//
//  CodeSignChecker.m
//  TuttiFrutti
//
//  Created by CodeColorist on 2020/3/1.
//  Copyright © 2020 me.chichou. All rights reserved.
//

#import "CodeSignChecker.h"

static SecRequirementRef isApple = nil;
static SecRequirementRef isDevID = nil;
static SecRequirementRef isAppStore = nil;

@implementation CodeSignChecker

+ (instancetype) shared {
    static CodeSignChecker *sharedInstance = nil;
    // taken from https://github.com/objective-see/ProcInfo/blob/297c312fe3ad/procInfo/Signing.m#L191
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        SecRequirementCreateWithString(CFSTR("anchor apple"), kSecCSDefaultFlags, &isApple);
        SecRequirementCreateWithString(CFSTR("anchor apple generic"), kSecCSDefaultFlags, &isDevID);
        SecRequirementCreateWithString(CFSTR("anchor apple generic and certificate leaf [subject.CN] = \"Apple Mac OS Application Signing\""), kSecCSDefaultFlags, &isAppStore);
        
        sharedInstance = [[CodeSignChecker alloc] init];
    });

    return sharedInstance;
}

- (BOOL) isApple:(NSURL *)fileURL {
    return [self checkCode:fileURL forRequirement:isApple];
}

- (BOOL) checkCode:(NSURL *)fileURL forRequirement:(SecRequirementRef)requirement {
    SecStaticCodeRef code;
    OSStatus status = SecStaticCodeCreateWithPath((__bridge CFURLRef)fileURL, kSecCSDefaultFlags, &code);
    if (errSecSuccess != status)
        return NO;

    int flags = kSecCSConsiderExpiration | kSecCSEnforceRevocationChecks | kSecCSCheckTrustedAnchors;
    status = SecStaticCodeCheckValidity(code, flags, requirement);
    return errSecSuccess == status;
}

@end
