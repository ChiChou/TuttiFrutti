//
//  WindowController.m
//  TuttiFrutti
//
//  Created by CodeColorist on 2020/2/29.
//  Copyright © 2020 me.chichou. All rights reserved.
//

#import "WindowController.h"

#import <xpc/xpc.h>
#import "ClassDumperProtocol.h"
#import "Magic.h"

@interface WindowController ()
@property (weak) IBOutlet NSSearchField *search;
@property (weak) IBOutlet NSSegmentedControl *featureSwitch;
@end

@implementation WindowController

- (void)windowWillLoad {
    self.search.delegate = self;
    self.featureSwitch.selectedSegment = 0;
}

- (void)keywordDidChange {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSearch object:self.search.stringValue];
}

- (void)keywordDidChangeThrottled {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(keywordDidChange) object:nil];
    [self performSelector:@selector(keywordDidChange) withObject:nil afterDelay:0.5];
}

- (void)controlTextDidChange:(NSNotification *)notification {
    NSTextField *textField = [notification object];
    if (textField == self.search) {
        [self keywordDidChangeThrottled];
    }
}

- (IBAction)switchPanel:(NSSegmentedControl *)sender {
    NSTabViewController *tabs = (NSTabViewController *)self.window.contentViewController;
    tabs.selectedTabViewItemIndex = sender.selectedSegment;
    self.search.stringValue = @"";
    [self keywordDidChangeThrottled];
}

@end
