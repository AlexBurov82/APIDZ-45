//
//  ABDetailFriendTVCTableViewController.h
//  APIDZ-45
//
//  Created by Александр on 21.08.15.
//  Copyright (c) 2015 Alex Bukharov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StaticDataTableViewController.h>


@interface ABDetailFriendTVC : StaticDataTableViewController

@property (strong, nonatomic) NSString *userId;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (weak, nonatomic) IBOutlet UILabel *labelName;

@property (weak, nonatomic) IBOutlet UILabel *bdate;

@property (weak, nonatomic) IBOutlet UILabel *city;

@property (weak, nonatomic) IBOutlet UILabel *country;

@property (weak, nonatomic) IBOutlet UILabel *university;

@property (weak, nonatomic) IBOutlet UILabel *schools;

@property (weak, nonatomic) IBOutlet UILabel *site;

@property (weak, nonatomic) IBOutlet UILabel *online;


@property (weak, nonatomic) IBOutlet UITableViewCell *cell1;
@property (weak, nonatomic) IBOutlet UITableViewCell *cell2;
@property (weak, nonatomic) IBOutlet UITableViewCell *cell3;
@property (weak, nonatomic) IBOutlet UITableViewCell *cell4;
@property (weak, nonatomic) IBOutlet UITableViewCell *cell5;
@property (weak, nonatomic) IBOutlet UITableViewCell *cell6;




@end
