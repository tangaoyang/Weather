//
//  ViewController.h
//  天气预报
//
//  Created by 唐傲洋 on 2019/8/10.
//  Copyright © 2019 cinderella. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManageViewController.h"

@interface ViewController : UIViewController
<
UIScrollViewDelegate,
manageDelegate
>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, strong) NSMutableArray *cityArray;

@end

