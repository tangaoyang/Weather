//
//  WeatherView.h
//  天气预报
//
//  Created by cinderella on 2019/8/12.
//  Copyright © 2019 cinderella. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPTableViewCell.h"
#import "ScrollTableViewCell.h"
#import "WeekTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol WeatherDelegate <NSObject>

- (void)time:(NSString *)str c:(NSString *)str;

@end

@interface WeatherView : UIView
<
UITableViewDelegate,
UITableViewDataSource,
NSURLSessionDelegate
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *timeArray;
@property (nonatomic, strong) NSMutableArray *cArray;
@property (nonatomic, strong) NSMutableArray *weatherImageArray;
@property (nonatomic, strong) NSMutableArray *weekArray;
@property (nonatomic, strong) NSMutableArray *weekImageArray;
@property (nonatomic, strong) NSMutableArray *weekHighArray;
@property (nonatomic, strong) NSMutableArray *weekLowArray;
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) NSDictionary *oneDayDictionary;
@property (nonatomic, strong) NSDictionary *nowDictionary;
@property (nonatomic, strong) NSMutableArray *dataMutableArray;
@property (nonatomic, strong) NSDictionary *firstDictionary;
@property (nonatomic, strong) NSDictionary *secondDictionary;
@property (nonatomic, strong) NSArray *leftArray;
@property (nonatomic, strong) NSArray *rightArray;
@property (nonatomic, strong) NSMutableArray *hourShowArray;
@property id <WeatherDelegate> weatherDelegate;

- (instancetype)initWithFrame:(CGRect)frame CityName:(NSString *)cityName;

@end

NS_ASSUME_NONNULL_END
