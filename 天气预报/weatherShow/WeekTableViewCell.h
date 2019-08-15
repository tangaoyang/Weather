//
//  WeekTableViewCell.h
//  天气预报
//
//  Created by cinderella on 2019/8/10.
//  Copyright © 2019 cinderella. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeekTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *weekLabel;
@property (nonatomic, strong) UILabel *highLabel;
@property (nonatomic, strong) UILabel *lowLabel;
@property (nonatomic, strong) UIImageView *weatherImageView;

@end

NS_ASSUME_NONNULL_END
