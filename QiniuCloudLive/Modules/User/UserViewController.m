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

#define kCreateUserUrl @"http://fandong.me/App/QiniuCloudLive/pili-sdk-php-master/example/createUser.php"

@interface UserViewController ()<UIActionSheetDelegate,WeiboManagerDelegate>

@property (nonatomic, strong) UIImageView *userImageView;
@property (nonatomic, strong) UILabel *userNameLabel;

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
    if ([AppHelper isLogin]) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"退出登录" style:UIBarButtonItemStylePlain target:self action:@selector(toLogOut)];
    }else{
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(toLogin)];
    }
}

- (void)initSubViews{
    UIImageView *userImageView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenSizeWidth - 80)/2, 20, 80, 80)];
    [self.view addSubview:userImageView];
    self.userImageView = userImageView;
    UILabel *userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, userImageView.bottom + 10, kScreenSizeWidth - 40, 20)];
    userNameLabel.textColor = [UIColor blackColor];
    userNameLabel.font = [UIFont systemFontOfSize:15];
    userNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:userNameLabel];
    self.userNameLabel = userNameLabel;
    
    if ([AppHelper isLogin]) {
        [self.userNameLabel setText:[UserDefault objectForKey:kUserDefaultsKeyUserName]];
        [self.userImageView sd_setImageWithURL:[NSURL URLWithString:[UserDefault objectForKey:kUserDefaultsKeyUserImg]] placeholderImage:[UIImage imageNamed:@"uc_img_default.jpg"]];
    }else{
        [self.userNameLabel setText:@"未登录"];
        [self.userImageView setImage:[UIImage imageNamed:@"uc_img_default.jpg"]];
    }
    
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

- (void)toLogOut{
    [UserDefault saveBoolObject:NO ForKey:kUserDefaultsKeyUserIsLogin];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(toLogin)];
    [self.userNameLabel setText:@"未登录"];
    [self.userImageView setImage:[UIImage imageNamed:@"uc_img_default.jpg"]];
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
    NSDictionary *createDict = @{@"userId":userInfo[@"userID"],
                                          @"userAccessToken":userInfo[@"accessToken"],
                                          @"userExpirationDate":userInfo[@"expirationDate"],
                                          @"userLoginType":@"weibo"};
    [[BaseNetworking shareInstance] GET:kCreateUserUrl dict:createDict succeed:^(id data) {
        NSDictionary *dict = (NSDictionary *)data;
        if ([[dict objectForKey:@"status"] integerValue] == 1) {
            [self.userImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dict[@"data"][@"userImg"]]] placeholderImage:[UIImage imageNamed:@"uc_img_default.jpg"]];
            self.userNameLabel.text = [NSString stringWithFormat:@"%@",dict[@"data"][@"userName"]];
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"退出登录" style:UIBarButtonItemStylePlain target:self action:@selector(toLogOut)];
            [UserDefault saveBoolObject:YES ForKey:kUserDefaultsKeyUserIsLogin];
            [UserDefault saveObject:[NSString stringWithFormat:@"%@",dict[@"data"][@"userName"]] ForKey:kUserDefaultsKeyUserName];
            [UserDefault saveObject:[NSString stringWithFormat:@"%@",dict[@"data"][@"userImg"]] ForKey:kUserDefaultsKeyUserImg];
        }
    } failure:^(NSError *error) {
        [self showAlert:[NSString stringWithFormat:@"%@",error]];
    }];
}

- (void)showAlert:(id)alert{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@",alert] message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertVC dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
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
