//
//  NetworkViewController.m
//  TuttiFrutti
//
//  Created by codecolorist on 2020/6/5.
//  Copyright © 2020 me.chichou. All rights reserved.
//

#import "NetworkViewController.h"
#import "NetworkTableView.h"
#import "NetBottom.h"

@interface NetworkViewController () {
    BOOL includeTCP;
    BOOL includeUDP;
}

@property (weak) IBOutlet NetworkTableView *tableView;

@property NetBottom *net;
@property (weak) IBOutlet NSButton *checkTCP;
@property (weak) IBOutlet NSButton *checkUDP;

@end

@implementation NetworkViewController

- (IBAction)onToggleSwitches:(id)sender {
    [self refresh];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NetBottom *net = [NetBottom shared];
    net.delegate = self;
    [net start];

    _checkUDP.state = _checkTCP.state = NSControlStateValueOn;
    includeUDP = includeTCP = YES;

    [self refresh];
    self.net = net;
}

- (void)viewWillDisappear {
    [self.net stop];
}

- (void)didChange {
    [self refresh];
}

- (void)refresh {
    _net.includesUDP = includeUDP;
    _net.includesTCP = includeTCP;

    _tableView.data = _net.connections;
    NSInteger index = _tableView.selectedRow;
    [_tableView reloadData];
    
    if (index != -1) {
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:index];
        [_tableView selectRowIndexes:indexSet byExtendingSelection:NO];
    }
}

@end
