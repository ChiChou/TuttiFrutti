//
//  DumpResult.h
//  ClassDumper
//
//  Created by CodeColorist on 2020/2/29.
//  Copyright © 2020 me.chichou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClassInfo : NSObject <NSSecureCoding>
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray<NSString*> *protocols;
@property (nonatomic, strong) NSArray<NSString*> *superClasses;
@property (nonatomic, strong) NSArray<NSString*> *instanceMethods;
@property (nonatomic, strong) NSArray<NSString*> *classMethods;
@end

@interface ProtocolInfo : NSObject <NSSecureCoding>
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray<NSString*> *instanceMethods;
@property (nonatomic, strong) NSArray<NSString*> *classMethods;
@end

@interface DumpResult : NSObject <NSSecureCoding>
@property (nonatomic, strong) NSArray<ClassInfo*> *classes;
@property (nonatomic, strong) NSArray<ProtocolInfo*> *protocols;
@end


NS_ASSUME_NONNULL_END
