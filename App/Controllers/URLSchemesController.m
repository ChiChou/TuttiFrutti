//
//  URLSchemesController.m
//  TuttiFrutti
//
//  Created by CodeColorist on 2020/3/1.
//  Copyright © 2020 me.chichou. All rights reserved.
//

#import <dispatch/dispatch.h>
#import "URLSchemesController.h"
#import "CodeSignChecker.h"
#import "Magic.h"

static NSSet *safariAllowes = nil;

@interface URLSchemesController() {
    BOOL appleOnly;
    BOOL safariReachable;
    
    dispatch_queue_t q;
}

@property (weak) IBOutlet NSProgressIndicator *indicator;
@property (weak) IBOutlet NSOutlineView *outlineView;
@property (weak) IBOutlet NSButton *btnAppleOnly;
@property (weak) IBOutlet NSButton *btnSafariOnly;

@property (atomic) NSString *keyword;

@end

@implementation URLSchemesController

@synthesize data;

- (IBAction)onToggleSwitches:(id)sender {
    [self refresh];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // urlSchemesToOpenWithoutPrompting()::whitelistedURLSchemes
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        safariAllowes = [NSSet setWithArray:@[
            @"x-apple-helpbasic",
            @"itms",
            @"rdar",
            @"itms-bookss",
            @"radar",
            @"ts",
            @"applenewss",
            @"radr",
            @"applenews",
            @"itms-books",
            @"udoc",
            @"itmss",
            @"ibooks",
            @"adir",
            @"macappstore",
            @"icloud-sharing",
            @"help",
            @"macappstores",
            @"st",
            @"itunes",
            @"x-radar"
        ]];
    });
    
    self.outlineView.delegate = self;
    self.outlineView.dataSource = self;
    
    q = dispatch_queue_create("me.chichou.tuttifrutti.background", DISPATCH_QUEUE_SERIAL);
    
    [self refresh];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveSearchNotification:)
                                                 name:kNotificationSearch
                                               object:nil];
}

- (void)receiveSearchNotification:(NSNotification *)notification {
    _keyword = notification.object;
    [self refresh];
}

- (void)refresh {
    self.btnSafariOnly.enabled = self.btnAppleOnly.enabled = self.indicator.hidden = NO;
    [self.indicator startAnimation:nil];
    
    self.data = @[];
    [self.outlineView reloadData];
    
    dispatch_async(q, ^{ [self fetch]; });
}

- (void)fetch {
    NSArray<URLItem*> *result = [URLItem allURLs];
    
    if (safariReachable) {
        result = [result filteredArrayUsingPredicate:
                  [NSPredicate predicateWithBlock:
                   ^BOOL(URLItem *item, NSDictionary<NSString *,id> * _Nullable bindings) {
            return [safariAllowes containsObject:item.identifier];
        }]];
    }

    if (self.keyword && self.keyword.length) {
        result = [result filteredArrayUsingPredicate:
                  [NSPredicate predicateWithBlock:
                   ^BOOL(URLItem *group, NSDictionary<NSString *,id> * _Nullable bindings) {
            if ([group.identifier localizedCaseInsensitiveContainsString:self.keyword]) return YES;

            group.children = [group.children filteredArrayUsingPredicate:
                              [NSPredicate predicateWithBlock:
                               ^BOOL(URLItem *item, NSDictionary<NSString *,id> * _Nullable bindings) {
                return [item.path.absoluteString localizedCaseInsensitiveContainsString:self.keyword] ||
                [item.identifier localizedCaseInsensitiveContainsString:self.keyword];
            }]];
            
            return group.children.count > 0;
        }]];
    }

    if (appleOnly) {
        result = [result filteredArrayUsingPredicate:
                  [NSPredicate predicateWithBlock:
                   ^BOOL(URLItem *group, NSDictionary<NSString *,id> * _Nullable bindings) {
            group.children = [group.children filteredArrayUsingPredicate:
                              [NSPredicate predicateWithBlock:
                               ^BOOL(URLItem *item, NSDictionary<NSString *,id> * _Nullable bindings) {
                return [[CodeSignChecker shared] isApple:item.path];
            }]];
            
            return group.children.count > 0;
        }]];
    }

    [self performSelectorOnMainThread:@selector(update:) withObject:result waitUntilDone:NO];
}

- (void)update:(NSArray *)data {
    [self.indicator stopAnimation:nil];
    self.btnSafariOnly.enabled = self.btnAppleOnly.enabled = self.indicator.hidden = YES;
    
    self.data = data;
    [self.outlineView reloadData];
    for (id node in self.data) {
        [self.outlineView expandItem:node expandChildren:NO];
    }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(URLItem *)item {
    return NO;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(URLItem*)item {
    return item.isGroup;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item {
    return YES;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    if (item == nil) {
        return [self.data objectAtIndex:index];
    } else {
        return [[item children] objectAtIndex:index];
    }
}

- (NSView *)outlineView:(NSOutlineView *)outlineView
     viewForTableColumn:(NSTableColumn *)tableColumn
                   item:(URLItem *)item {
    
    NSTableCellView *view = [outlineView makeViewWithIdentifier:@"DataCell" owner:self];
    [[view imageView] setImage:item.icon];
    [[view textField] setStringValue:item.title];
    return view;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(URLItem *)item
{
    return item.title;
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        return [self.data count];
    } else {
        return [[item children] count];
    }
}


@end
