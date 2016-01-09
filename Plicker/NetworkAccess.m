//
//  NetworkAccess.m
//  Plicker
//
//  Created by Justin Lee on 1/8/16.
//  Copyright © 2016 Justin Lee. All rights reserved.
//

#import "NetworkAccess.h"

@interface NetworkAccess()

@end

@implementation NetworkAccess

+ (void) accessServer:(NSString *)payload success:(void (^)(NSURLSessionTask *task, NSArray * responseObject))success failure:(void (^)(NSURLSessionTask *operation, NSError *error))failure
{
	NSString *urlString = payload;
	AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
	manager.responseSerializer = [AFJSONResponseSerializer serializer];
	manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
	[manager GET:urlString parameters:nil progress:nil success:success failure:failure];
}



@end