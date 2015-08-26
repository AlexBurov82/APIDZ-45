//
//  ABWallTVC.m
//  APIDZ-45
//
//  Created by Александр on 24.08.15.
//  Copyright (c) 2015 Alex Bukharov. All rights reserved.
//

#import "ABWallTVC.h"
#import "ABServerManager.h"
#import "ABWallCell.h"
#import "ABWall.h"
#import <UIImageView+AFNetworking.h>
#import "ABWallCell2.h"

@interface ABWallTVC ()

@property (strong, nonatomic) NSMutableArray *wallArray;

@end

@implementation ABWallTVC

static NSInteger wallInRequest = 20;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.wallArray = [NSMutableArray array];
    
    [self getWallFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - API

- (void)getWallFromServer {
    
    [[ABServerManager shareManager] getWallWithUserId:self.ownerId offset:[self.wallArray count] count:wallInRequest onSuccess:^(NSArray *wall) {
        
        [self.wallArray addObjectsFromArray:wall];
        
        NSMutableArray *newPaths = [NSMutableArray array];
        
        for (int i = (int)[self.wallArray count] - (int)[wall count]; i < [self.wallArray count]; i++) {
            
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
    
    return [self.wallArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"ABCellWall";
    
    static NSString *identifier2 = @"ABCellWall2";
    
    ABWall *wall = [self.wallArray objectAtIndex:indexPath.row];
    
    if (wall.photo != nil) {
        ABWallCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        cell.text.text = wall.text;
        
        cell.date.text = wall.date;
        cell.likesCount.text = [NSString stringWithFormat:@"%ld", wall.likesCount];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:wall.photo];
        
        __weak ABWallCell *weakCell = cell;
        
        cell.photo.image = nil;
        
        [cell.imageView setImageWithURLRequest:request
                              placeholderImage:nil
                                       success:^(NSURLRequest * request, NSHTTPURLResponse * response, UIImage * image) {
                                           weakCell.photo.image = image;
                                           [weakCell layoutSubviews];
                                       } failure:^(NSURLRequest * request, NSHTTPURLResponse * response, NSError * error) {
                                           
                                       }];
        
        return cell;
     
    } else {
     
        ABWallCell2 *cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
        
        cell.text.text = wall.text;
        
        cell.date.text = wall.date;
        cell.like.text = [NSString stringWithFormat:@"%ld", wall.likesCount];
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView{
    NSArray *visibleRows = [self.tableView visibleCells];
    UITableViewCell *lastVisibleCell = [visibleRows lastObject];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:lastVisibleCell];
    if (indexPath.row == [self.wallArray count]-1) {
        [self getWallFromServer];
    }
}

@end
