//
//  ABUser.h
//  APIDZ-45
//
//  Created by Александр on 21.08.15.
//  Copyright (c) 2015 Alex Bukharov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABUser : NSObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *bdate;
@property (strong, nonatomic) NSNumber *city;
@property (strong, nonatomic) NSString *cityName;
@property (assign, nonatomic) NSNumber *country;
@property (strong, nonatomic) NSString *countryName;
@property (strong, nonatomic) NSArray *university;
@property (strong, nonatomic) NSArray *schools;
@property (strong, nonatomic) NSString *site;
@property (strong, nonatomic) NSNumber *online;
@property (strong, nonatomic) NSURL *avatar50;
@property (strong, nonatomic) NSURL *avatar200;

@property (strong, nonatomic) NSString *nameSubscriptions;


- (id)initWithServerResponse:(NSDictionary *)responseObject;

@end

