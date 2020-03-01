//
//  CodeSignChecker.h
//  TuttiFrutti
//
//  Created by CodeColorist on 2020/3/1.
//  Copyright © 2020 me.chichou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CodeSignChecker : NSObject
+ (instancetype) shared;
- (BOOL) isApple:(NSURL *)fileURL;
@end

NS_ASSUME_NONNULL_END
