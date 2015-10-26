//
//  QLViewController.m
//  Demo_QLCyclicADPLayer
//
//  Created by 闫庆龙 on 15/4/13.
//  Copyright (c) 2015年 Shrek. All rights reserved.
//

#import "QLViewController.h"

#import "QLCyclicADPlayer.h"

@interface QLViewController () <QLCyclicADPlayerDataSourceDelegate, QLCyclicADPlayerActionDelegate>
{
    __weak QLCyclicADPlayer *_cyclicAdPlayer;
}

@end

@implementation QLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"QLCyclicADPlayer";
    
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    QLCyclicADPlayer *cyclicAdPlayer = [[QLCyclicADPlayer alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    cyclicAdPlayer.dataSourceDelegate = self;
    cyclicAdPlayer.actionDelegate = self;
    [self.view addSubview:cyclicAdPlayer];
    _cyclicAdPlayer = cyclicAdPlayer;
    
    UIButton *btnTest = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [btnTest addTarget:self action:@selector(jump) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnTest];
}

- (void)jump {
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor orangeColor];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - QLCyclicADPlayerDataSourceDelegate
- (NSUInteger)numberOfPagesInCyclicADPlayer:(QLCyclicADPlayer *)cyclicADPlayer {
    return 4;
}
- (NSURL *)cyclicADPlayer:(QLCyclicADPlayer *)cyclicADPlayer UrlAtIndex:(NSUInteger)index {
    return [[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"image%li", index] withExtension:@"png"];
}

#pragma mark - QLCyclicADPlayerActionDelegate
- (void)cyclicADPlayer:(QLCyclicADPlayer *)cyclicADPlayer DidClickAtIndex:(NSUInteger)index {
    NSLog(@"%s~%@", __FUNCTION__, @(index));
}

- (void)viewWillAppear:(BOOL)animated {
//    [_cyclicAdPlayer startCyclicADPlayer];
}
- (void)viewWillDisappear:(BOOL)animated {
//    [_cyclicAdPlayer pauseCyclicADPlayer];
}

@end
