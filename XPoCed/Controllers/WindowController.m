//
//  WindowController.m
//  XPoCed
//
//  Created by CodeColorist on 2020/2/29.
//  Copyright © 2020 me.chichou. All rights reserved.
//

#import "WindowController.h"

#import <xpc/xpc.h>
#import "ClassDumperProtocol.h"

@interface WindowController ()
@property (weak) IBOutlet NSSearchField *search;
@property (weak) IBOutlet NSSegmentedControl *featureSwitch;
@end

@implementation WindowController

- (void)windowWillLoad {
    self.search.delegate = self;
    self.featureSwitch.selectedSegment = 0;
    

}

- (void)search:(NSString*)query {
    // todo: filter
}

- (void)controlTextDidChange:(NSNotification *)notification {
    NSTextField *textField = [notification object];
    NSString *query = textField.stringValue;

    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(search:) object:query];
    [self performSelector:@selector(search:) withObject:query afterDelay:0.5];
}

- (IBAction)switchPanel:(NSSegmentedControl *)sender {
    NSTabViewController *tab = (NSTabViewController *)self.window.contentViewController;
    tab.selectedTabViewItemIndex = sender.selectedSegment;
}

@end
