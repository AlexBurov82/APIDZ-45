//
//  ABWall.h
//  APIDZ-45
//
//  Created by Александр on 24.08.15.
//  Copyright (c) 2015 Alex Bukharov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABWall : NSObject

@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *text;
@property (assign, nonatomic) NSInteger likesCount;
@property (strong, nonatomic) NSURL *photo;

- (id)initWithServerResponse:(NSDictionary *)responseObject;

@end
