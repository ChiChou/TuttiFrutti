//
//  URLSchemesController.h
//  TuttiFrutti
//
//  Created by CodeColorist on 2020/3/1.
//  Copyright © 2020 me.chichou. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "URLItem.h"

NS_ASSUME_NONNULL_BEGIN


@interface URLSchemesController : NSViewController <NSOutlineViewDelegate, NSOutlineViewDataSource>

@property (atomic, retain) NSArray<URLItem*>*data;

@end

NS_ASSUME_NONNULL_END
