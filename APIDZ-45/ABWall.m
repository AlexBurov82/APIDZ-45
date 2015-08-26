//
//  ABWall.m
//  APIDZ-45
//
//  Created by Александр on 24.08.15.
//  Copyright (c) 2015 Alex Bukharov. All rights reserved.
//

#import "ABWall.h"

@implementation ABWall

- (id)initWithServerResponse:(NSDictionary *)responseObject {
    
    self = [super init];
    if (self) {
        
        NSTimeInterval unixtime = [[responseObject objectForKey:@"date"] doubleValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:unixtime];
        
        NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"dd.MM.yyyy"];
        
        self.date = [formatter stringFromDate:date];
        
        NSString* string = [responseObject objectForKey:@"text"];
        
        self.text = [string stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
        
        NSDictionary *likes = [responseObject objectForKey:@"likes"];
        
        self.likesCount = [[likes objectForKey:@"count"] integerValue];
        
        NSDictionary *attachment = [responseObject objectForKey:@"attachment"];
        
        NSDictionary *photo = [attachment objectForKey:@"photo"];
        
        NSString *src = [photo objectForKey:@"src"];
        
        NSDictionary *video = [attachment objectForKey:@"video"];
        
        NSString *image = [video objectForKey:@"image"];
        
        if (src) {
            self.photo = [NSURL URLWithString:src];
        } else if (image) {
            self.photo = [NSURL URLWithString:image];
        }
    }
    return self;
}

@end
