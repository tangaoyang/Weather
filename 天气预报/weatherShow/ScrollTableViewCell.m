//
//  ScrollTableViewCell.m
//  天气预报
//
//  Created by cinderella on 2019/8/10.
//  Copyright © 2019 cinderella. All rights reserved.
//

#import "ScrollTableViewCell.h"

@implementation ScrollTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    _scrollView = [[UIScrollView alloc] init];
    [self.contentView addSubview:_scrollView];
    
    return self;
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    _scrollView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 160);
    _scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 6, 160);
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
