//
//  AbstractService.h
//  NetworkLayerStubbingSample
//
//  Created by Omkar khedekar on 27/03/19.
//  Copyright © 2019 Omkar khedekar. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CompletionHandler)(NSData * _Nullable data, NSError * _Nullable error);

NS_ASSUME_NONNULL_BEGIN

@interface AbstractService : NSObject
@property (nonatomic, copy, nonnull) NSURL * url;
@property (nonatomic, copy, nonnull) NSString *operationCode;
@property (nonatomic, copy, nonnull) NSString *method;
@property (nonatomic, copy, nullable) NSDictionary *params;

-(void) executeWithCompletionHandler:(CompletionHandler) handler;

@end

NS_ASSUME_NONNULL_END
