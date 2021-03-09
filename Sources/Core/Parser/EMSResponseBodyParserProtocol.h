//
// Copyright (c) 2021 Emarsys. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EMSRequestModel;

@protocol EMSResponseBodyParserProtocol <NSObject>

- (BOOL)shouldParse:(EMSRequestModel *)requestModel;

- (id)parseWithRequestModel:(EMSRequestModel *)requestModel
               responseBody:(NSData *)responseBody;

@end
