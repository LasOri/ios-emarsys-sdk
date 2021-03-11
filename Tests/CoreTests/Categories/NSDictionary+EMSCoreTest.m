//
//  Copyright © 2021 Emarsys. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSDictionary+EMSCore.h"

@interface NSDictionary_EMSCoreTest : XCTestCase

@end

@implementation NSDictionary_EMSCoreTest

- (void)setUp {
}

- (void)tearDown {
}

- (void)testDictionaryWithAllowedTypes {
    NSDate *date = [NSDate date];

    NSDictionary *original = @{
            @"key1": @"value1",
            @"key2": date
    };

    NSDictionary *expected = @{
            @"key1": @"value1",
            @"key2": [date description]
    };

    NSDictionary *result = [original dictionaryWithAllowedTypes:[NSSet setWithArray:@[[NSString class]]]];

    XCTAssertEqualObjects(result, expected);
}

- (void)testDictionaryWithAllowedTypes_whenDictionaryContainsDictionary {
    NSDate *date = [NSDate date];

    NSDictionary *original = @{
            @"key1": @"value1",
            @"key2": @{
                    @"key3": date,
                    @"key4": @"value4"
            }
    };

    NSDictionary *expected = @{
            @"key1": @"value1",
            @"key2": @{
                    @"key3": [date description],
                    @"key4": @"value4"
            }
    };

    NSDictionary *result = [original dictionaryWithAllowedTypes:[NSSet setWithArray:@[[NSString class], [NSDictionary class]]]];

    XCTAssertEqualObjects(result, expected);
}

- (void)testDictionaryWithAllowedTypes_whenDictionaryContainsArray {
    NSDate *date = [NSDate date];

    NSDictionary *original = @{
            @"key1": @"value1",
            @"key2": @[
                    date,
                    @"value4"
            ]
    };

    NSDictionary *expected = @{
            @"key1": @"value1",
            @"key2": @[
                    [date description],
                    @"value4"
            ]
    };

    NSDictionary *result = [original dictionaryWithAllowedTypes:[NSSet setWithArray:@[[NSString class], [NSDictionary class], [NSArray class]]]];

    XCTAssertEqualObjects(result, expected);
}

- (void)testDictionaryWithAllowedTypes_whenArrayContainsArray {
    NSDate *date = [NSDate date];

    NSDictionary *original = @{
            @"key1": @"value1",
            @"key2": @[
                    @[date],
                    @"value4"
            ]
    };

    NSDictionary *expected = @{
            @"key1": @"value1",
            @"key2": @[
                    @[[date description]],
                    @"value4"
            ]
    };

    NSDictionary *result = [original dictionaryWithAllowedTypes:[NSSet setWithArray:@[[NSString class], [NSDictionary class], [NSArray class]]]];

    XCTAssertEqualObjects(result, expected);
}

- (void)testDictionaryWithAllowedTypes_whenArrayContainsDictionary {
    NSDate *date = [NSDate date];

    NSDictionary *original = @{
            @"key1": @"value1",
            @"key2": @[
                    @{
                            @"key3": date
                    },
                    @"value4"
            ]
    };

    NSDictionary *expected = @{
            @"key1": @"value1",
            @"key2": @[
                    @{
                            @"key3": [date description]
                    },
                    @"value4"
            ]
    };

    NSDictionary *result = [original dictionaryWithAllowedTypes:[NSSet setWithArray:@[[NSString class], [NSDictionary class], [NSArray class]]]];

    XCTAssertEqualObjects(result, expected);
}

@end
