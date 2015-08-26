//
//  ABServerManager.h
//  APIDZ-45
//
//  Created by Александр on 21.08.15.
//  Copyright (c) 2015 Alex Bukharov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ABUser;

@interface ABServerManager : NSObject

+ (ABServerManager *)shareManager;

- (void)getFriendsWithOffset:(NSInteger)offset
                       count:(NSInteger)count
                   onSuccess:(void(^)(NSArray *friends))success
                   onFailure:(void(^)(NSError *error, NSInteger statusCode))failure;

- (void)getUserWithUserId:(NSString *)userId
                onSuccess:(void(^)(ABUser *user))success
                onFailure:(void(^)(NSError *error, NSInteger statusCode))failure;

- (void)getSubscriptionsWithUserId:(NSString *)userId
                            offset:(NSInteger)offset
                             count:(NSInteger)count
                         onSuccess:(void (^)(NSArray *))success
                         onFailure:(void (^)(NSError *, NSInteger))failure;

- (void)getFollowersWithUserId:(NSString *)userId
                        offset:(NSInteger)offset
                         count:(NSInteger)count
                     onSuccess:(void (^)(NSArray *followers))success
                     onFailure:(void (^)(NSError *error, NSInteger statusCode))failure;

- (void)getWallWithUserId:(NSString *)ownerId
                   offset:(NSInteger)offset
                    count:(NSInteger)count
                onSuccess:(void (^)(NSArray *followers))success
                onFailure:(void (^)(NSError *error, NSInteger statusCode))failure;

@end
