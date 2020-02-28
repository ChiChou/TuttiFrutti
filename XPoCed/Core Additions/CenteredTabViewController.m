//
//  MainTabViewController.m
//  XPoCed
//
//  Created by CodeColorist on 2020/2/28.
//  Copyright © 2020 me.chichou. All rights reserved.
//

#import "CenteredTabViewController.h"

@interface CenteredTabViewController ()

@end

@implementation CenteredTabViewController

- (NSArray<NSToolbarItemIdentifier> *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
    [super toolbarDefaultItemIdentifiers:toolbar];
    NSMutableArray<NSToolbarItemIdentifier> *arr = [NSMutableArray arrayWithObject:NSToolbarFlexibleSpaceItemIdentifier];
    [self.tabViewItems enumerateObjectsUsingBlock:^(NSTabViewItem *item, NSUInteger idx, BOOL *stop) {
        [arr addObject:item.identifier];
    }];
    [arr addObject:NSToolbarFlexibleSpaceItemIdentifier];
    return [arr copy];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

@end
