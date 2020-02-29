//
//  ServicesViewController.h
//  XPoCed
//
//  Created by CodeColorist on 2020/2/28.
//  Copyright © 2020 me.chichou. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MachServiceItem.h"
#import "ClassDumpOutlineView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ServicesViewController : NSViewController <NSOutlineViewDelegate, NSOutlineViewDataSource>

@property (atomic, retain) NSMutableArray<MachServiceItem*>*dataSource;
@property (atomic, retain) NSArray<MachServiceItem *> *tree;

@end

NS_ASSUME_NONNULL_END
