//
//  ABFollowersTVC.m
//  APIDZ-45
//
//  Created by Александр on 24.08.15.
//  Copyright (c) 2015 Alex Bukharov. All rights reserved.
//

#import "ABFollowersTVC.h"
#import "ABServerManager.h"
#import "ABCellFollowers.h"
#import "ABUser.h"
#import <UIImageView+AFNetworking.h>

@interface ABFollowersTVC ()

@property (strong, nonatomic) NSMutableArray *followersArray;

@end

@implementation ABFollowersTVC

static NSInteger followersInRequest = 20;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.followersArray = [NSMutableArray array];
    
    [self getFollowersFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - API

- (void)getFollowersFromServer {
    
    [[ABServerManager shareManager] getFollowersWithUserId:self.userId offset:[self.followersArray count] count:followersInRequest onSuccess:^(NSArray *followers) {
        
        [self.followersArray addObjectsFromArray:followers];
        
        NSMutableArray *newPaths = [NSMutableArray array];
        
        for (int i = (int)[self.followersArray count] - (int)[followers count]; i < [self.followersArray count]; i++) {
            
            [newPaths addObject:[NSIndexPath indexPathForItem:i inSection:0]];
        }
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:newPaths withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
        
    } onFailure:^(NSError *error, NSInteger statusCode) {
        NSLog(@"error = %@, code = %ld", [error localizedDescription], statusCode);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.followersArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"ABCellFollowers";
    
    ABCellFollowers *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    ABUser *user = [self.followersArray objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.firstName];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:user.avatar50];
    
    __weak ABCellFollowers *weakCell = cell;
    
    cell.avatar.image = nil;
    
    [cell.imageView setImageWithURLRequest:request
                          placeholderImage:nil
                                   success:^(NSURLRequest * request, NSHTTPURLResponse * response, UIImage * image) {
                                       weakCell.avatar.image = image;
                                       [weakCell layoutSubviews];
                                   } failure:^(NSURLRequest * request, NSHTTPURLResponse * response, NSError * error) {
                                       
                                   }];
    
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView{
    NSArray *visibleRows = [self.tableView visibleCells];
    UITableViewCell *lastVisibleCell = [visibleRows lastObject];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:lastVisibleCell];
    if (indexPath.row == [self.followersArray count]-1) {
        [self getFollowersFromServer];
    }
}
@end
