//
// Copyright (c) 2020 Emarsys. All rights reserved.
//
#import "EMSStorage.h"

#define kEMSSuiteName @"com.emarsys.core"

@interface EMSStorage ()

@property(nonatomic, strong) NSUserDefaults *userDefaults;
@property(nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation EMSStorage

- (instancetype)initWithOperationQueue:(NSOperationQueue *)operationQueue {
    if (self = [super init]) {
        _operationQueue = operationQueue;
        _userDefaults = [[NSUserDefaults alloc] initWithSuiteName:kEMSSuiteName];
    }
    return self;
}

- (void)setData:(nullable NSData *)data
         forKey:(NSString *)key {
    NSParameterAssert(key);
    [self.operationQueue addOperationWithBlock:^{
        NSMutableDictionary *mutableQuery = [NSMutableDictionary new];
        mutableQuery[(id) kSecAttrAccount] = key;
        mutableQuery[(id) kSecClass] = (id) kSecClassGenericPassword;
        mutableQuery[(id) kSecAttrAccessible] = (id) kSecAttrAccessibleWhenUnlockedThisDeviceOnly;
        mutableQuery[(id) kSecValueData] = data;

        NSDictionary *query = [NSDictionary dictionaryWithDictionary:mutableQuery];

        OSStatus status = SecItemAdd((__bridge CFDictionaryRef) query, NULL);
        if (status == errSecDuplicateItem) {
            SecItemDelete((__bridge CFDictionaryRef) query);
            SecItemAdd((__bridge CFDictionaryRef) query, NULL);
        } else if (status != errSecSuccess) {;
        }
    }];
}

- (void)setString:(nullable NSString *)string
           forKey:(NSString *)key {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [self setData:data
           forKey:key];
}

- (void)setNumber:(nullable NSNumber *)number
           forKey:(NSString *)key {
    [self setData:[NSKeyedArchiver archivedDataWithRootObject:number]
           forKey:key];
}

- (void)setDictionary:(nullable NSDictionary *)dictionary
               forKey:(NSString *)key {
    [self setData:[NSKeyedArchiver archivedDataWithRootObject:dictionary]
           forKey:key];
}

- (nullable NSData *)dataForKey:(NSString *)key {
    NSParameterAssert(key);
    NSData *result;
    NSMutableDictionary *mutableQuery = [NSMutableDictionary new];
    mutableQuery[(id) kSecClass] = (id) kSecClassGenericPassword;
    mutableQuery[(id) kSecAttrAccessible] = (id) kSecAttrAccessibleWhenUnlockedThisDeviceOnly;
    mutableQuery[(id) kSecAttrAccount] = key;
    mutableQuery[(id) kSecReturnData] = (id) kCFBooleanTrue;
    mutableQuery[(id) kSecReturnAttributes] = (id) kCFBooleanTrue;

    NSDictionary *query = [NSDictionary dictionaryWithDictionary:mutableQuery];

    CFTypeRef resultRef = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef) query, &resultRef);
    if (status == errSecSuccess) {
        NSDictionary *resultDict = (__bridge NSDictionary *) resultRef;
        result = resultDict[(id) kSecValueData];
    }

    if (resultRef) {
        CFRelease(resultRef);
    }
    return result;
}

- (nullable NSString *)stringForKey:(NSString *)key {
    NSData *data = [self dataForKey:key];

    return data ? [[NSString alloc] initWithData:data
                                        encoding:NSUTF8StringEncoding] : nil;
}

- (nullable NSNumber *)numberForKey:(NSString *)key {
    NSData *data = [self dataForKey:key];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (nullable NSDictionary *)dictionaryForKey:(NSString *)key {
    NSData *data = [self dataForKey:key];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (void)setDataInUserDefaults:(nullable NSData *)data
                       forKey:(NSString *)key {
    [self.userDefaults setObject:data
                          forKey:key];
}

- (nullable NSData *)dataInUserDefaultsForKey:(NSString *)key {
    return [self.userDefaults dataForKey:key];
}

- (NSData *)objectForKeyedSubscript:(NSString *)key {
    return [self dataForKey:key];
}

- (void)setObject:(NSData *)obj
forKeyedSubscript:(NSString *)key {
    [self setData:obj
           forKey:key];
}

@end