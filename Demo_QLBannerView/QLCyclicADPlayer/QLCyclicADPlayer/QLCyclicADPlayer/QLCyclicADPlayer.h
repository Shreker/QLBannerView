//
//  QLCyclicADPlayer.h
//  QLCyclicADPlayer
//
//  Created by 闫庆龙 on 15/4/13.
//  Copyright (c) 2015年 Shrek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLCyclicADPlayerDelegate.h"

typedef NS_ENUM(NSUInteger, QLCyclicADPlayerPageControlAliment) {
    QLCyclicADPlayerPageControlAlimentLeft,
    QLCyclicADPlayerPageControlAlimentCenter,
    QLCyclicADPlayerPageControlAlimentRight,
};

typedef NS_ENUM(NSUInteger, QLCyclicADPlayerTitleAliment) {
    QLCyclicADPlayerTitleAlimentLeft,
    QLCyclicADPlayerTitleAlimentCenter,
    QLCyclicADPlayerTitleAlimentRight,
};

@interface QLCyclicADPlayer : UIView

@property (nonatomic, assign) CGFloat timeInterval; // 播放间隔时间
@property (nonatomic, assign) CGFloat animationInterval; // 播放动画时间

@property (nonatomic, weak) id<QLCyclicADPlayerDataSourceDelegate> dataSourceDelegate; // 数据源代理
@property (nonatomic, weak) id<QLCyclicADPlayerActionDelegate> actionDelegate; // 动作代理

/**
 *  加载数据
 */
- (void)reloadData;

@end
