//
//  albumInfoTableViewCell.m
//  iLivinMusicUIUX
//
//  Created by jaehoon lee on 7/1/12.
//  Copyright (c) 2012 Kaist. All rights reserved.
//

#import "albumInfoTableViewCell.h"

@implementation albumInfoTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if(selected)
        [self setAccessoryType:UITableViewCellAccessoryCheckmark];
    else
        [self setAccessoryType:UITableViewCellAccessoryNone];
}

@end
