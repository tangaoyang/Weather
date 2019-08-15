//
//  ATableViewCell.m
//  天气预报
//
//  Created by cinderella on 2019/8/12.
//  Copyright © 2019 cinderella. All rights reserved.
//

#import "ATableViewCell.h"

@implementation ATableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    _weatherLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_weatherLabel];
    return self;
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    _weatherLabel.frame = CGRectMake(40, 0, 400, 70);
    _weatherLabel.textColor = [UIColor whiteColor];
    _weatherLabel.numberOfLines = 0;
    
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
