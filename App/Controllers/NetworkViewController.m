//
//  NetworkViewController.m
//  TuttiFrutti
//
//  Created by codecolorist on 2020/6/5.
//  Copyright © 2020 me.chichou. All rights reserved.
//

#import "NetworkViewController.h"
#import "NetBottom.h"

@interface NetworkViewController ()

@end

@implementation NetworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NetBottom *net = [NetBottom shared];
    [net start];
}

@end
