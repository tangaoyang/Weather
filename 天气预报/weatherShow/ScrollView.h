//
//  ScrollView.h
//  天气预报
//
//  Created by cinderella on 2019/8/14.
//  Copyright © 2019 cinderella. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScrollView : UIView

@property (nonatomic, strong) UILabel *weeklabel;
@property (nonatomic, strong) UILabel *cLabel;
@property (nonatomic, strong) UIImageView *WeatherImageView;

- (instancetype)initWithHour:(NSString *)hour c:(NSString *)c image:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
