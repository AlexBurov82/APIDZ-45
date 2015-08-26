//
//  ABSubscriptionsTVC.m
//  APIDZ-45
//
//  Created by Александр on 24.08.15.
//  Copyright (c) 2015 Alex Bukharov. All rights reserved.
//

#import "ABSubscriptionsTVC.h"
#import "ABServerManager.h"
#import "ABCellSubscriptions.h"
#import "ABUser.h"
#import <UIImageView+AFNetworking.h>

@interface ABSubscriptionsTVC ()

@property (strong, nonatomic) NSMutableArray *subscriptionsArray;

@end

@implementation ABSubscriptionsTVC

static NSInteger subscriptionsInRequest = 20;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.subscriptionsArray = [NSMutableArray array];
    
    [self getSubscriptionsFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - API

- (void)getSubscriptionsFromServer {
    
    [[ABServerManager shareManager] getSubscriptionsWithUserId:self.userId offset:[self.subscriptionsArray count] count:subscriptionsInRequest onSuccess:^(NSArray *subscriptions) {
        
        [self.subscriptionsArray addObjectsFromArray:subscriptions];
        
        NSMutableArray *newPaths = [NSMutableArray array];
        
        for (int i = (int)[self.subscriptionsArray count] - (int)[subscriptions count]; i < [self.subscriptionsArray count]; i++) {
            
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
    
    return [self.subscriptionsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"ABSubscriptionsCell";
    
    ABCellSubscriptions *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    ABUser *user = [self.subscriptionsArray objectAtIndex:indexPath.row];
    
    if (user.nameSubscriptions) {
        cell.nameLabel.text = [NSString stringWithFormat:@"%@", user.nameSubscriptions];
    } else {
        cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:user.avatar50];
    
    __weak ABCellSubscriptions *weakCell = cell;
    
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
    if (indexPath.row == [self.subscriptionsArray count]-1) {
        [self getSubscriptionsFromServer];
    }
}

@end
