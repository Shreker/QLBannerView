//
//  QLAutoRollView.m
//  Demo_QLAutoRollView
//
//  Created by Shrek on 15/8/13.
//  Copyright (c) 2015年 M. All rights reserved.
//

#import "QLAutoRollView.h"

@implementation QLAutoRollView
{
    CGRect _rectMark1;//标记第一个位置
    CGRect _rectMark2;//标记第二个位置
    NSMutableArray *_arrMLabels;
    NSTimeInterval _timeInterval;//时间
    
    UIColor *_textColor;
    UIFont *_textFont;
}

- (UIColor *)textColor {
    if (!_textColor) {
        _textColor = [UIColor blackColor];
    }
    return _textColor;
}
- (UIFont *)textFont {
    if (!_textFont) {
        _textFont = [UIFont systemFontOfSize:15];
    }
    return _textFont;
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString*)title {
    if (self = [super initWithFrame:frame]) {
        title = [NSString stringWithFormat:@"  %@  ",title];//间隔
        _timeInterval = title.length / 5;
        
        self.backgroundColor = [UIColor orangeColor];
        self.clipsToBounds = YES;
        
        UILabel* textLb = [[UILabel alloc] initWithFrame:CGRectZero];
        textLb.textColor = self.textColor;
        textLb.font = self.textFont;
        textLb.text = title;
        
        //计算textLb大小
        CGSize sizeOfText = [textLb sizeThatFits:CGSizeZero];
        
        _rectMark1 = CGRectMake(0, 0, sizeOfText.width, self.bounds.size.height);
        _rectMark2 = CGRectMake(_rectMark1.origin.x+_rectMark1.size.width, 0, sizeOfText.width, self.bounds.size.height);
        
        textLb.frame = _rectMark1;
        [self addSubview:textLb];
        
        _arrMLabels = [NSMutableArray arrayWithObject:textLb];
        
        //判断是否需要reserveTextLb
        BOOL useReserve = sizeOfText.width > frame.size.width;
        
        if (useReserve) {
            UILabel* reserveTextLb = [[UILabel alloc] initWithFrame:_rectMark2];
            reserveTextLb.textColor = self.textColor;
            reserveTextLb.font = self.textFont;
            reserveTextLb.text = title;
            [self addSubview:reserveTextLb];
            [_arrMLabels addObject:reserveTextLb];
            [self autoRollAnimate];
        }
    }
    return self;
}

- (void)autoRollAnimate{
    if (!_stoped) {
        UILabel *label0 = _arrMLabels[0];
        UILabel *label1 = _arrMLabels[1];
        
        [UIView transitionWithView:self duration:_timeInterval options:UIViewAnimationOptionCurveLinear animations:^{
            label0.frame = CGRectMake(-_rectMark1.size.width, 0, _rectMark1.size.width, _rectMark1.size.height);
            label1.frame = CGRectMake(label0.frame.origin.x+label0.frame.size.width, 0, label1.frame.size.width, label1.frame.size.height);
        } completion:^(BOOL finished) {
            label0.frame = _rectMark2;
            label1.frame = _rectMark1;
            [_arrMLabels replaceObjectAtIndex:0 withObject:label1];
            [_arrMLabels replaceObjectAtIndex:1 withObject:label0];
            [self autoRollAnimate];
        }];
    }
}

- (void)setAnimating:(BOOL)animating {
    _animating = animating;
    if (_animating && _stoped) {
        UILabel* lbindex0 = _arrMLabels[0];
        UILabel* lbindex1 = _arrMLabels[1];
        lbindex0.frame = _rectMark2;
        lbindex1.frame = _rectMark1;
        
        [_arrMLabels replaceObjectAtIndex:0 withObject:lbindex1];
        [_arrMLabels replaceObjectAtIndex:1 withObject:lbindex0];
        
        [self autoRollAnimate];
    }
}
- (void)setStoped:(BOOL)stoped {
    _stoped = stoped;
    if (!_stoped) {
        [self autoRollAnimate];
    }
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    for (UILabel *label in _arrMLabels) {
        label.textColor = textColor;
    }
}
- (void)setTextFont:(UIFont *)textFont {
    _textFont = textFont;
    for (UILabel *label in _arrMLabels) {
        label.font = textFont;
    }
}

@end
