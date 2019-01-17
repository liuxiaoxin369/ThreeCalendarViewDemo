//
//  ViewController.m
//  ThreeCalendarViewDemo
//
//  Created by qzwh on 2018/5/3.
//  Copyright © 2018年 qzwh. All rights reserved.
//

#import "ViewController.h"
#import "ThreeCalendarView.h"

@interface ViewController ()
@property (nonatomic, strong) ThreeCalendarView *calendarView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.calendarView = [[ThreeCalendarView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 450)];
    [self.view addSubview:self.calendarView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(50, 50, 50, 30);
    button.backgroundColor = [UIColor orangeColor];
    [button setTitle:@"今天" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(handleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)handleBtnAction:(UIButton *)sender {
    self.calendarView.showDate = [NSDate date];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
