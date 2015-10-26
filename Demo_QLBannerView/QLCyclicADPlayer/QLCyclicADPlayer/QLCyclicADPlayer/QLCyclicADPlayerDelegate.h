//
//  QLCyclicADPlayerDelegate.h
//  QLCyclicADPlayer
//
//  Created by 闫庆龙 on 15/4/19.
//  Copyright (c) 2015年 Shrek. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QLCyclicADPlayer;

@protocol QLCyclicADPlayerActionDelegate <NSObject>

@optional
- (void)cyclicADPlayer:(QLCyclicADPlayer *)cyclicADPlayer DidClickAtIndex:(NSUInteger)index;

@end

@protocol QLCyclicADPlayerDataSourceDelegate <NSObject>

@required
- (NSUInteger)numberOfPagesInCyclicADPlayer:(QLCyclicADPlayer *)cyclicADPlayer;
- (NSURL *)cyclicADPlayer:(QLCyclicADPlayer *)cyclicADPlayer UrlAtIndex:(NSUInteger)index;

@optional
- (NSString *)cyclicADPlayer:(QLCyclicADPlayer *)cyclicADPlayer TitleAtIndex:(NSUInteger)index;

@end
