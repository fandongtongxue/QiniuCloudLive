//
//  UserViewController.m
//  Live
//
//  Created by 范东 on 16/8/11.
//  Copyright © 2016年 范东. All rights reserved.
//

#import "UserViewController.h"
#import "WeiboManager.h"
#import "NetworkManager.h"

@interface UserViewController ()<UIActionSheetDelegate,WeiboManagerDelegate>

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavigationBar];
    [self initSubViews];
}

- (void)initNavigationBar{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"个人中心";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(toLogin)];
}

- (void)initSubViews{
    
}

- (void)toLogin{
    if (IOS8_OR_LATER) {
        UIAlertController *alertVC = [[UIAlertController alloc]init];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"新浪微博" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self login:SocialLoginTypeWeibo];
        }]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alertVC dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:alertVC animated:YES completion:nil];
    }else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"新浪微博",nil];
        [actionSheet showInView:self.view];
    }
}

- (void)login:(SocialLoginType)type{
    switch (type) {
        case SocialLoginTypeWeibo:
            [SocialManager manager].loginType = SocialLoginTypeWeibo;
            [[SocialManager manager] loginFromViewController:self Successed:nil failed:nil];
            break;
            
        default:
            break;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [self login:SocialLoginTypeWeibo];
            break;
        default:
            break;
    }
}

- (void)weiboManager:(WeiboManager *)manager userInfo:(NSDictionary *)userInfo{
//    {
//        accessToken = "2.00r92YuBwniE6B0d2405255f0WN7O1";
//        expirationDate = "2021-08-14 02:58:32 +0000";
//        userID = 1751793313;
//    }
    [WBHttpRequest requestForUserProfile:userInfo[@"userID"] withAccessToken:userInfo[@"accessToken"] andOtherProperties:nil queue:nil withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
        DLOG(@"微博用户信息:%@",result);
    }];
}

- (void)showAlert:(NSString *)alertString{
    if (IOS8_OR_LATER) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"微博信息" message:alertString preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alertVC dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:alertVC animated:YES completion:nil];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"微博信息" message:alertString delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
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
