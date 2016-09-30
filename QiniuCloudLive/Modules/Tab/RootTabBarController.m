//
//  RootTabBarController.m
//  Live
//
//  Created by 范东 on 16/8/11.
//  Copyright © 2016年 范东. All rights reserved.
//

#import "RootTabBarController.h"
#import "WatchViewController.h"
#import "StreamViewController.h"
#import "UserViewController.h"
#import "MoreViewController.h"
#import "RootNavigationController.h"

@interface RootTabBarController ()

@end

@implementation RootTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubVC];
}

- (void)initSubVC{
    UITabBarItem *watchItem = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemHistory tag:0];
    UITabBarItem *streamItem = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemRecents tag:1];
    UITabBarItem *userItem = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemContacts tag:2];
    UITabBarItem *moreItem = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemMore tag:3];
    
    WatchViewController *watchVC = [[WatchViewController alloc]init];
    RootNavigationController *watchNav = [[RootNavigationController alloc]initWithRootViewController:watchVC];
    watchVC.tabBarItem = watchItem;
    
    StreamViewController *streamVC = [[StreamViewController alloc]init];
    RootNavigationController *streamNav = [[RootNavigationController alloc]initWithRootViewController:streamVC];
    streamNav.tabBarItem = streamItem;
    
    UserViewController *userVC = [[UserViewController alloc]init];
    RootNavigationController *userNav = [[RootNavigationController alloc]initWithRootViewController:userVC];
    userNav.tabBarItem = userItem;
    
    MoreViewController *moreVC = [[MoreViewController alloc]init];
    RootNavigationController *moreNav = [[RootNavigationController alloc]initWithRootViewController:moreVC];
    moreNav.tabBarItem = moreItem;
    
    self.viewControllers = @[watchNav,streamNav,userNav,moreNav];
    
    self.selectedIndex = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
