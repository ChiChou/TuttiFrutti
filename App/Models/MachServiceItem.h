//
//  MachServiceItem.h
//  TuttiFrutti
//
//  Created by CodeColorist on 2020/2/28.
//  Copyright © 2020 me.chichou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MachServiceItem : NSObject {
    NSArray<MachServiceItem *>* children;
}

@property (nonatomic, retain) NSString *filter;
@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, retain) NSArray<MachServiceItem*> *services;
@property (nonatomic, retain) NSDictionary *info;

+ (id)groupWithName:(NSString *)name;
- (BOOL)isGroup;
- (NSString *)path;

@end

NS_ASSUME_NONNULL_END
