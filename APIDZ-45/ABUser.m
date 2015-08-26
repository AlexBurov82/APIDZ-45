//
//  ABUser.m
//  APIDZ-45
//
//  Created by Александр on 21.08.15.
//  Copyright (c) 2015 Alex Bukharov. All rights reserved.
//

#import "ABUser.h"

@implementation ABUser

- (id)initWithServerResponse:(NSDictionary *)responseObject {
    
    self = [super init];
    if (self) {
        self.firstName = [responseObject objectForKey:@"first_name"];
        self.lastName = [responseObject objectForKey:@"last_name"];
        self.bdate = [responseObject objectForKey:@"bdate"];
        self.userId = [responseObject objectForKey:@"user_id"];
        self.city = [responseObject objectForKey:@"city"];
        self.cityName = [responseObject objectForKey:@"cityName"];
        self.country = [responseObject objectForKey:@"country"];
        self.countryName = [responseObject objectForKey:@"countryName"];
        self.university = [responseObject objectForKey:@"universities"];
        self.schools = [responseObject objectForKey:@"schools"];
        self.site = [responseObject objectForKey:@"site"];
        self.online = [responseObject objectForKey:@"online"];
        
        self.nameSubscriptions = [responseObject objectForKey:@"name"];
        
        NSString *urlString50 = [responseObject objectForKey:@"photo_50"];
        NSString *urlString200 = [responseObject objectForKey:@"photo_200"];
        
        if (urlString50) {
            self.avatar50 = [NSURL URLWithString:urlString50];
        }
        if (urlString200) {
            self.avatar200 = [NSURL URLWithString:urlString200];
        }
    }
    return self;
}

@end

