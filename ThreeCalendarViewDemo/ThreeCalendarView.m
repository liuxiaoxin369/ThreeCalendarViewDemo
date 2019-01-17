//
//  ThreeCalendarView.m
//  ThreeCalendarViewDemo
//
//  Created by qzwh on 2018/5/3.
//  Copyright © 2018年 qzwh. All rights reserved.
//

#import "ThreeCalendarView.h"
#import "CalendarView.h"

#define kScreenWidth    [UIScreen mainScreen].bounds.size.width

@interface ThreeCalendarView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) CalendarView *leftView;
@property (nonatomic, strong) CalendarView *centerView;
@property (nonatomic, strong) CalendarView *rightView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation ThreeCalendarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
        //添加数据
        [self addData];
    }
    return self;
}

- (void)createUI {
    [self addSubview:self.scrollView];
    [self addSubview:self.titleLabel];
    
    CGFloat x = 0;
    CGFloat width = kScreenWidth/7;
    NSArray *weekArr = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    for (int i = 0; i < weekArr.count; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, 50, width, 50)];
        label.text = weekArr[i];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        
        x += width;
    }
    
    [self.scrollView addSubview:self.leftView];
    [self.scrollView addSubview:self.centerView];
    [self.scrollView addSubview:self.rightView];
    
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)addData {
    for (int i = 0; i <= 100; i++) {
        for (int j = 0; j < 12; j++) {
            NSString *dateStr = [NSString stringWithFormat:@"%d年%02d月", i+1968, j+1];
            [self.dataSource addObject:dateStr];
        }
    }
    
    //初始化
    NSDate *currentDate = [NSDate date];
    self.showDate = currentDate;
}

- (void)setShowDate:(NSDate *)showDate {
    _showDate = showDate;
    
    //获取当前日期
    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyy年MM月"];
    NSString *dateStr = [inputFormatter stringFromDate:_showDate];
    //初始化数据
    self.currentIndex = [self.dataSource indexOfObject:dateStr];
}

//MARK:KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self caculateCurrentIndex];
    }
}

//使scrollView始终处于中间位置
- (void)setScrollViewContentOffsetCenter {
    self.scrollView.contentOffset = CGPointMake(kScreenWidth, 0);
}

//计算当前展示视图的下标
- (void)caculateCurrentIndex {
    if (self.dataSource && self.dataSource.count > 0) {
        CGFloat pointX = self.scrollView.contentOffset.x;
        //这里分五种情况
        if (pointX == 0 && self.currentIndex == 0) {
            self.currentIndex = 0;
        } else if (pointX == kScreenWidth && self.currentIndex == 0) {
            self.currentIndex = 1;
        } else if (pointX == 2 * kScreenWidth && self.currentIndex == self.dataSource.count-1) {
            self.currentIndex = self.dataSource.count - 1;
        } else if (pointX == kScreenWidth && self.currentIndex == self.dataSource.count - 1) {
            self.currentIndex = self.dataSource.count - 2;
        } else {
            if (pointX == 2 * kScreenWidth) {
                self.currentIndex = (self.currentIndex + 1) % self.dataSource.count;
            } else if (pointX == 0) {
                self.currentIndex = (self.currentIndex + self.dataSource.count - 1) % self.dataSource.count;
            }
        }
    }
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    
    if (_currentIndex == 0) {
        self.leftView.dateStr = self.dataSource[0];
        self.centerView.dateStr = self.dataSource[1];
        self.rightView.dateStr = self.dataSource[2];
    } else if (currentIndex > 0 && currentIndex < self.dataSource.count-1) {
        
        NSInteger dataCount = self.dataSource.count;
        NSInteger leftIndex = (currentIndex + dataCount - 1) % dataCount;
        NSInteger rightIndex = (currentIndex + 1) % dataCount;
        
        self.leftView.dateStr = self.dataSource[leftIndex];
        self.centerView.dateStr = self.dataSource[currentIndex];
        self.rightView.dateStr = self.dataSource[rightIndex];
        
        [self setScrollViewContentOffsetCenter];
    }
    
    self.titleLabel.text = self.dataSource[currentIndex];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, self.frame.size.height-100)];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(kScreenWidth*3, self.frame.size.height-100);
    }
    return _scrollView;
}

- (CalendarView *)leftView {
    if (!_leftView) {
        _leftView = [[CalendarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.scrollView.frame.size.height)];
    }
    return _leftView;
}

- (CalendarView *)centerView {
    if (!_centerView) {
        _centerView = [[CalendarView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, self.scrollView.frame.size.height)];
    }
    return _centerView;
}

- (CalendarView *)rightView {
    if (!_rightView) {
        _rightView = [[CalendarView alloc] initWithFrame:CGRectMake(kScreenWidth*2, 0, kScreenWidth, self.scrollView.frame.size.height)];
    }
    return _rightView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
