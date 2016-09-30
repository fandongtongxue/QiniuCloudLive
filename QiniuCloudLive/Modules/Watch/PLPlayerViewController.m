//
//  PLPlayerViewController.m
//  PLPlayerKitDemo
//
//  Created by 0dayZh on 15/10/19.
//  Copyright © 2015年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "PLPlayerViewController.h"
#import <PLPlayerKit/PLPlayerKit.h>

#define enableBackgroundPlay    1

static NSString *status[] = {
    @"PLPlayerStatusUnknow",
    @"PLPlayerStatusPreparing",
    @"PLPlayerStatusReady",
    @"PLPlayerStatusCaching",
    @"PLPlayerStatusPlaying",
    @"PLPlayerStatusPaused",
    @"PLPlayerStatusStopped",
    @"PLPlayerStatusError"
};

@interface PLPlayerViewController ()
<
PLPlayerDelegate,
UITextViewDelegate
>
@property (nonatomic, strong) PLPlayer  *player;
@property (nonatomic, weak) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, assign) int reconnectCount;

@end

@implementation PLPlayerViewController

- (instancetype)initWithURL:(NSURL *)URL {
    self = [super init];
    if (self) {
        self.URL = URL;
        self.reconnectCount = 0;
    }
    return self;
}

- (void)setupUI {
    if (self.player.status != PLPlayerStatusError) {
        // add player view
        UIView *playerView = self.player.playerView;
        if (!playerView.superview) {
            playerView.contentMode = UIViewContentModeScaleAspectFit;
            playerView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin
            | UIViewAutoresizingFlexibleTopMargin
            | UIViewAutoresizingFlexibleLeftMargin
            | UIViewAutoresizingFlexibleRightMargin
            | UIViewAutoresizingFlexibleWidth
            | UIViewAutoresizingFlexibleHeight;
            [self.view addSubview:playerView];
            UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width - 50, 10, 40, 40)];
            [closeBtn setImage:[UIImage imageNamed:@"Player-Close"] forState:UIControlStateNormal];
            [closeBtn addTarget:self action:@selector(closePlayer) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:closeBtn];
        }
    }
    
}

- (void)closePlayer{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)startPlayer {
    [self addActivityIndicatorView];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    [self.player play];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    PLPlayerOption *option = [PLPlayerOption defaultOption];
    [option setOptionValue:@10 forKey:PLPlayerOptionKeyTimeoutIntervalForMediaPackets];
    
    self.player = [PLPlayer playerWithURL:self.URL option:option];
    self.player.delegate = self;
    self.player.delegateQueue = dispatch_get_main_queue();
    self.player.backgroundPlayEnable = enableBackgroundPlay;
#if !enableBackgroundPlay
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startPlayer) name:UIApplicationWillEnterForegroundNotification object:nil];
#endif
    [self setupUI];
    
    [self startPlayer];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)addActivityIndicatorView {
    if (self.activityIndicatorView) {
        return;
    }
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    [self.view addSubview:activityIndicatorView];
    [activityIndicatorView stopAnimating];
    
    self.activityIndicatorView = activityIndicatorView;
}

#pragma mark - <PLPlayerDelegate>

- (void)player:(nonnull PLPlayer *)player statusDidChange:(PLPlayerStatus)state {
    if (PLPlayerStatusCaching == state) {
        [self.activityIndicatorView startAnimating];
    } else {
        [self.activityIndicatorView stopAnimating];
    }
    DLOG(@"%@", status[state]);
}

- (void)player:(nonnull PLPlayer *)player stoppedWithError:(nullable NSError *)error {
    [self.activityIndicatorView stopAnimating];
    [self tryReconnect:error];
}

- (void)tryReconnect:(nullable NSError *)error {
    if (self.reconnectCount < 3) {
        _reconnectCount ++;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:[NSString stringWithFormat:@"错误 %@，播放器将在%.1f秒后进行第 %d 次重连", error.localizedDescription,0.5 * pow(2, self.reconnectCount - 1), _reconnectCount] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * pow(2, self.reconnectCount) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.player play];
        });
    }else {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                           message:error.localizedDescription
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            __weak typeof(self) wself = self;
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK"
                                                             style:UIAlertActionStyleCancel
                                                           handler:^(UIAlertAction *action) {
                                                               __strong typeof(wself) strongSelf = wself;
                                                               [strongSelf.navigationController performSelectorOnMainThread:@selector(popViewControllerAnimated:) withObject:@(YES) waitUntilDone:NO];
                                                           }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        [UIApplication sharedApplication].idleTimerDisabled = NO;
        DLOG(@"%@", error);
    }
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

@end
