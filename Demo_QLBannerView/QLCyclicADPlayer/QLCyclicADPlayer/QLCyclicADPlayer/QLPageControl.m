//
//  QLPageControl.m
//  QLCyclicADPlayer
//
//  Created by 闫庆龙 on 15/4/22.
//  Copyright (c) 2015年 Shrek. All rights reserved.
//

#import "QLPageControl.h"

@implementation QLPageControl

- (void)setImagePageStateNormal:(UIImage *)image { // 设置正常状态点按钮的图片
    [self updateDots];
}

- (void)setImagePageStateHighlighted:(UIImage *)image { // 设置高亮状态点按钮图片
    _imagePageStateHighlighted = image;
    [self updateDots];
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event { // 点击事件
    [super endTrackingWithTouch:touch withEvent:event];
    [self updateDots];
}

- (void)updateDots { // 更新显示所有的点按钮
    if (_imagePageStateNormal || _imagePageStateHighlighted) {
        NSArray *subview = self.subviews; // 获取所有子视图
        for (NSInteger i = 0; i < [subview count]; i++) {
            UIImageView *dot = [subview objectAtIndex:i]; // 以下不解释, 看了基本明白
            dot.image = self.currentPage == i ? _imagePageStateNormal : _imagePageStateHighlighted;
        }
    }
}

@end
