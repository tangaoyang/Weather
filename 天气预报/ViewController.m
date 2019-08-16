//
//  ViewController.m
//  天气预报
//
//  Created by 唐傲洋 on 2019/8/10.
//  Copyright © 2019 cinderella. All rights reserved.
//

#import "ViewController.h"
#import "SearchViewController.h"
#import "WeatherView.h"
#import "ManageViewController.h"
#import "ScrollView.h"
#define W ([UIScreen mainScreen].bounds.size.width)
#define H ([UIScreen mainScreen].bounds.size.height)

@interface ViewController (){
    int i;
    int d;
    int a;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    i = 1;
    UIImage *backImage = [UIImage imageNamed:@"image1.jpg"];
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:backImage];
    backImageView.frame = self.view.bounds;
    [self.view insertSubview:backImageView atIndex:0];
    
    _scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:_scrollView];
    _scrollView.frame = self.view.bounds;
    _scrollView.pagingEnabled = YES;
    _scrollView.scrollEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(W, H * 0.9);
    _scrollView.delegate = self;
    
    _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_addButton];
    _addButton.frame = CGRectMake(W * 0.8, H * 0.9, 55, 50);
    _addButton.backgroundColor = [UIColor clearColor];
    [_addButton setImage:[UIImage imageNamed:@"菜单栏.png"] forState:UIControlStateNormal];
    [_addButton addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchDown];
    
    _pageControl = [[UIPageControl alloc] init];
    [self.view addSubview:_pageControl];
    _pageControl.numberOfPages = i;
    _pageControl.center = CGPointMake(W / 2, H * 0.93);
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    
    d = 0;
    a = 0;
    _cityArray = [[NSMutableArray alloc] init];
    [self creatInit];
    
}

- (void)add {
    
    ManageViewController *manage = [[ManageViewController alloc] init];
//    NSLog(@"_cityArray = %@", _cityArray);
    manage.managedelegate = self;
    manage.cityNameArray = _cityArray;
//    NSLog(@" manage.cityNameArray = %@", manage.cityNameArray);
    [self presentViewController:manage animated:NO completion:nil];
    
}

- (void)confirm: (NSString *)name{
    NSString *urlString = [NSString stringWithFormat:@"http://api.k780.com/?app=weather.realtime&weaid=%@&ag=today,futureDay,lifeIndex,futureHour&appkey=44524&sign=54dc62def4393a0d5cfe97a2a52646a6&format=json", name];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *sharedSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [sharedSession dataTaskWithRequest:request completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
        if (data) {
            NSMutableDictionary *secondDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSLog(@"success isEqualToString:1 = %i %@", [secondDictionary[@"success"] isEqualToString:@"1"], name);
            if ([secondDictionary[@"success"] isEqualToString:@"1"]) {
                self->a++;
                NSLog(@"a = %i", self->a);
            } else {
                [self->_cityArray removeObject:name];
                self->d++;
                NSLog(@"d = %i", self->d);
            }
             NSLog(@"after_cityArray.count = %lu", (unsigned long)self->_cityArray.count);
        }
        NSLog(@"_cityArray.count = %lu", self->_cityArray.count);
        NSLog(@"_cityArray = %@", self->_cityArray);
        if ((self->a + self->d) == self->_cityArray.count) {
            NSLog(@"if_cityArray.count = %lu", (unsigned long)self->_cityArray.count);
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self back];
                [self change];
            }];
        }
    }];
    [dataTask resume];
}

- (void)back {
    if (_scrollView.subviews) {
        [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    NSLog(@"add");
    i = (int)_cityArray.count;
    _scrollView.contentSize = CGSizeMake(W * i, H * 0.9);
    for (int j = 1; j < i + 1; j++) {
            WeatherView *view = [[WeatherView alloc] initWithFrame:CGRectMake(W * (j - 1), 0, W, H * 0.9) CityName:_cityArray[j - 1]];
            [_scrollView addSubview:view];
    }
    _pageControl.numberOfPages = i;
    
}

- (void)creatInit {
    WeatherView *view = [[WeatherView alloc] initWithFrame:CGRectMake(0, 0, W, H * 0.9) CityName:@"西安"];
    [_scrollView addSubview:view];
    [_cityArray addObject:@"西安"];
//    NSLog(@"cityArray = %@", _cityArray);
    _cityName = @"西安";
}

- (void)change {
//    NSLog(@"change");
//    NSInteger currentPage = _pageControl.currentPage;
    NSInteger currentPage = _num;
    CGPoint offset = _scrollView.contentOffset;
    offset.x = W * currentPage;
//    NSLog(@" _pageControl.currentPage = %ld",  (long)_pageControl.currentPage);
    [_scrollView setContentOffset:offset];
    
}

//左右切换view时
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int j;
    j = _scrollView.contentOffset.x / W ;
    _pageControl.currentPage = j;
}

- (void)cityArray:(NSMutableArray *)cityName show:(NSInteger)num {
    self->_num = num;
    a = 0;
    d = 0;
    int t;
    for (t = 0; t < _cityArray.count; t++) {
        [self confirm:_cityArray[t]];
    }
}


@end
