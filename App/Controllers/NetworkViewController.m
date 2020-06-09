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

@end

@implementation NetworkViewController

- (IBAction)onToggleSwitches:(id)sender {
    _net.includesUDP = includeUDP;
    _net.includesTCP = includeTCP;
    [self refresh];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NetBottom *net = [NetBottom shared];
    net.delegate = self;
    [net start];
    
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
    _tableView.data = _net.connections;
    [_tableView reloadData];
}

@end
