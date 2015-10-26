//
//  QLAutoRollView.h
//  Demo_QLAutoRollView
//
//  Created by Shrek on 15/8/13.
//  Copyright (c) 2015年 M. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QLAutoRollView : UIView

@property (nonatomic, assign, getter = isAnimating) BOOL animating;
@property (nonatomic, assign, getter = hasStoped) BOOL stoped;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *textFont;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString*)title;

//- (void)start;//开始跑马
//- (void)stop;//停止跑马

@end
