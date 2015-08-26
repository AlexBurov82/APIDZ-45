//
//  ABDetailFriendTVCTableViewController.m
//  APIDZ-45
//
//  Created by Александр on 21.08.15.
//  Copyright (c) 2015 Alex Bukharov. All rights reserved.
//

#import "ABDetailFriendTVC.h"
#import "ABUser.h"
#import "ABServerManager.h"
#import <AFNetworking.h>
#import <UIImageView+AFNetworking.h>
#import "ABSubscriptionsTVC.h"
#import "ABFollowersTVC.h"
#import "ABWallTVC.h"
#import <StaticDataTableViewController.h>

@interface ABDetailFriendTVC ()

@end

@implementation ABDetailFriendTVC 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.labelName.hidden = YES;
    self.bdate.hidden = YES;
    self.city.hidden = YES;
    self.country.hidden = YES;
    self.university.hidden = YES;
    self.schools.hidden = YES;
    self.site.hidden = YES;
    self.online.hidden = YES;
    
    [self getUserFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - API

- (void)getUserFromServer {
    
    [[ABServerManager shareManager] getUserWithUserId:self.userId onSuccess:^(ABUser *user) {
        
        [self outputDetailUserDescription:user];
        
    } onFailure:^(NSError *error, NSInteger statusCode) {
        
         NSLog(@"error = %@, code = %ld", [error localizedDescription], statusCode);
    }];
}

- (void)outputDetailUserDescription:(ABUser *)getUser {
    
    ABUser *user = getUser;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:user.avatar200];
    
    __weak UIImageView *weakImageView = self.avatarImageView;
    
    self.avatarImageView.image = nil;
    
    [self.avatarImageView setImageWithURLRequest:request
                          placeholderImage:nil
                                   success:^(NSURLRequest * request, NSHTTPURLResponse * response, UIImage * image) {
                                       weakImageView.image = image;
                                       [weakImageView layoutSubviews];
                                   } failure:^(NSURLRequest * request, NSHTTPURLResponse * response, NSError * error) {
                                       
                                   }];

    self.labelName.hidden = NO;
    self.country.hidden = NO;
    self.university.hidden = NO;
    self.schools.hidden = NO;
    self.site.hidden = NO;
    self.online.hidden = NO;
    self.labelName.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    
    if (user.bdate) {
        self.bdate.hidden = NO;
        self.bdate.text = [NSString stringWithFormat:@"%@", user.bdate];
    } else {
        [self cellHidden:self.cell1];
    }
    
    if (user.cityName) {
        self.city.hidden = NO;
        self.city.text = [NSString stringWithFormat:@"%@", user.cityName];
    } else {
        [self cellHidden:self.cell2];
    }

    if (user.countryName) {
        self.country.hidden = NO;
        self.country.text = [NSString stringWithFormat:@"%@", user.countryName];
    } else {
        [self cellHidden:self.cell3];
    }
    
    if ([user.schools count] > 0) {
        self.schools.text = [NSString stringWithFormat:@"%@", [[user.schools objectAtIndex:0] valueForKey:@"name"]];
    } else {
        [self cellHidden:self.cell4];
    }

    if ([user.university count] > 0 && ![user.university isEqual:0]) {
        self.university.text = [NSString stringWithFormat:@"%@", [[user.university objectAtIndex:0] valueForKey:@"name"]];
    } else {
        [self cellHidden:self.cell5];
    }
   
    if (![user.site isEqualToString:@""] && user.site != NULL) {
        self.site.hidden = NO;
        self.site.text = [NSString stringWithFormat:@"%@", user.site];
    } else {
        [self cellHidden:self.cell6];
    }
    
    if ([user.online isEqual:@1]) {
        self.online.text = @"Online";
    } else {
        self.online.text = @"Offline";
    }
}

- (void)cellHidden:(UITableViewCell*)cell {
    self.hideSectionsWithHiddenRows = YES;
    [self cell:cell setHidden:YES];
    [self reloadDataAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"SubscriptionsSegue"]) {
        
        ABSubscriptionsTVC *tvc = (ABSubscriptionsTVC *)[segue destinationViewController];
        tvc.userId = self.userId;
    }
    
    if ([[segue identifier] isEqualToString:@"FollowersSegue"]) {
        
        ABFollowersTVC *tvc = (ABFollowersTVC *)[segue destinationViewController];
        tvc.userId = self.userId;
    }
    
    if ([[segue identifier] isEqualToString:@"WallSegue"]) {
        
        ABWallTVC *tvc = (ABWallTVC *)[segue destinationViewController];
        tvc.ownerId = self.userId;
    }
}


@end
