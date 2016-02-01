//
//  ItemInfoCellView.m
//  maps
//
//  Created by Andriukas on 2010-06-22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ItemInfoCellView.h"


@implementation ItemInfoCellView

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void) layoutSubviews {
	[super layoutSubviews]; // layouts the cell as UITableViewCellStyleValue2 would normally look like
	
	// change frame of one or more labels
	self.textLabel.frame = CGRectMake(10,10,120,25);
	self.detailTextLabel.frame = CGRectMake(140,10,75,25);
}


- (void)dealloc {
    [super dealloc];
}


@end
