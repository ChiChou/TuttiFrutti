//
//  NetworkTableView.h
//  TuttiFrutti
//
//  Created by codecolorist on 2020/6/9.
//  Copyright © 2020 me.chichou. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkTableView : NSTableView <NSTableViewDelegate, NSTableViewDataSource>

@property (strong) NSArray<NSDictionary*> *data;
@property (strong) NSDictionary<NSString *, NSNumber *> *mapping;

@end

NS_ASSUME_NONNULL_END
