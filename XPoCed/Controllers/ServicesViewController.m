//
//  ServicesViewController.m
//  XPoCed
//
//  Created by CodeColorist on 2020/2/28.
//  Copyright © 2020 me.chichou. All rights reserved.
//

#import "ServicesViewController.h"

@interface ServicesViewController ()

@property (weak) IBOutlet NSOutlineView *outlineView;
@end

@implementation ServicesViewController

@synthesize dataSource;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refresh];
}

- (void)refresh {
    dataSource = [NSMutableArray arrayWithObjects:
                  [MachServiceItem groupWithName:@"System"],
                  [MachServiceItem groupWithName:@"User"],
                  nil];

    _outlineView.delegate = self;
    _outlineView.dataSource = self;

    [self performSelector:@selector(expandSourceList) withObject:nil afterDelay:0.0];
}

- (IBAction)expandSourceList
{
    [_outlineView expandItem:nil expandChildren:YES];
}

#pragma mark OUTLINE VIEW DELEGATE & DATASOURCE

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    if (item == nil) {
        return [self.dataSource objectAtIndex:index];
    } else {
        return [[item services] objectAtIndex:index];
    }
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        return self.dataSource.count; // system & user
    } else {
        return [[item services] count];
    }
}

- (NSView *)outlineView:(NSOutlineView *)outlineView
     viewForTableColumn:(NSTableColumn *)tableColumn
                   item:(id)item {
    NSTableCellView *view = nil;

    if ([item isGroup]) {
        view = [outlineView makeViewWithIdentifier:@"HeaderCell" owner:self];
    } else {
        view = [outlineView makeViewWithIdentifier:@"DataCell" owner:self];
//        [[view imageView] setImage:[item icon]];
    }
    [[view textField] setStringValue:[item identifier]];
    return view;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    return [item identifier];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    return NO;
}

- (NSCell *)outlineView:(NSOutlineView *)outlineView dataCellForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    NSInteger row = [outlineView rowForItem:item];
    return [tableColumn dataCellForRow:row];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item
{
    return [item isGroup];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    return [item isGroup];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item
{
    if ([outlineView parentForItem:item]) {
        return YES;
    }
    return NO;
}

@end
