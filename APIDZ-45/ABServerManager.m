//
//  ABServerManager.m
//  APIDZ-45
//
//  Created by Александр on 21.08.15.
//  Copyright (c) 2015 Alex Bukharov. All rights reserved.
//

#import "ABServerManager.h"
#import <AFNetworking.h>
#import "ABUser.h"
#import "ABWall.h"

@interface ABServerManager ()

@property (strong, nonatomic) AFHTTPRequestOperationManager *requestOperationManage;


@property (strong, nonatomic) NSMutableDictionary *dict;

@end

@implementation ABServerManager

+ (ABServerManager *)shareManager {
    
    static ABServerManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ABServerManager alloc] init];
    });
    return manager;
}

- (id) init {
    self = [super init];
    if (self) {
        
        NSURL *url = [NSURL URLWithString:@"https://api.vk.com/method/"];
        
        self.requestOperationManage = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    }
    return  self;
}

- (void)getFriendsWithOffset:(NSInteger)offset
                       count:(NSInteger)count
                   onSuccess:(void (^)(NSArray *friends))success
                   onFailure:(void (^)(NSError *error, NSInteger statusCode))failure {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"26955116", @"user_id",
                            @"name",     @"order",
                            @(count),    @"count",
                            @(offset),   @"offset",
                            @"photo_50", @"fields",
                            @"nom",      @"name_case", nil];
    
    [self.requestOperationManage GET:@"friends.get"
                          parameters:params
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 
                                 NSArray *dictionaryArray = [responseObject objectForKey:@"response"];
                                 
                                 NSMutableArray *objectArray = [NSMutableArray array];
                                 
                                 for (NSDictionary *dic in dictionaryArray) {
                                     ABUser *user = [[ABUser alloc] initWithServerResponse:dic];
                                     [objectArray addObject:user];
                                 }
                                 
                                 if (success) {
                                     success(objectArray);
                                 }
                                 
                             } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
                                 
                                 if (failure) {
                                     failure(error, operation.response.statusCode);
                                 }
                             }];
}

- (void)getUserWithUserId:(NSString *)userId
                onSuccess:(void(^)(ABUser *user))success
                onFailure:(void(^)(NSError *error, NSInteger statusCode))failure {
    
    __block ABUser *user = nil;
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            userId,      @"user_id",
                            @"name",     @"order",
                            @"sex, bdate, city, country, photo_200, online, site, universities, schools",   @"fields",
                            @"nom",      @"name_case", nil];
    
    [self.requestOperationManage GET:@"users.get"
                          parameters:params
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 
                                 NSArray *array = [responseObject objectForKey:@"response"];
                                 
                                 user = [[ABUser alloc]initWithServerResponse:[array firstObject]];
                                 
                                 [self getCitiesById:user.city onSuccess:^(NSString *cityName) {
                                     user.cityName = cityName;
                                     
                                     [self getCountriesById:user.country onSuccess:^(NSString *countryName) {
                                         user.countryName = countryName;
                                         dispatch_group_leave(group);
                                         
                                     } onFailure:^(NSError *error, NSInteger statusCode) {
                                         NSLog(@"error = %@, code = %ld", [error localizedDescription], statusCode);
                                     }];
                                     
                                 } onFailure:^(NSError *error, NSInteger statusCode) {
                                     NSLog(@"error = %@, code = %ld", [error localizedDescription], statusCode);
                                 }];
                                 
                             } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
                                 
                                 if (failure) {
                                     failure(error, operation.response.statusCode);
                                 }
                             }];
    
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        success(user);
    });
}

- (void)getCountriesById:(NSNumber*)country_ids
                     onSuccess:(void(^)(NSString *countryName))success
                     onFailure:(void(^)(NSError *error, NSInteger statusCode))failure {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: country_ids, @"country_ids", nil];
    
    
    [self.requestOperationManage GET:@"database.getCountriesById"
                          parameters:params
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 
                                 NSArray *array = [responseObject objectForKey:@"response"];
                                 
                                 NSString *countryName = [[array firstObject] valueForKey:@"name"];
                                 
                                 if (success) {
                                     success(countryName);
                                 }
                                 
                             } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
                                 
                                 if (failure) {
                                     failure(error, operation.response.statusCode);
                                 }
                             }];
}

- (void)getCitiesById:(NSNumber*)city_ids
               onSuccess:(void(^)(NSString *cityName))success
               onFailure:(void(^)(NSError *error, NSInteger statusCode))failure {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: city_ids, @"city_ids", nil];
    
    [self.requestOperationManage GET:@"database.getCitiesById"
                          parameters:params
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 
                                 NSArray *array = [responseObject objectForKey:@"response"];
                                 
                                 NSString *cityName = [[array firstObject] valueForKey:@"name"];
                                 
                                 if (success) {
                                     success(cityName);
                                 }
                                 
                             } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
                                 
                                 if (failure) {
                                     failure(error, operation.response.statusCode);
                                 }
                             }];
}


- (void)getSubscriptionsWithUserId:(NSString *)userId
                            offset:(NSInteger)offset
                             count:(NSInteger)count
                         onSuccess:(void (^)(NSArray *subscriptions))success
                         onFailure:(void (^)(NSError *error, NSInteger statusCode))failure {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            userId,      @"user_id",
                            @1,          @"extended",
                            @(count),    @"count",
                            @(offset),   @"offset",
                            @"photo_50", @"fields", nil];
    
    [self.requestOperationManage GET:@"users.getSubscriptions"
                          parameters:params
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 
                                 NSArray *dictionaryArray = [responseObject objectForKey:@"response"];
                                 
                                 NSMutableArray *objectArray = [NSMutableArray array];
                                 
                                 for (NSDictionary *dic in dictionaryArray) {
                                     ABUser *user = [[ABUser alloc] initWithServerResponse:dic];
                                     [objectArray addObject:user];
                                 }
                                 
                                 if (success) {
                                     success(objectArray);
                                 }
                                 
                             } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
                                 
                                 if (failure) {
                                     failure(error, operation.response.statusCode);
                                 }
                             }];
}

- (void)getFollowersWithUserId:(NSString *)userId
                        offset:(NSInteger)offset
                         count:(NSInteger)count
                     onSuccess:(void (^)(NSArray *followers))success
                     onFailure:(void (^)(NSError *error, NSInteger statusCode))failure {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            userId,      @"user_id",
                            @(count),    @"count",
                            @(offset),   @"offset",
                            @"photo_50", @"fields",
                            @"nom",      @"name_case", nil];
    
    [self.requestOperationManage GET:@"users.getFollowers"
                          parameters:params
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 
                                // NSLog(@"JSON1: %@", responseObject);
                                 
                                 NSDictionary *dictionary = [responseObject objectForKey:@"response"];
                                 
                                 NSArray *dictionaryArray = [dictionary objectForKey:@"items"];
                                 
                                 NSMutableArray *objectArray = [NSMutableArray array];
                                 
                                 for (NSDictionary *dic in dictionaryArray) {
                                     ABUser *user = [[ABUser alloc] initWithServerResponse:dic];
                                     [objectArray addObject:user];
                                 }
                                 
                                 if (success) {
                                     success(objectArray);
                                 }
                                 
                             } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
                                 
                                 if (failure) {
                                     failure(error, operation.response.statusCode);
                                 }
                             }];
}

- (void)getWallWithUserId:(NSString *)ownerId
                        offset:(NSInteger)offset
                         count:(NSInteger)count
                     onSuccess:(void (^)(NSArray *wall))success
                     onFailure:(void (^)(NSError *error, NSInteger statusCode))failure {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            ownerId,     @"owner_id",
                            @(count),    @"count",
                            @(offset),   @"offset",
                            @"all",      @"filter", nil];
    
    [self.requestOperationManage GET:@"wall.get"
                          parameters:params
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 
                                 NSLog(@"JSON1: %@", responseObject);
                                 
                                 NSArray *array = [responseObject objectForKey:@"response"];
                                 
                                 NSMutableArray *objectArray = [NSMutableArray array];
                            
                                 for (int i = 1; i < [array count]; i++) {
                                     ABWall *wall = [[ABWall alloc] initWithServerResponse:[array objectAtIndex:i]];
                                     [objectArray addObject:wall];
                                 }
                                
                                 if (success) {
                                     success(objectArray);
                                 }
                                 
                             } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
                                 
                                 if (failure) {
                                     failure(error, operation.response.statusCode);
                                 }
                             }];
}


@end
