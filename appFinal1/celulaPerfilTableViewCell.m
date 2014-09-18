//
//  celulaPerfilTableViewCell.m
//  appFinal1
//
//  Created by Rafael Cardoso on 24/08/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import "celulaPerfilTableViewCell.h"

@implementation celulaPerfilTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(5, 3, 65, 65);
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius =  self.imageView.frame.size.width / 2;
}

@end
