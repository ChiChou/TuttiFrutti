//
//  DumpResult.m
//  ClassDumper
//
//  Created by CodeColorist on 2020/2/29.
//  Copyright © 2020 me.chichou. All rights reserved.
//

#import "DumpResult.h"

@implementation DumpResult

@synthesize classes;
@synthesize protocols;

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:classes forKey:@"classes"];
    [coder encodeObject:protocols forKey:@"protocols"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    if ((self = [super init]))
    {
        classes = [coder decodeObjectOfClasses:[NSSet setWithObjects:[NSArray class], [ClassInfo class], nil] forKey:@"classes"];
        protocols = [coder decodeObjectOfClasses:[NSSet setWithObjects:[NSArray class], [ProtocolInfo class], nil] forKey:@"protocols"];
    }
    return self;
}

@end

@implementation ProtocolInfo

@synthesize name;
@synthesize instanceMethods;
@synthesize classMethods;

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:name forKey:@"name"];
    [coder encodeObject:instanceMethods forKey:@"instanceMethods"];
    [coder encodeObject:classMethods forKey:@"classMethods"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    if ((self = [super init]))
    {
        name = [coder decodeObjectOfClass:[NSString class] forKey:@"name"];
        instanceMethods = [coder decodeObjectOfClasses:[NSSet setWithObjects:[NSArray class], [NSString class], nil] forKey:@"instanceMethods"];
        classMethods = [coder decodeObjectOfClasses:[NSSet setWithObjects:[NSArray class], [NSString class], nil] forKey:@"classMethods"];
    }
    return self;
}

@end

@implementation ClassInfo

@synthesize name;
@synthesize protocols;
@synthesize superClasses;
@synthesize instanceMethods;
@synthesize classMethods;

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:name forKey:@"name"];
    [coder encodeObject:protocols forKey:@"protocols"];
    [coder encodeObject:superClasses forKey:@"superClasses"];
    [coder encodeObject:instanceMethods forKey:@"instanceMethods"];
    [coder encodeObject:classMethods forKey:@"classMethods"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    if ((self = [super init]))
    {
        NSSet *stringAndArray = [NSSet setWithObjects:[NSArray class], [NSString class], nil];
        name = [coder decodeObjectOfClass:[NSString class] forKey:@"name"];
        protocols = [coder decodeObjectOfClasses:stringAndArray forKey:@"protocols"];
        superClasses = [coder decodeObjectOfClasses:stringAndArray forKey:@"superClasses"];
        instanceMethods = [coder decodeObjectOfClasses:stringAndArray forKey:@"instanceMethods"];
        classMethods = [coder decodeObjectOfClasses:stringAndArray forKey:@"classMethods"];
    }
    return self;
}

@end
