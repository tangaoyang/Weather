//
//  SearchViewController.h
//  天气预报
//
//  Created by cinderella on 2019/8/13.
//  Copyright © 2019 cinderella. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol searchDelegate <NSObject>

- (void)CityName:(NSString *)cityName add:(BOOL)add;

@end

@interface SearchViewController : UIViewController
<
UITextFieldDelegate,
UITableViewDelegate,
UITableViewDataSource,
NSURLSessionDelegate
>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSMutableArray *cityArray;
@property (nonatomic, strong) NSMutableArray *cityShowArray;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property id <searchDelegate> searchdelegate;

@end

NS_ASSUME_NONNULL_END
