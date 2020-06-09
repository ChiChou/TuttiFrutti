//
//  ClassDumpOutlineDelegate.h
//  TuttiFrutti
//
//  Created by CodeColorist on 2020/2/29.
//  Copyright © 2020 me.chichou. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ClassDumpItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface ClassDumpOutlineView : NSOutlineView <NSOutlineViewDelegate, NSOutlineViewDataSource>

@property (nonatomic, retain) NSString *path;
@property (atomic, retain) NSArray<ClassDumpItem*>*data;

@end

NS_ASSUME_NONNULL_END
