//
//  ServicesViewController.m
//  XPoCed
//
//  Created by CodeColorist on 2020/2/28.
//  Copyright © 2020 me.chichou. All rights reserved.
//

#import "ServicesViewController.h"
#import "Magic.h"

@interface ServicesViewController ()

@property (weak) IBOutlet NSView *detailPanel;
@property (weak) IBOutlet NSTextField *detailField;
@property (weak) IBOutlet NSTextField *pathField;
@property (weak) IBOutlet NSOutlineView *outlineView;
@property (weak) IBOutlet ClassDumpOutlineView *classdumpOutlineView;
@property (weak) IBOutlet NSProgressIndicator *classdumpIndicator;
@property (strong) IBOutlet NSMenu *actionMenu;
@end

@implementation ServicesViewController
{
    MachServiceItem *selected;
}

@synthesize dataSource;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refresh];
    
    _detailPanel.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(receiveClassDumpLoadingNotification:)
        name:kNotificationClassDumpLoading
        object:nil];
}

- (void)receiveClassDumpLoadingNotification:(NSNotification *) notification {
    if ([notification.name isEqualToString:kNotificationClassDumpLoading]) {
        NSNumber* status = notification.object;
        _classdumpIndicator.hidden = !status.boolValue;
    }
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

- (void)outlineViewSelectionDidChange:(NSNotification *)notification {
    NSIndexSet *selectedIndexes = [_outlineView selectedRowIndexes];
    if (selectedIndexes.count == 0) {
        _detailPanel.hidden = YES;
        return;
    }

    _detailPanel.hidden = NO;
    NSUInteger index = selectedIndexes.firstIndex;
    NSUInteger current = 0;

    for (MachServiceItem *group in dataSource) {
        current++;
        if (group.services.count > index - current) {
            // update elements
            // todo: What is data binding?
            MachServiceItem *item = self->selected = group.services[index - current];
            [_detailField setStringValue:item.info.description];
            [_pathField setStringValue:item.path];
            
            _classdumpIndicator.hidden = NO;
            _classdumpOutlineView.path = item.path;
            break;
        }
        current += group.services.count;
    }
}

- (IBAction)revealInFinder:(id)sender {
    MachServiceItem *item = self->selected;
    if (item) {
        NSString *parent = [item.path stringByDeletingLastPathComponent];
        [[NSWorkspace sharedWorkspace] selectFile:item.path inFileViewerRootedAtPath:parent];
    }
}

- (IBAction)copyToClipboard:(id)sender {
    [[NSPasteboard generalPasteboard] declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:nil];
    [[NSPasteboard generalPasteboard] setString:_detailField.stringValue forType:NSStringPboardType];
}

- (IBAction)showActionMenu:(id)sender {
    NSButton *button = (NSButton *)sender;
    NSRect frame = [button frame];
    NSPoint menuOrigin = [[button superview] convertPoint:NSMakePoint(frame.origin.x, frame.origin.y) toView:nil];
    NSEvent *event = [NSEvent mouseEventWithType:NSEventTypeLeftMouseDown
                                        location:menuOrigin
                                   modifierFlags:0
                                       timestamp:0
                                    windowNumber:[[(NSButton *)sender window] windowNumber]
                                         context:[[(NSButton *)sender window] graphicsContext]
                                     eventNumber:0
                                      clickCount:1
                                        pressure:1];
    [NSMenu popUpContextMenu:self.actionMenu withEvent:event forView:(NSButton *)sender];
}


- (IBAction)openInIDA:(id)sender {
    NSMenuItem *menu = (NSMenuItem *)sender;
    NSMutableString *bundle = [NSMutableString stringWithString:@"ida"];
    if ([menu.identifier isEqualToString:@"openida64"]) {
        [bundle appendString:@"64"];
    }
    [[NSWorkspace sharedWorkspace] openFile:self->selected.path withApplication:bundle];
}

@end
