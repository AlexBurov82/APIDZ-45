//
//  ABWallCell.h
//  APIDZ-45
//
//  Created by Александр on 25.08.15.
//  Copyright (c) 2015 Alex Bukharov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABWallCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *text;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *likesCount;
@property (weak, nonatomic) IBOutlet UIImageView *photo;


@end
