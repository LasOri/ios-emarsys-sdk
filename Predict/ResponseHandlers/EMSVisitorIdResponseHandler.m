//
// Copyright (c) 2018 Emarsys. All rights reserved.
//
#import "EMSVisitorIdResponseHandler.h"

#define COOKIE_KEY_CDV @"cdv"

@implementation EMSVisitorIdResponseHandler

- (instancetype)initWithRequestContext:(PRERequestContext *)requestContext {
    NSParameterAssert(requestContext);
    if (self = [super init]) {
        _requestContext = requestContext;
    }
    return self;
}

- (BOOL)shouldHandleResponse:(EMSResponseModel *)response {
    return response.cookies[COOKIE_KEY_CDV] != nil;
}

- (void)handleResponse:(EMSResponseModel *)response {
    [self.requestContext setVisitorId:response.cookies[COOKIE_KEY_CDV].value];
}


@end