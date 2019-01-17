//
//  CalendarView.m
//  ThreeCalendarViewDemo
//
//  Created by qzwh on 2018/5/3.
//  Copyright © 2018年 qzwh. All rights reserved.
//

#import "CalendarView.h"
#import "CalendarCell.h"

@interface CalendarView ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dateArr;
@end

@implementation CalendarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    [self addSubview:self.collectionView];
}

- (void)setDateStr:(NSString *)dateStr {
    _dateStr = dateStr;
    
    //清空上次数据
    [self.dateArr removeAllObjects];
    
    NSInteger dayCount = [self getDayForDate:[self dateForString:dateStr]];
    NSInteger week = [self getWeekForDate:[self dateForString:dateStr]];
    NSInteger lastDayCount = [self getDayForLastMonth:[self dateForString:dateStr]];
    
    //上月天数
    for (NSInteger i = week-2; i >= 0; i--) {
        [self.dateArr addObject:@{@"isEnable":@(NO), @"title":@(lastDayCount-i)}];
    }
    
    //本月天数
    for (int i = 0; i < dayCount; i++) {
        [self.dateArr addObject:@{@"isEnable":@(YES), @"title":@(i+1), @"date":[NSString stringWithFormat:@"%@%02d日", dateStr, i+1]}];
    }
    
    //下月天数
    NSInteger nextDayCount = 42 - dayCount - week + 1;
    for (int i = 0; i < nextDayCount; i++) {
        [self.dateArr addObject:@{@"isEnable":@(NO), @"title":@(i+1)}];
    }
    
    [self.collectionView reloadData];
}

//MARK:UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dateArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CalendarCell" forIndexPath:indexPath];
    NSDictionary *dic = self.dateArr[indexPath.row];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@", dic[@"title"]];
    if ([dic[@"isEnable"] boolValue]) {
        cell.titleLabel.textColor = [UIColor blackColor];
        cell.userInteractionEnabled = YES;
    } else {
        cell.titleLabel.textColor = [UIColor lightGrayColor];
        cell.userInteractionEnabled = NO;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dateArr[indexPath.row];
    NSLog(@"%@", dic);
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(self.frame.size.width/7, self.frame.size.height/6);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = NO;
        
        [_collectionView registerClass:[CalendarCell class] forCellWithReuseIdentifier:@"CalendarCell"];
    }
    return _collectionView;
}

- (NSMutableArray *)dateArr {
    if (!_dateArr) {
        _dateArr = [NSMutableArray array];
    }
    return _dateArr;
}

//MARK:custom method
//获取本月的天数
- (NSInteger)getDayForDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay
                                   inUnit:NSCalendarUnitMonth
                                  forDate:date];
    return range.length;
}

//本月第一天星期几
- (NSInteger)getWeekForDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger week = [calendar components:NSCalendarUnitWeekday fromDate:date].weekday;
    return week; //特殊处理周日的情况
}

//获取上月的天数
- (NSInteger)getDayForLastMonth:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *lastMonthComps = [[NSDateComponents alloc] init];
    [lastMonthComps setMonth:-1];
    NSDate *lastDate = [calendar dateByAddingComponents:lastMonthComps toDate:date options:0];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay
                                   inUnit:NSCalendarUnitMonth
                                  forDate:lastDate];
    return range.length;
}


- (NSDate *)dateForString:(NSString *)str {
    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyy年MM月"];
    NSDate *inputDate = [inputFormatter dateFromString:str];
    return inputDate;
}

@end
