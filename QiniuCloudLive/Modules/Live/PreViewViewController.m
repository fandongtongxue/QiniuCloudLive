//
//  LiveViewController.m
//  Live
//
//  Created by 范东 on 16/8/9.
//  Copyright © 2016年 范东. All rights reserved.
//

#import "PreViewViewController.h"
#import "LiveManager.h"
#import <PLMediaStreamingKit/PLMediaStreamingKit.h>
#import "LiveViewController.h"

@interface PreViewViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate>

@property (nonatomic, strong) AVCaptureDevice *cameraCaptureDevice;
@property (nonatomic, strong) AVCaptureVideoDataOutput *cameraCaptureOutput;
@property (nonatomic, strong) AVCaptureAudioDataOutput *microphoneCaptureOutput;
@property (nonatomic, strong) AVCaptureSession *cameraCaptureSession;

@end

@implementation PreViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    [self getAVFoundationPermission];
    [self initSubviews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)initSubviews{
    
    UIView *backgroundView = [[UIView alloc]initWithFrame:self.view.bounds];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.5;
    [self.view addSubview:backgroundView];
    
    UIButton *liveBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, kScreenSizeHeight - 60, kScreenSizeWidth - 40, 40)];
    [liveBtn setTitle:@"开始直播" forState:UIControlStateNormal];
    [liveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [liveBtn setBackgroundColor:[UIColor blackColor]];
    liveBtn.layer.cornerRadius = 5;
    liveBtn.clipsToBounds = YES;
    [liveBtn addTarget:self action:@selector(toLiveVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:liveBtn];
    
    UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenSizeWidth - 40, 20, 40, 40)];
    [closeBtn setImage:[UIImage imageNamed:@"Live-Close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
}

- (void)close{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)toLiveVC{
    
    LiveViewController *liveVC = [[LiveViewController alloc]init];
    [self.navigationController pushViewController:liveVC animated:YES];
}

- (void)getAVFoundationPermission{
    if (!self.cameraCaptureSession) {
        void (^noPermission)(void) = ^{
            NSString *log = @"No camera permission.";
            DLOG(@"%@", log);
        };
        
        __weak typeof(self) wself = self;
        void (^permissionGranted)(void) = ^{
            __strong typeof(wself) strongSelf = wself;
            
            NSArray *devices = [AVCaptureDevice devices];
            for (AVCaptureDevice *device in devices) {
                if ([device hasMediaType:AVMediaTypeVideo] && AVCaptureDevicePositionFront == device.position) {
                    strongSelf.cameraCaptureDevice = device;
                    break;
                }
            }
            
            if (!strongSelf.cameraCaptureDevice) {
                NSString *log = @"No back camera found.";
                DLOG(@"%@", log);
                //            [self logToTextView:log];
                return ;
            }
            
            AVCaptureSession *captureSession = [[AVCaptureSession alloc] init];
            AVCaptureDeviceInput *input = nil;
            AVCaptureVideoDataOutput *output = nil;
            
            input = [[AVCaptureDeviceInput alloc] initWithDevice:strongSelf.cameraCaptureDevice error:nil];
            output = [[AVCaptureVideoDataOutput alloc] init];
            
            strongSelf.cameraCaptureOutput = output;
            
            [captureSession beginConfiguration];
            captureSession.sessionPreset = AVCaptureSessionPreset640x480;
            
            // setup output
            output.videoSettings = @{(NSString *)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)};
            
            dispatch_queue_t cameraQueue = dispatch_queue_create("com.pili.camera", 0);
            [output setSampleBufferDelegate:strongSelf queue:cameraQueue];
            
            // add input && output
            if ([captureSession canAddInput:input]) {
                [captureSession addInput:input];
            }
            
            if ([captureSession canAddOutput:output]) {
                [captureSession addOutput:output];
            }
            
            DLOG(@"%@", [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio]);
            
            // audio capture device
            AVCaptureDevice *microphone = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
            AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:microphone error:nil];
            AVCaptureAudioDataOutput *audioOutput = nil;
            
            if ([captureSession canAddInput:audioInput]) {
                [captureSession addInput:audioInput];
            }
            audioOutput = [[AVCaptureAudioDataOutput alloc] init];
            
            self.microphoneCaptureOutput = audioOutput;
            
            if ([captureSession canAddOutput:audioOutput]) {
                [captureSession addOutput:audioOutput];
            } else {
                DLOG(@"Couldn't add audio output");
            }
            
            dispatch_queue_t audioProcessingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
            [audioOutput setSampleBufferDelegate:self queue:audioProcessingQueue];
            
            [captureSession commitConfiguration];
            
            NSError *error;
            [strongSelf.cameraCaptureDevice lockForConfiguration:&error];
            //        strongSelf.cameraCaptureDevice.activeVideoMinFrameDuration = CMTimeMake(1.0, strongSelf.expectedSourceVideoFrameRate);
            //        strongSelf.cameraCaptureDevice.activeVideoMaxFrameDuration = CMTimeMake(1.0, strongSelf.expectedSourceVideoFrameRate);
            [strongSelf.cameraCaptureDevice unlockForConfiguration];
            
            strongSelf.cameraCaptureSession = captureSession;
            
            //        [strongSelf reorientCamera:AVCaptureVideoOrientationPortrait];
            
            AVCaptureVideoPreviewLayer* previewLayer;
            previewLayer =  [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
            previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            __weak typeof(strongSelf) wself1 = strongSelf;
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(wself1) strongSelf1 = wself1;
                previewLayer.frame = strongSelf1.view.layer.bounds;
                [strongSelf1.view.layer insertSublayer:previewLayer atIndex:0];
            });
            
            [strongSelf.cameraCaptureSession startRunning];
        };
        
        void (^requestPermission)(void) = ^{
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    permissionGranted();
                } else {
                    noPermission();
                }
            }];
        };
        
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (status) {
            case AVAuthorizationStatusAuthorized:
                permissionGranted();
                break;
            case AVAuthorizationStatusNotDetermined:
                requestPermission();
                break;
            case AVAuthorizationStatusDenied:
            case AVAuthorizationStatusRestricted:
            default:
                noPermission();
                break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden{
    return NO;
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
