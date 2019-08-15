//
//  ManageViewController.m
//  天气预报
//
//  Created by cinderella on 2019/8/13.
//  Copyright © 2019 cinderella. All rights reserved.
//

#import "ManageViewController.h"
#import "ManageTableViewCell.h"
#import "SearchViewController.h"
#define W (self.view.bounds.size.width)
#define H (self.view.bounds.size.height)

@interface ManageViewController ()

@end

@implementation ManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImage *backImage = [UIImage imageNamed:@"image1.jpg"];
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:backImage];
    backImageView.frame = self.view.bounds;
    [self.view insertSubview:backImageView atIndex:0];
    
    _addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:_addButton];
    _addButton.frame = CGRectMake(W * 0.8, H * 0.9, 55, 50);
    _addButton.backgroundColor = [UIColor clearColor];
    UIImage *addImage = [[UIImage imageNamed:@"加.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_addButton setImage:addImage forState:UIControlStateNormal];
    [_addButton addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchDown];
    
//    _showWeatherButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [self.view addSubview:_showWeatherButton];
//    _showWeatherButton.frame = CGRectMake(W * 0.2, H * 0.9, 55, 50);
//    _showWeatherButton.backgroundColor = [UIColor clearColor];
//    UIImage *showImage = [[UIImage imageNamed:@"yun.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    [_showWeatherButton setImage:showImage forState:UIControlStateNormal];
//    [_showWeatherButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    
//    _cityNameArray = [[NSMutableArray alloc] init];
    _timeArray = [[NSMutableArray alloc] init];
    _cArray = [[NSMutableArray alloc] init];
//    [_cityNameArray addObject:_city];
//    NSLog(@"%lu", (unsigned long)_cityNameArray.count);
//    NSLog(@"citynameArray = %@", _cityNameArray);
    [self cityCreatUrl];
}

- (void)cityCreatUrl {
    for (int i = 0; i < _cityNameArray.count; i++) {
        _city = _cityNameArray[i];
        [self creatUrl];
    }
}

- (void)add {
//    NSLog(@"add");
    SearchViewController *search = [[SearchViewController alloc] init];
    search.searchdelegate = self;
    search.cityShowArray = _cityNameArray;
    [self presentViewController:search animated:NO completion:nil];
    
}


- (void)CityName:(NSString *)cityName add:(BOOL)add {
    if (add) {
        [_cityNameArray addObject:cityName];
        _city = [NSMutableString stringWithString:cityName];
        [self creatUrl];
    }
    
}

- (void)creatUrl {
//    NSLog(@"url%@", _city);
    NSString *urlString = [NSString stringWithFormat:@"https://free-api.heweather.net/s6/weather?location=%@&key=71f533964a994355bb1abfccb161d241", _city];
//    NSLog(@"%@", urlString);
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *sharedSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [sharedSession dataTaskWithRequest:request completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
        if(data) {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//            NSLog(@"timeArrayBefore = %@", self->_timeArray);
//            NSLog(@"%@", self->_city);
            [self->_timeArray addObject:dataDictionary[@"HeWeather6"][0][@"daily_forecast"][0][@"date"]];
//            NSLog(@"timeArray = %@", self->_timeArray);
            [self->_cArray addObject:dataDictionary[@"HeWeather6"][0][@"now"][@"tmp"]];
//            NSLog(@"cArray = %@", self->_cArray);
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if (self->_tableView) {
//                    NSLog(@"reload");
                    [self->_tableView reloadData];
                } else {
                    [self creatTableView];
//                    NSLog(@"creat");
                }
            }];
        }
    }];
    [dataTask resume];
}

- (void)creatTableView {
//    NSLog(@"tableView");
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, W, H * 0.9) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    UIView *view = [[UIView alloc] init];
    _tableView.tableFooterView = view;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView registerClass:[ManageTableViewCell class] forCellReuseIdentifier:@"111"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"cell");
    ManageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"111" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    if (_cArray.count == _cityNameArray.count && _timeArray.count == _cityNameArray.count) {
        cell.cityLabel.text = _cityNameArray[indexPath.row];
        cell.cLabel.text = _cArray[indexPath.row];
        cell.timeLabel.text = _timeArray[indexPath.row];
    }
   
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cityNameArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self dismissViewControllerAnimated:NO completion:nil];
    if ([_managedelegate respondsToSelector:@selector(cityArray:show:)]) {
        [_managedelegate cityArray:_cityNameArray show:indexPath.row];
    }
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
