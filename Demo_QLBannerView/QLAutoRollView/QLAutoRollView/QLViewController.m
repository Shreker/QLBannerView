//
//  QLViewController.m
//  Demo_QLAutoRollView
//
//  Created by Shrek on 15/8/13.
//  Copyright (c) 2015年 M. All rights reserved.
//

#import "QLViewController.h"
#import "QLAutoRollView.h"

@interface QLViewController ()
{
    QLAutoRollView *_autoRollView;
}

@end

@implementation QLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString* text = @"两块钱,你买不了吃亏,两块钱,你买不了上当,真正的物有所值,拿啥啥便宜,买啥啥不贵,都两块,买啥都两块,全场卖两块,随便挑,随便选,都两块！";
    
    QLAutoRollView *autoRollView = [[QLAutoRollView alloc] initWithFrame:CGRectMake(10, 64, self.view.bounds.size.width-20, 44) title:text];
    [self.view addSubview:autoRollView];
    _autoRollView = autoRollView;
    autoRollView.backgroundColor = [UIColor whiteColor];
    autoRollView.textColor = [UIColor orangeColor];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    _autoRollView.stoped = !_autoRollView.hasStoped;
}

@end
