//
//  URLItem.h
//  TuttiFrutti
//
//  Created by CodeColorist on 2020/3/1.
//  Copyright © 2020 me.chichou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, URLTypeItemType) {
    kURLItemSchemeGroup,
    kURLItemApp,
};

@interface URLItem : NSObject

@property (nonatomic) URLTypeItemType type;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSImage *icon;
@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, retain) NSURL *path;
@property (nonatomic, retain, nullable) NSArray<URLItem*> *children;

- (BOOL)isGroup;
+ (instancetype)groupWithScheme:(CFStringRef)scheme;

+ (NSArray<URLItem *>*)allURLs;
@end

NS_ASSUME_NONNULL_END
