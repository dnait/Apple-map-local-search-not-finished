//
//  searchresultsCell.m
//  MKLocalSearchSample
//
//  Created by Rao on 2/25/15.
//  Copyright (c) 2015 Kosuke Ogawa. All rights reserved.
//

#import "searchresultsCell.h"

@implementation searchresultsCell
@synthesize name;
@synthesize address;
@synthesize milelabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
