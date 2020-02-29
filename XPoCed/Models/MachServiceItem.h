//
//  MachServiceItem.h
//  XPoCed
//
//  Created by CodeColorist on 2020/2/28.
//  Copyright © 2020 me.chichou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MachServiceItem : NSObject
{
    NSString *identifier;
    NSArray<MachServiceItem*> *services;
    NSDictionary *info;
};

@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, retain) NSArray<MachServiceItem*> *services;
@property (nonatomic, retain) NSDictionary *info;

+ (id)groupWithName:(NSString *)name;
- (BOOL)isGroup;
- (NSString *)path;

@end

NS_ASSUME_NONNULL_END
