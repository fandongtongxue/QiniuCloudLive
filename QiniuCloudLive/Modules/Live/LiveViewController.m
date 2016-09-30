//
//  LiveViewController.m
//  Live
//
//  Created by 范东 on 16/8/9.
//  Copyright © 2016年 范东. All rights reserved.
//

#import "LiveViewController.h"
#import <PLCameraStreamingKit/PLCameraStreamingKit.h>
#import "LiveManager.h"

@interface LiveViewController ()<PLCameraStreamingSessionDelegate>

@property (nonatomic, strong) PLCameraStreamingSession *session;

@end

@implementation LiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubViews];
    [self initSession];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)initSubViews{
    
    self.view.backgroundColor = [UIColor blackColor];
    
    UIButton *changeCameraBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, kScreenSizeHeight - 60, kScreenSizeWidth - 40, 40)];
    [changeCameraBtn setTitle:@"交换摄像头" forState:UIControlStateNormal];
    [changeCameraBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [changeCameraBtn setBackgroundColor:[UIColor blackColor]];
    changeCameraBtn.layer.cornerRadius = 5;
    changeCameraBtn.clipsToBounds = YES;
    [changeCameraBtn addTarget:self action:@selector(changeCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeCameraBtn];
    
    UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenSizeWidth - 40, 0, 40, 40)];
    [closeBtn setImage:[UIImage imageNamed:@"Live-Close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
}

- (void)initSession{
    __weak typeof(self) weakSelf = self;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[LiveManager manager] getRtmpAddresssuccessBlock:^(NSDictionary *responseDict) {
        PLStream *stream = [PLStream streamWithJSON:responseDict];
        
        PLVideoCaptureConfiguration *videoCaptureConfiguration = [PLVideoCaptureConfiguration defaultConfiguration];
        videoCaptureConfiguration.position = AVCaptureDevicePositionFront;
        PLAudioCaptureConfiguration *audioCaptureConfiguration = [PLAudioCaptureConfiguration defaultConfiguration];
        PLVideoStreamingConfiguration *videoStreamingConfiguration = [PLVideoStreamingConfiguration defaultConfiguration];
        PLAudioStreamingConfiguration *audioStreamingConfiguration = [PLAudioStreamingConfiguration defaultConfiguration];
        
        weakSelf.session = [[PLCameraStreamingSession alloc] initWithVideoCaptureConfiguration:videoCaptureConfiguration audioCaptureConfiguration:audioCaptureConfiguration videoStreamingConfiguration:videoStreamingConfiguration audioStreamingConfiguration:audioStreamingConfiguration stream:stream videoOrientation:AVCaptureVideoOrientationPortrait];
        
        weakSelf.session.delegate = self;
        
        [weakSelf.session setBeautifyModeOn:YES];
        [weakSelf.session setBeautify:0.5];
        [weakSelf.session setWhiten:0.5];
        [weakSelf.session setRedden:0.5];
        
        [weakSelf.view addSubview:self.session.previewView];
        [weakSelf.view sendSubviewToBack:self.session.previewView];
        [hud hideAnimated:YES];
        
        [weakSelf.session startWithCompleted:^(BOOL success) {
            if (success) {
                DLOG(@"Streaming started.");
            } else {
                DLOG(@"Oops.");
            }
        }];
    } failBlock:^(NSError *error) {
        [hud hideAnimated:YES];
        [weakSelf showAlert:[NSString stringWithFormat:@"%@",error]];
    }];
}

- (void)changeCamera{
    if (self.session.captureDevicePosition == AVCaptureDevicePositionFront) {
        self.session.captureDevicePosition = AVCaptureDevicePositionBack;
    }else{
        self.session.captureDevicePosition = AVCaptureDevicePositionFront;
    }
    
}

- (void)close{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.session destroy];
}

- (void)dealloc{
    [self.session destroy];
}

- (void)showAlert:(NSString *)alertString{
    if (IOS8_OR_LATER) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"直播信息" message:alertString preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alertVC dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:alertVC animated:YES completion:nil];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"直播信息" message:alertString delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}


- (BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma mark - PLCameraStreamingSessionDelegate

- (void)cameraStreamingSession:(PLCameraStreamingSession *)session streamStateDidChange:(PLStreamState)state{
    DLOG(@"流状态变更");
}

- (void)cameraStreamingSession:(PLCameraStreamingSession *)session streamStatusDidUpdate:(PLStreamStatus *)status{
    DLOG(@"流状态更新");
}

- (void)cameraStreamingSession:(PLCameraStreamingSession *)session didDisconnectWithError:(NSError *)error{
    DLOG(@"断开连接:%@",error);
}

- (void)cameraStreamingSession:(PLCameraStreamingSession *)session didGetCameraAuthorizationStatus:(PLAuthorizationStatus)status{
    DLOG(@"获取到CameraAuthorizationStatus:%ld",(long)status);
}

- (void)cameraStreamingSession:(PLCameraStreamingSession *)session didGetMicrophoneAuthorizationStatus:(PLAuthorizationStatus)status{
    DLOG(@"获取到MicrophoneAuthorizationStatus:%ld",(long)status);
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
