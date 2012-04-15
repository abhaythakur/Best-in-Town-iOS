//
//  BiTApiController.h
//  BestInTown
//
//  Created by Justin Marrington on 14/04/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kApiBase @"http://bestintown.co/"
#define kBrisbaneCityId @"1213";

@class AFHTTPRequestOperation;
@interface BiTApiController : NSObject

+ (BiTApiController *)sharedApi;

- (void)getCategoriesOnSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success 
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)getBusinessListForCategory:(NSString *)categoryId 
                            inCity:(NSString *)cityId
                         onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success 
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)getExploreForCity:(NSString *)cityId 
                    atLat:(double)lat 
                      lon:(double)lon 
                   radius:(int)radius 
                onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success 
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
