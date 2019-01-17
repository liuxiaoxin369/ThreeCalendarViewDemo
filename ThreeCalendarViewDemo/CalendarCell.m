//
//  CalendarCell.m
//  ThreeCalendarViewDemo
//
//  Created by qzwh on 2018/5/3.
//  Copyright © 2018年 qzwh. All rights reserved.
//

#import "CalendarCell.h"

@implementation CalendarCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    [self.contentView addSubview:self.titleLabel];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
