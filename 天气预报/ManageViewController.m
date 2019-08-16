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

@interface ManageViewController () {
    int i;
}

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
    
//    _timeArray = [[NSMutableArray alloc] init];
    _temDictionary = [[NSMutableDictionary alloc] init];
    _timeDictionary = [[NSMutableDictionary alloc] init];
//    [_cityNameArray addObject:_city];
//    NSLog(@"%lu", (unsigned long)_cityNameArray.count);
//    NSLog(@"citynameArray = %@", _cityNameArray);
    [self cityCreatUrl];
}

- (void)cityCreatUrl {

    for (i = 0; i < _cityNameArray.count; i++) {
//        _city = _cityNameArray[i];
        [self creatUrli:i];
    }
//    NSLog(@"citycreat_temDictionary.count = %lu", (unsigned long)_temDictionary.count);
//    NSLog(@"citycreat_cityNameArray.count = %lu", _cityNameArray.count);
}

- (void)add {
    SearchViewController *search = [[SearchViewController alloc] init];
    search.searchdelegate = self;
    search.cityShowArray = _cityNameArray;
    [self presentViewController:search animated:NO completion:nil];
    
}


- (void)CityName:(NSString *)cityName add:(BOOL)add {
    if (add) {
        [_cityNameArray addObject:cityName];
        _city = [NSMutableString stringWithString:cityName];
        [self cityCreatUrl];
    }
    
}

- (void)creatUrli: (int)i {
    NSString *urlString = [NSString stringWithFormat:@"https://free-api.heweather.net/s6/weather?location=%@&key=71f533964a994355bb1abfccb161d241", _cityNameArray[i]];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *sharedSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [sharedSession dataTaskWithRequest:request completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
        if(data) {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//            NSLog(@"dataDictionary = %@", dataDictionary);
            if ([dataDictionary[@"HeWeather6"][0][@"status"] isEqualToString:@"ok"]) {
                NSMutableString *string = [NSMutableString stringWithFormat:@"%@",dataDictionary[@"HeWeather6"][0][@"update"][@"loc"]];
                [string deleteCharactersInRange:NSMakeRange(0, 11)];
                [self->_timeDictionary setObject:string forKey:self->_cityNameArray[i]];
//                NSLog(@"url_timeDictionary = %@", self->_timeDictionary);
                [self->_temDictionary setObject:dataDictionary[@"HeWeather6"][0][@"now"][@"tmp"] forKey:self->_cityNameArray[i]];
//                NSLog(@"url_temDictionary = %@", self->_temDictionary);
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    if (self->_tableView) {
                        [self->_tableView reloadData];
                    } else {
                        [self creatTableView];
                    }
                }];
            } else {
                [self->_cityNameArray removeObjectAtIndex:self->_cityNameArray.count - 1];
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [self->_tableView reloadData];
                }];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"没有该城市!" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *sure = [UIAlertAction actionWithTitle:@"sure" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:sure];
                [self presentViewController:alert animated:NO completion:nil];
            }
        }
    }];
    [dataTask resume];
}

- (void)creatTableView {
//    NSLog(@"creatTableView");
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
    ManageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"111" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    if ( _temDictionary.count == _cityNameArray.count) {
        cell.cityLabel.text = _cityNameArray[indexPath.row];
        cell.cLabel.text = _temDictionary[_cityNameArray[indexPath.row]];
        cell.timeLabel.text = _timeDictionary[_cityNameArray[indexPath.row]];
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
