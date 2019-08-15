//
//  UPTableViewCell.m
//  天气预报
//
//  Created by cinderella on 2019/8/10.
//  Copyright © 2019 cinderella. All rights reserved.
//

#import "UPTableViewCell.h"
#define W (self.bounds.size.width)
#define H ([UIScreen mainScreen].bounds.size.height)

@implementation UPTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    _cityLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_cityLabel];
    
    _weatherLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_weatherLabel];
    
    _cLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_cLabel];
    
    _weekLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_weekLabel];
    
    _dayLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_dayLabel];
    
    _highLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_highLabel];
    
    _lowLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_lowLabel];
    
    return self;
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    _cityLabel.frame = CGRectMake(0, 10, W, 50);
    _cityLabel.numberOfLines = 0;
    _cityLabel.font = [UIFont systemFontOfSize:45];
    _cityLabel.textColor = [UIColor whiteColor];
    _cityLabel.textAlignment = NSTextAlignmentCenter;
    
    _weatherLabel.frame = CGRectMake(0, 65, W, 35);
    _weatherLabel.font = [UIFont systemFontOfSize:30];
    _weatherLabel.textColor = [UIColor whiteColor];
    _weatherLabel.textAlignment = NSTextAlignmentCenter;
    
    _cLabel.frame = CGRectMake(0, 120, W, 75);
    _cLabel.font = [UIFont systemFontOfSize:90];
    _cLabel.textColor = [UIColor whiteColor];
    _cLabel.textAlignment = NSTextAlignmentCenter;
    
    _weekLabel.frame = CGRectMake(40, 215, 190, 40);
    _weekLabel.font = [UIFont systemFontOfSize:29];
    _weekLabel.textColor = [UIColor whiteColor];
    
    _dayLabel.frame = CGRectMake(135, 220, 100, 30);
    _dayLabel.font = [UIFont systemFontOfSize:24];
    _dayLabel.textColor = [UIColor whiteColor];
    
    _highLabel.frame = CGRectMake(self.bounds.size.width * 0.75, 220, self.bounds.size.width / 10, 30);
    _highLabel.font = [UIFont systemFontOfSize:24];
    _highLabel.textColor = [UIColor whiteColor];
    
    _lowLabel.frame = CGRectMake(self.bounds.size.width * 0.85, 220, self.bounds.size.width / 10, 30);
    _lowLabel.font = [UIFont systemFontOfSize:24];
    _lowLabel.textColor = [UIColor whiteColor];
    
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
