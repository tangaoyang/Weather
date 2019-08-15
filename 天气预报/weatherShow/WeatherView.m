//
//  WeatherView.m
//  天气预报
//
//  Created by cinderella on 2019/8/12.
//  Copyright © 2019 cinderella. All rights reserved.
//

#import "WeatherView.h"
#import "ATableViewCell.h"
#import "ElseTableViewCell.h"
#import "ScrollView.h"
#define W ([UIScreen mainScreen].bounds.size.width)
#define H ([UIScreen mainScreen].bounds.size.height)

@implementation WeatherView

- (instancetype)initWithFrame:(CGRect)frame CityName:(NSString *)cityName {
    
    if (self = [super initWithFrame:(CGRect)frame]) {
        _cityName = cityName;
//        [self postOneDay];
        [self postHour];
        
        _leftArray = [[NSArray alloc] init];
        _leftArray = @[@"日出", @"降雨概率", @"风", @"降水量",@"能见度"];
        _rightArray = [[NSArray alloc] init];
        _rightArray = @[@"日落", @"湿度", @"体感温度", @"气压", @"紫外线指数"];
    }
    return self;
}

- (void)creatTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) style:UITableViewStylePlain];
    [self addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView registerClass:[UPTableViewCell class] forCellReuseIdentifier:@"up"];
    [_tableView registerClass:[ScrollTableViewCell class] forCellReuseIdentifier:@"scroll"];
    [_tableView registerClass:[WeekTableViewCell class] forCellReuseIdentifier:@"week"];
    [_tableView registerClass:[ATableViewCell class] forCellReuseIdentifier:@"a"];
    [_tableView registerClass:[ElseTableViewCell class] forCellReuseIdentifier:@"else"];
    
}

- (void)postOneDay {
//    NSLog(@"postOneDay");
    NSString *urlString = [NSString stringWithFormat:@"https://free-api.heweather.net/s6/weather?location=%@&key=71f533964a994355bb1abfccb161d241", _cityName];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString: urlString];
//    NSLog(@"%@", _cityName);
//    NSLog(@"%@", urlString);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *sharedSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [sharedSession dataTaskWithRequest:request completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
        if(data) {
            self->_firstDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//            NSLog(@"data");
            self->_dataMutableArray = [[NSMutableArray alloc] init];
            self->_dataMutableArray = self->_firstDictionary[@"HeWeather6"];
            self->_oneDayDictionary = [[NSDictionary alloc] init];
            self->_oneDayDictionary = self->_dataMutableArray[0][@"daily_forecast"][0];
            /*for (int i = 0; i < 3; i++) {
//                [self->_weekArray addObject:self->_dataMutableArray[0][@"daily_forecast"][i][@"week"]];
                [self->_weekImageArray addObject:[NSString stringWithFormat:@"%@.png", self->_dataMutableArray[0][@"daily_forecast"][i][@"cond_code_d"]]];
                [self->_weekHighArray addObject:self->_dataMutableArray[0][@"daily_forecast"][i][@"tmp_max"]];
                [self->_weekLowArray addObject:self->_dataMutableArray[0][@"daily_forecast"][i][@"tmp_min"]];
            }*/
            self->_nowDictionary = [[NSDictionary alloc] init];
            self->_nowDictionary = self->_dataMutableArray[0][@"now"];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self creatHourArray];
                if (self->_tableView) {
//                    NSLog(@"reload");
                    [self->_tableView reloadData];
                } else {
//                    NSLog(@"creat");
                    [self creatTableView];
                }
            }];
        } else {
            NSLog(@"error = %@", error);
        }
    }];
    [dataTask resume];
}

- (void)postHour {
//    NSLog(@"postHour");
//    NSLog(@"cityName = %@", _cityName);
    NSString *urlString = [NSString stringWithFormat:@"http://api.k780.com/?app=weather.realtime&weaid=%@&ag=today,futureDay,lifeIndex,futureHour&appkey=44524&sign=54dc62def4393a0d5cfe97a2a52646a6&format=json", _cityName];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *sharedSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [sharedSession dataTaskWithRequest:request completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
        if (data) {
            self->_secondDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            self->_timeArray = [[NSMutableArray alloc] init];
            self->_cArray = [[NSMutableArray alloc] init];
            self->_weatherImageArray = [[NSMutableArray alloc] init];
            for (int i = 0; i < 24; i++) {
                NSMutableString *str1 = [NSMutableString stringWithFormat:@"%@", self->_secondDictionary[@"result"][@"futureHour"][i][@"dateYmdh"]];
                [str1 deleteCharactersInRange: NSMakeRange(0, 11)];
                [str1 deleteCharactersInRange: NSMakeRange(5, 3)];
                [self->_timeArray addObject: str1];
                [self->_cArray addObject: self->_secondDictionary[@"result"][@"futureHour"][i][@"wtTemp"]];
                NSString *str = [NSString stringWithFormat:@"%@.png", self->_secondDictionary[@"result"][@"futureHour"][i][@"wtIcon"]];
                 [self->_weatherImageArray addObject: str];
            }
            self->_weekArray = [[NSMutableArray alloc] init];
            self->_weekImageArray = [[NSMutableArray alloc] init];
            self->_weekHighArray = [[NSMutableArray alloc] init];
            self->_weekLowArray = [[NSMutableArray alloc] init];
            for (int i = 0; i < 6; i++) {
                [self->_weekArray addObject:self->_secondDictionary[@"result"][@"futureDay"][i][@"week"]];
                NSString *str = [NSString stringWithFormat:@"%@.png", self->_secondDictionary[@"result"][@"futureDay"][i][@"wtIcon1"]];
                [self->_weekImageArray addObject:str];
                [self->_weekHighArray addObject:self->_secondDictionary[@"result"][@"futureDay"][i][@"wtTemp1"]];
                [self->_weekLowArray addObject:self->_secondDictionary[@"result"][@"futureDay"][i][@"wtTemp2"]];
            }
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self postOneDay];
            }];
        } else {
            NSLog(@"error = %@", error);
        }
    }];
    [dataTask resume];
}

- (void)creatHourArray {
    _hourShowArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 24; i++) {
        ScrollView *view = [[ScrollView alloc] initWithHour:_timeArray[i] c:_cArray[i] image:[UIImage imageNamed:_weatherImageArray[i]]];
        view.frame = CGRectMake( W / 4 * i, 0, W / 4, 160);
        [_hourShowArray addObject:view];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"cell");
    if(indexPath.row == 0) {
        UPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"up" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cityLabel.text = _cityName;
        cell.weatherLabel.text = _nowDictionary[@"cond_txt"];
        NSString *str = [NSString stringWithFormat:@"%@°",_nowDictionary[@"tmp"]];
        cell.cLabel.text = str;
        cell.weekLabel.text = _secondDictionary[@"result"][@"realTime"][@"week"];
        cell.highLabel.text = _oneDayDictionary[@"tmp_max"];
        cell.lowLabel.text = _oneDayDictionary[@"tmp_min"];
        cell.dayLabel.text = @"今天";
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    } else if (indexPath.row== 1) {
        ScrollTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"scroll" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_timeArray.count == 24 && _cArray.count == 24 && _weatherImageArray.count == 24) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        for (int i = 0; i < 24; i++) {
//            ScrollView *view = [[ScrollView alloc] initWithHour:_timeArray[i] c:_cArray[i] image:[UIImage imageNamed:_weatherImageArray[i]]];
//            view.frame = CGRectMake( W / 4 * i, 0, W / 4, 160);
//            view.weeklabel.text = _timeArray[i];
//            view.WeatherImageView.image = [UIImage imageNamed:_weatherImageArray[i]];
//            view.cLabel.text = _cArray[i];
            [cell.scrollView addSubview:_hourShowArray[i]];
        }
//            cell.scrollView = scrollView;
        }
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    } else if (indexPath.row >= 2 && indexPath.row <= 7) {
        WeekTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"week" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        if (_weekArray.count == 6 && _weekImageArray.count == 6 && _weekLowArray.count == 6 && _weekHighArray.count == 6) {
        cell.weekLabel.text = _weekArray[indexPath.row - 2];
        cell.weatherImageView.image = [UIImage imageNamed:_weekImageArray[indexPath.row - 2]];
        cell.highLabel.text = _weekHighArray[indexPath.row - 2];
        cell.lowLabel.text = _weekLowArray[indexPath.row - 2];
        }
        return cell;
    } else if (indexPath.row == 8) {
        ATableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"a" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.weatherLabel.text = [NSString stringWithFormat:@"今天：当前%@。气温%@；预计最高气温%@。", _nowDictionary[@"cond_txt"], _nowDictionary[@"tmp"], self->_oneDayDictionary[@"tmp_max"]];
        return cell;
    } else {
        ElseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"else" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.littleLeftLabel.text = _leftArray[indexPath.row - 9];
        cell.littleRightLabel.text = _rightArray[indexPath.row - 9];
        if (indexPath.row == 9) {
            cell.largeLeftLabel.text = _dataMutableArray[0][@"daily_forecast"][0][@"sr"];
            cell.largeRightLabel.text = _dataMutableArray[0][@"daily_forecast"][0][@"ss"];
        }
        if (indexPath.row == 10) {
            cell.largeLeftLabel.text = _dataMutableArray[0][@"daily_forecast"][0][@"pop"];
            cell.largeRightLabel.text = _dataMutableArray[0][@"daily_forecast"][0][@"hum"];
        }
        if (indexPath.row == 11) {
            cell.largeLeftLabel.text = _dataMutableArray[0][@"daily_forecast"][0][@"wind_spd"];
            cell.largeRightLabel.text = _nowDictionary[@"fl"];        }
        if (indexPath.row == 12) {
            cell.largeLeftLabel.text = _nowDictionary[@"pcpn"];
            cell.largeRightLabel.text = _nowDictionary[@"pres"];
        }
        if (indexPath.row == 13) {
            cell.largeLeftLabel.text = _nowDictionary[@"vis"];
            cell.largeRightLabel.text = _dataMutableArray[0][@"daily_forecast"][0][@"uv_index"];
        }
        return cell;
    }
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 14;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 260;
    } else if (indexPath.row == 1) {
        return 160;
    } else {
        return 60;
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}*/


@end

