//
//  MainViewController.m
//  生日快乐
//
//  Created by jp123 on 2017/4/25.
//  Copyright © 2017年 jp. All rights reserved.
//

#import "MainViewController.h"
#import "BaseViewController.h"
#import "BaseNavegationVC.h"
#import "TextViewController.h"
#define kUIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface MainViewController ()
@property (nonatomic, strong) TextViewController *homePageVC;
@property (nonatomic, strong) BaseViewController *freindVC;
@property (nonatomic, strong) BaseViewController *mineVC;
@property (nonatomic, strong) BaseViewController *promotionVC;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
}

//加载视图
- (void)setupSubviews
{
    self.homePageVC = [[TextViewController alloc] init];
    self.promotionVC = [[BaseViewController alloc] init];
    self.freindVC = [[BaseViewController alloc] init];
    self.mineVC = [[BaseViewController alloc] init];
    
    _homePageVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"homePage"] tag:1];
    _promotionVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"发现" image:[UIImage imageNamed:@"promotion"] tag:2];
    _freindVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"朋友" image:[UIImage imageNamed:@"friends"] tag:3];
    _mineVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[UIImage imageNamed:@"my"] tag:4];
    
    BaseNavegationVC *firstNC = [[BaseNavegationVC alloc] initWithRootViewController:_homePageVC];
    BaseNavegationVC *secondNC = [[BaseNavegationVC alloc] initWithRootViewController:_promotionVC];
    BaseNavegationVC *thirdNC = [[BaseNavegationVC alloc] initWithRootViewController:_freindVC];
    BaseNavegationVC *fourthNC = [[BaseNavegationVC alloc] initWithRootViewController:_mineVC];
    
    //把试图控制器包含在rootTBC中
    self.viewControllers = @[firstNC, secondNC, thirdNC, fourthNC];
    self.tabBar.barTintColor = [UIColor whiteColor];
    self.tabBar.selectedImageTintColor = kUIColorFromRGB(0xfb7caf);
    
    
}

@end
