#import "Kiwi.h"
#import "MEInApp.h"

#import "FakeInAppHandler.h"
#import "EMSTimestampProvider.h"
#import "FakeTimeStampProvider.h"
#import "EMSWaiter.h"
#import "EMSWindowProvider.h"
#import "EMSMainWindowProvider.h"
#import "EMSIAMViewControllerProvider.h"
#import "MEDisplayedIAMRepository.h"
#import "FakeInAppTracker.h"
#import "EMSViewControllerProvider.h"

SPEC_BEGIN(MEInAppTests)
        __block MEInApp *iam;

        __block MEInApp *inApp;
        __block FakeInAppTracker *inAppTracker;
        __block XCTestExpectation *displayExpectation;
        __block XCTestExpectation *clickExpectation;
        __block MELogRepository *logRepository;
        __block FakeTimeStampProvider *timestampProvider;
        __block EMSWindowProvider *windowProvider;
        __block NSDate *firstTimestamp;
        __block NSDate *secondTimestamp;
        __block NSDate *thirdTimestamp;
        __block MEDisplayedIAMRepository *displayedIAMRepository;

        beforeEach(^{
            iam = [[MEInApp alloc] init];
            NSDate *renderEndTime = [NSDate dateWithTimeIntervalSince1970:103];
            EMSTimestampProvider *mockTimeStampProvider = [EMSTimestampProvider mock];
            [mockTimeStampProvider stub:@selector(provideTimestamp) andReturn:renderEndTime];


            displayExpectation = [[XCTestExpectation alloc] initWithDescription:@"displayExpectation"];
            clickExpectation = [[XCTestExpectation alloc] initWithDescription:@"clickExpectation"];
            inAppTracker = [[FakeInAppTracker alloc] initWithDisplayExpectation:displayExpectation
                                                               clickExpectation:clickExpectation];
            logRepository = [MELogRepository nullMock];

            firstTimestamp = [NSDate dateWithTimeIntervalSince1970:103];
            secondTimestamp = [firstTimestamp dateByAddingTimeInterval:6];
            thirdTimestamp = [firstTimestamp dateByAddingTimeInterval:12];
            timestampProvider = [[FakeTimeStampProvider alloc] initWithTimestamps:@[firstTimestamp, secondTimestamp, thirdTimestamp]];
            windowProvider = [EMSWindowProvider nullMock];
            EMSViewControllerProvider *viewControllerProvider = [EMSViewControllerProvider mock];
            [viewControllerProvider stub:@selector(provideViewController)
                               andReturn:[[[EMSViewControllerProvider alloc] init] provideViewController]];
            [windowProvider stub:@selector(provideWindow)
                       andReturn:[[[EMSWindowProvider alloc] initWithViewControllerProvider:viewControllerProvider] provideWindow]];
            displayedIAMRepository = [MEDisplayedIAMRepository nullMock];

            inApp = [[MEInApp alloc] initWithWindowProvider:windowProvider
                                         mainWindowProvider:[EMSMainWindowProvider nullMock]
                                          timestampProvider:timestampProvider
                                              logRepository:logRepository
                                     displayedIamRepository:displayedIAMRepository
                                      buttonClickRepository:[MEDisplayedIAMRepository mock]];
            [inApp setInAppTracker:inAppTracker];
        });


        describe(@"initWithWindowProvider:mainWindowProvider:iamViewControllerProvider:iamViewControllerProvider:timestampProvider:logRepository:displayedIamRepository:inAppTracker:", ^{
            it(@"should throw exception when windowProvider is nil", ^{
                @try {
                    [[MEInApp alloc] initWithWindowProvider:nil
                                         mainWindowProvider:[EMSMainWindowProvider mock]
                                          timestampProvider:[EMSTimestampProvider mock]
                                              logRepository:[MELogRepository mock]
                                     displayedIamRepository:[MEDisplayedIAMRepository mock]
                                      buttonClickRepository:[MEDisplayedIAMRepository mock]];
                    fail(@"Expected Exception when windowProvider is nil!");
                } @catch (NSException *exception) {
                    [[exception.reason should] equal:@"Invalid parameter not satisfying: windowProvider"];
                    [[theValue(exception) shouldNot] beNil];
                }
            });

            it(@"should throw exception when mainWindowProvider is nil", ^{
                @try {
                    [[MEInApp alloc] initWithWindowProvider:[EMSWindowProvider mock]
                                         mainWindowProvider:nil
                                          timestampProvider:[EMSTimestampProvider mock]
                                              logRepository:[MELogRepository mock]
                                     displayedIamRepository:[MEDisplayedIAMRepository mock]
                                      buttonClickRepository:[MEDisplayedIAMRepository mock]];
                    fail(@"Expected Exception when mainWindowProvider is nil!");
                } @catch (NSException *exception) {
                    [[exception.reason should] equal:@"Invalid parameter not satisfying: mainWindowProvider"];
                    [[theValue(exception) shouldNot] beNil];
                }
            });

            it(@"should throw exception when timestampProvider is nil", ^{
                @try {
                    [[MEInApp alloc] initWithWindowProvider:[EMSWindowProvider mock]
                                         mainWindowProvider:[EMSMainWindowProvider mock]
                                          timestampProvider:nil
                                              logRepository:[MELogRepository mock]
                                     displayedIamRepository:[MEDisplayedIAMRepository mock]
                                      buttonClickRepository:[MEDisplayedIAMRepository mock]];
                    fail(@"Expected Exception when timestampProvider is nil!");
                } @catch (NSException *exception) {
                    [[exception.reason should] equal:@"Invalid parameter not satisfying: timestampProvider"];
                    [[theValue(exception) shouldNot] beNil];
                }
            });

            it(@"should throw exception when logRepository is nil", ^{
                @try {
                    [[MEInApp alloc] initWithWindowProvider:[EMSWindowProvider mock]
                                         mainWindowProvider:[EMSMainWindowProvider mock]
                                          timestampProvider:[EMSTimestampProvider mock]
                                              logRepository:nil
                                     displayedIamRepository:[MEDisplayedIAMRepository mock]
                                      buttonClickRepository:[MEDisplayedIAMRepository mock]];
                    fail(@"Expected Exception when logRepository is nil!");
                } @catch (NSException *exception) {
                    [[exception.reason should] equal:@"Invalid parameter not satisfying: logRepository"];
                    [[theValue(exception) shouldNot] beNil];
                }
            });

            it(@"should throw exception when displayedIamRepository is nil", ^{
                @try {
                    [[MEInApp alloc] initWithWindowProvider:[EMSWindowProvider mock]
                                         mainWindowProvider:[EMSMainWindowProvider mock]
                                          timestampProvider:[EMSTimestampProvider mock]
                                              logRepository:[MELogRepository mock]
                                     displayedIamRepository:nil
                                      buttonClickRepository:[MEDisplayedIAMRepository mock]];
                    fail(@"Expected Exception when displayedIamRepository is nil!");
                } @catch (NSException *exception) {
                    [[exception.reason should] equal:@"Invalid parameter not satisfying: displayedIamRepository"];
                    [[theValue(exception) shouldNot] beNil];
                }
            });

            it(@"should throw exception when buttonClickRepository is nil", ^{
                @try {
                    [[MEInApp alloc] initWithWindowProvider:[EMSWindowProvider mock]
                                         mainWindowProvider:[EMSMainWindowProvider mock]
                                          timestampProvider:[EMSTimestampProvider mock]
                                              logRepository:[MELogRepository mock]
                                     displayedIamRepository:[MEDisplayedIAMRepository mock]
                                      buttonClickRepository:nil];
                    fail(@"Expected Exception when buttonClickRepository is nil!");
                } @catch (NSException *exception) {
                    [[exception.reason should] equal:@"Invalid parameter not satisfying: buttonClickRepository"];
                    [[theValue(exception) shouldNot] beNil];
                }
            });
        });

        describe(@"showMessage:completionHandler:", ^{

            it(@"it should set currentCampaignId", ^{
                NSData *body = [NSJSONSerialization dataWithJSONObject:@{@"message": @{@"id": @"testIdForCurrentCampaignId", @"html": @"<html></html>"}}
                                                               options:0
                                                                 error:nil];
                EMSResponseModel *response = [[EMSResponseModel alloc] initWithStatusCode:200
                                                                                  headers:@{}
                                                                                     body:body
                                                                             requestModel:[EMSRequestModel nullMock]
                                                                                timestamp:[NSDate date]];
                XCTestExpectation *exp = [[XCTestExpectation alloc] initWithDescription:@"waitForResult"];
                [inApp showMessage:[[MEInAppMessage alloc] initWithResponse:response]
                 completionHandler:^{
                     [exp fulfill];
                 }];
                [EMSWaiter waitForExpectations:@[exp] timeout:10];
                [[[((id <MEIAMProtocol>) inApp) currentCampaignId] should] equal:@"testIdForCurrentCampaignId"];
            });

            it(@"should call trackInAppDisplay: on inAppTracker", ^{
                NSData *body = [NSJSONSerialization dataWithJSONObject:@{@"message": @{@"id": @"testIdForInAppTracker", @"html": @"<html></html>"}}
                                                               options:0
                                                                 error:nil];
                EMSResponseModel *response = [[EMSResponseModel alloc] initWithStatusCode:200
                                                                                  headers:@{}
                                                                                     body:body
                                                                             requestModel:[EMSRequestModel nullMock]
                                                                                timestamp:[NSDate date]];

                XCTestExpectation *exp = [[XCTestExpectation alloc] initWithDescription:@"waitForResult"];

                [inApp showMessage:[[MEInAppMessage alloc] initWithResponse:response]
                 completionHandler:^{
                     [exp fulfill];
                 }];

                XCTWaiterResult waiterResult = [XCTWaiter waitForExpectations:@[exp, displayExpectation]
                                                                      timeout:10
                                                                 enforceOrder:YES];

                [[theValue(waiterResult) should] equal:theValue(XCTWaiterResultCompleted)];
                [[inAppTracker.campaignId should] equal:@"testIdForInAppTracker"];
            });

            it(@"should call add on displayedInAppRepository", ^{
                [[displayedIAMRepository should] receive:@selector(add:)
                                           withArguments:[[MEDisplayedIAM alloc] initWithCampaignId:@"testIdForInAppTracker"
                                                                                          timestamp:thirdTimestamp]];

                NSData *body = [NSJSONSerialization dataWithJSONObject:@{@"message": @{@"id": @"testIdForInAppTracker", @"html": @"<html></html>"}}
                                                               options:0
                                                                 error:nil];
                EMSResponseModel *response = [[EMSResponseModel alloc] initWithStatusCode:200
                                                                                  headers:@{}
                                                                                     body:body
                                                                             requestModel:[EMSRequestModel nullMock]
                                                                                timestamp:[NSDate date]];

                XCTestExpectation *exp = [[XCTestExpectation alloc] initWithDescription:@"waitForResult"];

                [inApp showMessage:[[MEInAppMessage alloc] initWithResponse:response]
                 completionHandler:^{
                     [exp fulfill];
                 }];

                [EMSWaiter waitForExpectations:@[exp, displayExpectation]
                                       timeout:10];
            });

            it(@"should log the rendering time", ^{
                NSString *const campaignId = @"testIdForRenderingMetric";

                NSDictionary *loadingTimeMetric = @{@"loading_time": @3000, @"id": campaignId};

                [[logRepository should] receive:@selector(add:) withArguments:loadingTimeMetric];

                NSData *body = [NSJSONSerialization dataWithJSONObject:@{@"message": @{@"id": campaignId, @"html": @"<html></html>"}}
                                                               options:0
                                                                 error:nil];
                EMSResponseModel *response = [[EMSResponseModel alloc] initWithStatusCode:200
                                                                                  headers:@{}
                                                                                     body:body
                                                                             requestModel:[EMSRequestModel nullMock]
                                                                                timestamp:[NSDate dateWithTimeIntervalSince1970:100]];

                XCTestExpectation *exp = [[XCTestExpectation alloc] initWithDescription:@"waitForResult"];
                [inApp showMessage:[[MEInAppMessage alloc] initWithResponse:response]
                 completionHandler:^{
                     [exp fulfill];
                 }];
                [EMSWaiter waitForExpectations:@[exp]
                                       timeout:10];
            });

            it(@"should not log the rendering time when responseModel is nil", ^{
                NSString *const campaignId = @"testIdForRenderingMetric";

                [[logRepository shouldNot] receive:@selector(add:)];

                XCTestExpectation *exp = [[XCTestExpectation alloc] initWithDescription:@"waitForResult"];
                [inApp showMessage:[[MEInAppMessage alloc] initWithCampaignId:campaignId
                                                                         html:@"<html></html>"]
                 completionHandler:^{
                     [exp fulfill];
                 }];
                [EMSWaiter waitForExpectations:@[exp]
                                       timeout:10];
            });

            it(@"should use windowProvider to create iamWindow", ^{
                [[windowProvider should] receive:@selector(provideWindow)];

                XCTestExpectation *exp = [[XCTestExpectation alloc] initWithDescription:@"waitForResult"];
                [inApp showMessage:[[MEInAppMessage alloc] initWithCampaignId:@"testCampaignId"
                                                                         html:@"<html></html>"]
                 completionHandler:^{
                     [exp fulfill];
                 }];
                [EMSWaiter waitForExpectations:@[exp]
                                       timeout:10];
            });

        });

        describe(@"eventHandler", ^{
            it(@"should pass the eventName and payload to the given eventHandler's handleEvent:payload: method", ^{
                NSString *expectedName = @"nameOfTheEvent";
                NSDictionary <NSString *, NSObject *> *expectedPayload = @{
                    @"payloadKey1": @{
                        @"payloadKey2": @"payloadValue"
                    }
                };

                XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"expectation"];
                __block NSString *returnedEventName;
                __block NSDictionary<NSString *, NSObject *> *returnedPayload;

                FakeInAppHandler *inAppHandler = [[FakeInAppHandler alloc] initWithHandlerBlock:^(NSString *eventName, NSDictionary<NSString *, NSObject *> *payload) {
                    returnedEventName = eventName;
                    returnedPayload = payload;
                    [expectation fulfill];
                }];
                [inApp setEventHandler:inAppHandler];

                NSString *message = @"<!DOCTYPE html>\n"
                                    "<html lang=\"en\">\n"
                                    "  <head>\n"
                                    "    <script>\n"
                                    "      window.onload = function() {\n"
                                    "        window.webkit.messageHandlers.triggerAppEvent.postMessage({id: '1', name: 'nameOfTheEvent', payload:{payloadKey1:{payloadKey2: 'payloadValue'}}});\n"
                                    "      };\n"
                                    "    </script>\n"
                                    "  </head>\n"
                                    "  <body style=\"background: transparent;\">\n"
                                    "  </body>\n"
                                    "</html>";
                NSData *body = [NSJSONSerialization dataWithJSONObject:@{@"message": @{@"id": @"campaignId", @"html": message}}
                                                               options:0
                                                                 error:nil];
                EMSResponseModel *response = [[EMSResponseModel alloc] initWithStatusCode:200
                                                                                  headers:@{}
                                                                                     body:body
                                                                             requestModel:[EMSRequestModel nullMock]
                                                                                timestamp:[NSDate date]];
                [inApp showMessage:[[MEInAppMessage alloc] initWithResponse:response]
                 completionHandler:^{
                 }];

                [XCTWaiter waitForExpectations:@[expectation] timeout:2];

                [[returnedEventName should] equal:expectedName];
                [[returnedPayload should] equal:expectedPayload];
            });

            it(@"should not try to display inapp in case if there is already one being displayed", ^{
                NSString *expectedName = @"nameOfTheEvent";
                NSDictionary <NSString *, NSObject *> *expectedPayload = @{
                    @"payloadKey1": @{
                        @"payloadKey2": @"payloadValue"
                    }
                };

                FakeInAppHandler *inAppHandler = [FakeInAppHandler mock];
                [iam setEventHandler:inAppHandler];
                NSString *message = @"<!DOCTYPE html>\n"
                                    "<html lang=\"en\">\n"
                                    "  <head>\n"
                                    "    <script>\n"
                                    "      window.onload = function() {\n"
                                    "        window.webkit.messageHandlers.triggerAppEvent.postMessage({id: '1', name: 'nameOfTheEvent', payload:{payloadKey1:{payloadKey2: 'payloadValue'}}});\n"
                                    "      };\n"
                                    "    </script>\n"
                                    "  </head>\n"
                                    "  <body style=\"background: transparent;\">\n"
                                    "  </body>\n"
                                    "</html>";
                [[inAppHandler shouldEventually] receive:@selector(handleEvent:payload:)
                                         withCountAtMost:1
                                               arguments:expectedName,
                                                         expectedPayload];

                NSData *body = [NSJSONSerialization dataWithJSONObject:@{@"message": @{@"id": @"campaignId", @"html": message}}
                                                               options:0
                                                                 error:nil];
                EMSResponseModel *response = [[EMSResponseModel alloc] initWithStatusCode:200
                                                                                  headers:@{}
                                                                                     body:body
                                                                             requestModel:[EMSRequestModel nullMock]
                                                                                timestamp:[NSDate date]];
                XCTestExpectation *exp = [[XCTestExpectation alloc] initWithDescription:@"waitForResult"];
                [iam showMessage:[[MEInAppMessage alloc] initWithResponse:response]
               completionHandler:^{
                   [iam showMessage:[[MEInAppMessage alloc] initWithResponse:response]
                  completionHandler:^{
                      [exp fulfill];
                  }];
               }];
                [EMSWaiter waitForExpectations:@[exp] timeout:3];
            });

        });

        describe(@"MEIAMViewController", ^{
            it(@"should log the on screen time", ^{
                NSString *const campaignId = @"testIdForOnScreenMetric";

                NSDictionary *loadingTimeMetric = @{@"on_screen_time": @6000, @"id": campaignId};
                [[logRepository should] receive:@selector(add:) withArguments:loadingTimeMetric];

                NSData *body = [NSJSONSerialization dataWithJSONObject:@{@"message": @{@"id": campaignId, @"html": @"<html></html>"}}
                                                               options:0
                                                                 error:nil];
                EMSResponseModel *response = [[EMSResponseModel alloc] initWithStatusCode:200
                                                                                  headers:@{}
                                                                                     body:body
                                                                             requestModel:[EMSRequestModel nullMock]
                                                                                timestamp:[NSDate dateWithTimeIntervalSince1970:100]];

                XCTestExpectation *expForRendering = [[XCTestExpectation alloc] initWithDescription:@"waitForResult"];
                [inApp showMessage:[[MEInAppMessage alloc] initWithResponse:response]
                 completionHandler:^{
                     [expForRendering fulfill];
                 }];
                [EMSWaiter waitForExpectations:@[expForRendering] timeout:5];

                XCTestExpectation *expForClosing = [[XCTestExpectation alloc] initWithDescription:@"waitForResult"];
                [inApp closeInAppMessageWithCompletionBlock:^{
                    [expForClosing fulfill];
                }];
                [EMSWaiter waitForExpectations:@[expForClosing] timeout:5];
            });
        });

        describe(@"closeInAppMessageWithCompletionBlock:", ^{

            it(@"should close the inapp message", ^{
                UIViewController *rootViewControllerMock = [UIViewController nullMock];
                [[rootViewControllerMock should] receive:@selector(dismissViewControllerAnimated:completion:)];
                KWCaptureSpy *spy = [rootViewControllerMock captureArgument:@selector(dismissViewControllerAnimated:completion:)
                                                                    atIndex:1];

                UIWindow *window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
                window.rootViewController = rootViewControllerMock;

                iam.iamWindow = window;

                [((id <MEIAMProtocol>) iam) closeInAppMessageWithCompletionBlock:nil];

                void (^completionBlock)(void) = spy.argument;
                completionBlock();
                [[iam.iamWindow should] beNil];
            });

        });

SPEC_END
