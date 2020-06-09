//
//  NetworkTableView.m
//  TuttiFrutti
//
//  Created by codecolorist on 2020/6/9.
//  Copyright © 2020 me.chichou. All rights reserved.
//

#import "NetworkTableView.h"
#import "NetBottom.h"

@implementation NetworkTableView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

- (void)tableView:(NSTableView *)tableView sortDescriptorsDidChange:(NSArray<NSSortDescriptor *> *)oldDescriptors {
    self.data = [self.data sortedArrayUsingDescriptors:self.sortDescriptors];
    [self reloadData];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.data.count;
};

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSString *identifier = tableColumn.identifier;
    NSDictionary *item = self.data[row];
    CFDictionaryRef cfdict = (__bridge CFDictionaryRef)item;
    
    if ([identifier isEqualToString:@"NameCell"]) {
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:identifier owner:self];
        cellView.textField.stringValue = item[(__bridge NSString *)kNStatSrcKeyProcessName];
        NSNumber *pidNum = item[@"processID"];
        pid_t pid = pidNum.intValue;
        cellView.imageView.objectValue = [NSRunningApplication runningApplicationWithProcessIdentifier:pid].icon;
        return cellView;
    }
    
    NSString *(^TextForCell)(NSString *cell) = ^NSString *(NSString *cell) {
        if ([cell isEqualToString:@"LocalCell"]) {
            // todo: macro
            CFDataRef buf = CFDictionaryGetValue(cfdict, kNStatSrcKeyLocal);
            size_t len = CFDataGetLength(buf);
            struct sockaddr *addr = alloca(len);
            CFDataGetBytes(buf, CFRangeMake(0, len), (UInt8*)addr);
            char hostname[256];
            getnameinfo(addr, addr->sa_len, hostname, sizeof(hostname), NULL, 0, NI_NUMERICHOST);
            unsigned port = ntohs(((struct sockaddr_in *)addr)->sin_port);
            return [NSString stringWithFormat:@"%s:%u", hostname, port];

        } else if ([cell isEqualToString:@"RemoteCell"]) {
            CFDataRef buf = CFDictionaryGetValue(cfdict, kNStatSrcKeyRemote);
            size_t len = CFDataGetLength(buf);
            struct sockaddr *addr = alloca(len);
            CFDataGetBytes(buf, CFRangeMake(0, len), (UInt8*)addr);
            char hostname[256];
            getnameinfo(addr, addr->sa_len, hostname, sizeof(hostname), NULL, 0, NI_NUMERICHOST);
            unsigned short port = ntohs(((struct sockaddr_in *)addr)->sin_port);
            return [NSString stringWithFormat:@"%s:%u", hostname, port];
        } else if ([cell isEqualToString:@"StateCell"]) {
            CFStringRef provider = CFDictionaryGetValue(cfdict, kNStatSrcKeyProvider);
            if (CFStringCompare(provider, kNStatProviderTCP, 0) != kCFCompareEqualTo)
                return @"";
            CFStringRef state = CFDictionaryGetValue(cfdict, kNStatSrcKeyTCPState);
            return (__bridge NSString *)state;
        }

        return nil;
    };
    
    NSTableCellView *cellView = [tableView
                                 makeViewWithIdentifier:identifier owner:self];
    id mapping = @{
        @"PIDCell": @"processID",
        @"NameCell": @"processName",
    };

    id value = item[mapping[identifier]];
    NSString *label;
    if (value) {
        label = [NSString stringWithFormat:@"%@", value];
    } else {
        label = TextForCell(identifier);
    }
    cellView.textField.stringValue = label ? label : @"N/A";
    return cellView;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {

}

@end
