//
//  URLSchemesController.m
//  TuttiFrutti
//
//  Created by CodeColorist on 2020/3/1.
//  Copyright © 2020 me.chichou. All rights reserved.
//

#import "URLSchemesController.h"

@interface URLSchemesController ()
@property (weak) IBOutlet NSOutlineView *outlineView;
@end

@implementation URLSchemesController

@synthesize data;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    static NSArray *safariAllowes = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        safariAllowes = @[
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
        ];
    });
    
    self.data = [URLItem allURLs];
    self.outlineView.delegate = self;
    self.outlineView.dataSource = self;
    
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

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
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
