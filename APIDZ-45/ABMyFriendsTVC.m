//
//  ViewController.m
//  APIDZ-45
//
//  Created by Александр on 21.08.15.
//  Copyright (c) 2015 Alex Bukharov. All rights reserved.
//

#import "ABMyFriendsTVC.h"
#import "ABServerManager.h"
#import "ABUser.h"
#import <UIImageView+AFNetworking.h>
#import "ABDetailFriendTVC.h"
#import "ABCell.h"

@interface ABMyFriendsTVC ()

@property (strong, nonatomic) NSMutableArray *friendsArray;

@end

@implementation ABMyFriendsTVC

static NSInteger friendsInRequest = 20;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.friendsArray = [NSMutableArray array];
    
    [self getFriendsFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - API

- (void)getFriendsFromServer {
    
    [[ABServerManager shareManager] getFriendsWithOffset:[self.friendsArray count] count:friendsInRequest onSuccess:^(NSArray *friends) {
        
        [self.friendsArray addObjectsFromArray:friends];
        
        NSMutableArray *newPaths = [NSMutableArray array];
        
        for (int i = (int)[self.friendsArray count] - (int)[friends count]; i < [self.friendsArray count]; i++) {
            
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
    
    return [self.friendsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"Cell";
    
    ABCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    ABUser *friend = [self.friendsArray objectAtIndex:indexPath.row];
    
    cell.labelName.text = [NSString stringWithFormat:@"%@ %@", friend.firstName, friend.lastName];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:friend.avatar50];
    
    __weak ABCell *weakCell = cell;
    
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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ABUser *friend = [self.friendsArray objectAtIndex:indexPath.row];
    
    ABDetailFriendTVC *tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ABDetailFriendTVC"];
    
    tvc.userId = friend.userId;
    
    tvc.labelName = nil;
    
    [self.navigationController pushViewController:tvc animated:YES];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView{
    NSArray *visibleRows = [self.tableView visibleCells];
    UITableViewCell *lastVisibleCell = [visibleRows lastObject];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:lastVisibleCell];
    if (indexPath.row == [self.friendsArray count]-1) {
        [self getFriendsFromServer];
    }
}


@end
