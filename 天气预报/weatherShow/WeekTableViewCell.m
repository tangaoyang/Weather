//
//  WeekTableViewCell.m
//  天气预报
//
//  Created by cinderella on 2019/8/10.
//  Copyright © 2019 cinderella. All rights reserved.
//

#import "WeekTableViewCell.h"
#define W (self.bounds.size.width)
#define H (self.bounds.size.height)

@implementation WeekTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    _weekLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_weekLabel];
    
    _highLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_highLabel];
    
    _lowLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_lowLabel];
    
    _weatherImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_weatherImageView];
    
    return self;
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    _weekLabel.frame = CGRectMake(40, 9, W * 0.3, 50);
    _weekLabel.font = [UIFont systemFontOfSize:27];
    _weekLabel.textColor = [UIColor whiteColor];
    
    _highLabel.frame = CGRectMake(W * 0.75, 18, W / 10, 30);
    _highLabel.font = [UIFont systemFontOfSize:24];
    _highLabel.textColor = [UIColor whiteColor];
    
    _lowLabel.frame = CGRectMake(W * 0.85, 18, W / 10, 30);
    _lowLabel.font = [UIFont systemFontOfSize:24];
    _lowLabel.textColor = [UIColor whiteColor];
    
    _weatherImageView.frame = CGRectMake(W / 2 - 20, 10, 40, 40);
    
    
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
