//
//  AbstractService.m
//  NetworkLayerStubbingSample
//
//  Created by Omkar khedekar on 27/03/19.
//  Copyright © 2019 Omkar khedekar. All rights reserved.
//

#import "AbstractService.h"
#import <objc/runtime.h>
#define STUBB

@implementation AbstractService

-(NSString *) method {
    if (_method == nil) {
        _method = @"GET";
    }

    return _method;
}


-(void) executeWithCompletionHandler:(CompletionHandler) handler {

    NSURLRequest *request = [self prepareRequest];

    NSURLSession *session = [NSURLSession sharedSession];

    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
               completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                   handler(data, error);
               }];

    [task resume];
}


-(NSURLRequest *) prepareRequest {

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:self.url];
    request.HTTPMethod = self.method.capitalizedString;
    NSURLComponents *componants = [[NSURLComponents alloc] initWithURL:self.url
                                               resolvingAgainstBaseURL:NO];

    if ([request.HTTPMethod isEqualToString:@"GET"]) {
        componants.queryItems = [self prepareQuery];
    }

    return request;
}

-(NSArray<NSURLQueryItem *> *) prepareQuery {
    NSMutableArray<NSURLQueryItem *> *items = [NSMutableArray array];
    [self.params enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop) {
        NSLog(@"%@ = %@", key, object);
        NSString *_key = [NSString stringWithFormat:@"%@", key];
        NSString *value = [NSString stringWithFormat:@"%@", object];
        [items addObject:[NSURLQueryItem queryItemWithName: _key
                                                     value:value]];
    }];
    return items;
}

#ifdef STUBB
    // refer: https://nshipster.com/method-swizzling/
+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];

        SEL originalSelector = @selector(executeWithCompletionHandler:);
        SEL swizzledSelector = @selector(stubbedExecuteWithCompletionHandler:);

        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));

        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

-(void) stubbedExecuteWithCompletionHandler:(CompletionHandler) handler {

    NSString *className = NSStringFromClass([self class]);
    NSLog(@"%@", className);
    NSURL *stubFilePath = [[NSBundle mainBundle] URLForResource:className
                                                  withExtension:@"json"];
    NSData *data = [NSData dataWithContentsOfURL:stubFilePath];

    if (data) {
        handler(data, nil);
    } else {
        handler(nil, [NSError errorWithDomain:@"YourDomain"
                                         code:@"YourCode".integerValue
                                     userInfo:nil]);
    }
}

#endif

@end
