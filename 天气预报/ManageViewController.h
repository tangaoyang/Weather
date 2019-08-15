//
//  ManageViewController.h
//  天气预报
//
//  Created by cinderella on 2019/8/13.
//  Copyright © 2019 cinderella. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherView.h"
#import "SearchViewController.h"

NS_ASSUME_NONNULL_BEGIN
@protocol  manageDelegate <NSObject>

- (void)cityArray: (NSMutableArray *)cityName show:(NSInteger)num;

@end

@interface ManageViewController : UIViewController
<
UITableViewDelegate,
UITableViewDataSource,
NSURLSessionDelegate,
searchDelegate
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *cityNameArray;
@property (nonatomic, copy) NSMutableString *city;
@property (nonatomic, strong) NSMutableArray *timeArray;
@property (nonatomic, strong) NSMutableArray *cArray;
@property (nonatomic, strong) UIButton *addButton;
//@property (nonatomic, strong) UIButton *showWeatherButton;
@property id <manageDelegate> managedelegate;

@end

NS_ASSUME_NONNULL_END
