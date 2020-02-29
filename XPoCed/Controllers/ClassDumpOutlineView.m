//
//  ClassDumpOutlineDelegate.m
//  XPoCed
//
//  Created by CodeColorist on 2020/2/29.
//  Copyright © 2020 me.chichou. All rights reserved.
//

#import "ClassDumpOutlineView.h"
#import "NaiveClassDump.h"
#import "ClassDumpItem.h"
#import "Magic.h"

@implementation ClassDumpOutlineView

@synthesize data;

- (void)awakeFromNib {
    self.delegate = self;
    self.dataSource = self;
    
    ClassDumpItem *classesRoot = [[ClassDumpItem alloc] init];
    classesRoot.type = kClassesRoot;
    classesRoot.name = @"Classes";
    ClassDumpItem *protocolsRoot = [[ClassDumpItem alloc] init];
    classesRoot.type = kProtocolsRoot;
    protocolsRoot.name = @"Protocols";
    
    self.data = @[classesRoot, protocolsRoot];
}

- (void)setPath:(NSString *)newPath {
    NSURL *url = [NSURL fileURLWithPath:newPath];
    ClassDumpItem *classesRoot = self.data.firstObject;
    ClassDumpItem *protocolsRoot = self.data.lastObject;

    self.enabled = NO;
    classesRoot.children = @[];
    protocolsRoot.children = @[];
    [self reloadData];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationClassDumpLoading
                                                        object:[NSNumber numberWithBool:YES]];

    [[NaiveClassDump shared] dumpFor:url withReply:^(NSError * _Nonnull err, DumpResult * _Nonnull result) {
        NSMutableArray<ClassDumpItem *> *children = [NSMutableArray array];
        for (ClassInfo *info in result.classes) {
            ClassDumpItem *item = [ClassDumpItem nodeWithClass:info];
            [children addObject:item];
        }
        classesRoot.children = [children copy];

        [children removeAllObjects];
        for (ClassInfo *info in result.classes) {
            ClassDumpItem *item = [[ClassDumpItem alloc] init];
            item.type = kClassNode;
            item.name = [NSString stringWithFormat:@"@interface %@", info.name];
            
            [children addObject:item];
        }
        protocolsRoot.children = [children copy];

        [self performSelectorOnMainThread:@selector(refresh) withObject:nil waitUntilDone:NO];
    }];
    
    _path = newPath;
}

- (void)refresh {
    self.enabled = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationClassDumpLoading
                                                        object:[NSNumber numberWithBool:NO]];

    [self reloadData];
    [self expandItem:self.data.firstObject expandChildren:YES];
    [self expandItem:self.data.lastObject expandChildren:YES];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(ClassDumpItem *)item {
    return NO;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(ClassDumpItem*)item {
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
                   item:(ClassDumpItem *)item {
    id icon = NSImageNameFolderSmart;
    switch(item.type) {
        case kProtocolNode:
            icon = NSImageNameAdvanced;
            break;
        case kClassNode:
            icon = NSImageNameSmartBadgeTemplate;
            break;
        case kMethodNode:
            icon = NSImageNameStatusAvailable;
            break;
        case kClassesRoot:
        case kProtocolsRoot:
        default:
            icon = NSImageNameFolderSmart;
    }
    
    NSTableCellView *view = [outlineView makeViewWithIdentifier:@"DataCell" owner:self];
    [[view imageView] setImage:[NSImage imageNamed:icon]];
    [[view textField] setStringValue:item.name];
    return view;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(ClassDumpItem *)item
{
    return item.name;
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
