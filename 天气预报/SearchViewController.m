//
//  SearchViewController.m
//  天气预报
//
//  Created by cinderella on 2019/8/13.
//  Copyright © 2019 cinderella. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImage *backImage = [UIImage imageNamed:@"image1.jpg"];
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:backImage];
    backImageView.frame = self.view.bounds;
    [self.view insertSubview:backImageView atIndex:0];
    
    _textField = [[UITextField alloc] init];
    _textField.delegate = self;
    _textField.frame = CGRectMake(50, 100, [UIScreen mainScreen].bounds.size.width - 100, 50);
    _textField.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_textField];
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    _textField.keyboardType = UIKeyboardTypeDefault;
    _textField.backgroundColor = [UIColor clearColor];
    _textField.textColor = [UIColor whiteColor];
    _textField.tintColor = [UIColor whiteColor];
    _textField.layer.masksToBounds = YES;
    _textField.layer.cornerRadius = 5;
    _textField.layer.borderWidth = 2;
    _textField.layer.borderColor = [UIColor whiteColor].CGColor;
    [self creatTableView];
    /*
    _backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:_backButton];
    _backButton.backgroundColor = [UIColor clearColor];
    _backButton.tintColor = [UIColor whiteColor];
    _backButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [_backButton setTitle:@"sure" forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    _backButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 100, 100, 100, 25);
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:_cancelButton];
    _cancelButton.backgroundColor = [UIColor clearColor];
    _cancelButton.tintColor = [UIColor whiteColor];
    _cancelButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [_cancelButton setTitle:@"cancel" forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchDown];
    _cancelButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 100, 125, 100, 25);
    */
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    NSLog(@"%@111", textField.text);
    [self creatUrl];
    _cityArray = [[NSMutableArray alloc] init];
    return YES;
}

- (void)creatUrl {
    //1.创建请求地址
    //汉语转拼音
    //可变字符串 必须是可变字符串.
//    NSMutableString *mutableString = [NSMutableString stringWithString:_textField.text];
//    //转成带声调的拼音
//    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
//    //转成没有声调的拼音
//    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformStripDiacritics, false);
//    NSString *newstr = [mutableString stringByReplacingOccurrencesOfString:@" " withString:@""];
//    NSLog(@"%@", newstr);
    NSString *urlString = [NSString stringWithFormat:@"https://search.heweather.com/find?location=%@&key=71f533964a994355bb1abfccb161d241", _textField.text];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://search.heweather.com/find?location=%@&key=71f533964a994355bb1abfccb161d241", newstr]];
//    NSLog(@"%@", [NSString stringWithFormat:@"https://search.heweather.com/find?location=%@&key=71f533964a994355bb1abfccb161d241", newstr]);
    //2.创建请求类
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //3.创建会话
    //delegateQueue 表示协议方法在哪个线程中执行
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self  delegateQueue:[NSOperationQueue mainQueue]];
    //4.根据会话创建任务
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];
    //5.启动任务
    [dataTask resume];
    
    
}
//接收服务器的响应
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
//    NSLog(@"didReceiveResponse");
    
    if(self.data == nil){
        self.data = [[NSMutableData alloc] init];
    } else {
        self.data.length = 0;
    }
    
    completionHandler(NSURLSessionResponseAllow);
}
//接收到数据，该方法会被调用多次
- (void)URLSession:(NSURLSession *)session dataTask:( NSURLSessionDataTask *)dataTask didReceiveData:( NSData *)data {
//    NSLog(@"didReceiveData");
    
    [self.data appendData:data];
}
//数据请求完成或者请求出现错误调用的方法
- (void)URLSession:(NSURLSession *)session task:( NSURLSessionTask *)task didCompleteWithError:( NSError *)error {
//    NSLog(@"didCompleteWithError");
    if (error == nil) {
        //解析数据
        NSDictionary *secondDictionary = [NSJSONSerialization JSONObjectWithData:_data options:kNilOptions error:nil];
        NSMutableArray *timeArray = [[NSMutableArray alloc] init];
        timeArray = secondDictionary[@"HeWeather6"][0][@"basic"];
        for (int i = 0; i < timeArray.count; i++) {
            NSMutableString *str = [NSMutableString stringWithFormat:@"%@",timeArray[i][@"location"]];
            [_cityArray addObject: str];
        }
//        for (int i = 0; i < _cityArray.count; i++) {
//            NSLog(@"%@", _cityArray[i]);
//        }
//        NSLog(@"-----------over");
    }
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self->_tableView reloadData];
    }];
    
}

- (void)creatTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 150, [UIScreen mainScreen].bounds.size.width, 500) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"111"];
    UIView *view = [[UIView alloc] init];
    _tableView.tableFooterView = view;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"111" forIndexPath:indexPath];
    while ([cell.contentView.subviews lastObject] != nil) {
        [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    cell.textLabel.text = _cityArray[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:20];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cityArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 25;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_textField endEditing:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _textField.text = _cityArray[indexPath.row];
    int i;
    for (i = 0; i < _cityShowArray.count; i++) {
        if ([_cityShowArray[i] isEqualToString:_textField.text]) {
            break;
        }
    }
    if (i == _cityShowArray.count) {
        if ([_searchdelegate respondsToSelector:@selector(CityName:add:)]) {
            [_searchdelegate CityName:_textField.text add:YES];
        }
        [self dismissViewControllerAnimated:NO completion:nil];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"已经有该城市！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"sure" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:sureAction];
        [self presentViewController:alert animated:NO completion:nil];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return YES;
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
