//
//  ClassDumper.h
//  ClassDumper
//
//  Created by CodeColorist on 2020/2/29.
//  Copyright © 2020 me.chichou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClassDumperProtocol.h"

// This object implements the protocol which we have defined. It provides the actual behavior for the service. It is 'exported' by the service to make it available to the process hosting the service over an NSXPCConnection.
@interface ClassDumper : NSObject <ClassDumperProtocol>
@end
