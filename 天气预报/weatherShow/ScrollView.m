
//
//  ScrollView.m
//  天气预报
//
//  Created by cinderella on 2019/8/14.
//  Copyright © 2019 cinderella. All rights reserved.
//

#import "ScrollView.h"
#define W (self.bounds.size.width)
#define H (self.bounds.size.height)

@implementation ScrollView

- (instancetype)initWithHour:(NSString *)hour c:(NSString *)c image:(UIImage *)image {
    
    if (self = [super init]) {
        _weeklabel = [[UILabel alloc] init];
        _weeklabel.text = hour;
        _weeklabel.frame = CGRectMake(30, 10, 80, 30);
        _weeklabel.textColor = [UIColor whiteColor];
        _weeklabel.font = [UIFont systemFontOfSize:20];
        [self addSubview:_weeklabel];
        
        _cLabel = [[UILabel alloc] init];
        _cLabel.text = c;
        [self addSubview:_cLabel];
        _cLabel.frame = CGRectMake(39, 60, 80, 30);
        _cLabel.font = [UIFont systemFontOfSize:20];
        _cLabel.textColor = [UIColor whiteColor];
        
        _WeatherImageView = [[UIImageView alloc] init];
        _WeatherImageView.image = image;
        [self addSubview:_WeatherImageView];
        _WeatherImageView.frame = CGRectMake(30, 100, 45, 40);
    }
    
    return self;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
