//
//  ClassDumpItem.h
//  XPoCed
//
//  Created by CodeColorist on 2020/2/29.
//  Copyright © 2020 me.chichou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DumpResult.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ClassDumpItemType) {
    kClassesRoot,
    kProtocolsRoot,
    kClassNode,
    kProtocolNode,
    kMethodNode,
};

@interface ClassDumpItem : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic) ClassDumpItemType type;
@property (nonatomic, retain) NSArray<ClassDumpItem*> *children;

+ (instancetype)nodeWithClass:(ClassInfo *)info;
+ (instancetype)nodeWithProtocol:(ProtocolInfo *)info;

- (BOOL)isGroup;

@end

NS_ASSUME_NONNULL_END
