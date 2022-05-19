
#import "PNSBackgroundView.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImageView+WebCache.h"

@interface PNSBackgroundView ()
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@end

@implementation PNSBackgroundView

- (void)show {
    // 构建 GIF 背景
    self.imgView = [self buildGIFViewWithUrl:self.gifUrl color:UIColor.blackColor];
    if (self.imgView) {
        [self addSubview:self.imgView];
    }
    // 构建 video 背景
    self.playerLayer = [self buildVideoViewWithUrl:self.videoUrl color:UIColor.blackColor];
    if (self.playerLayer) {
        //设置 session 防止切断系统其他声音
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
        [self.layer addSublayer:self.playerLayer];
        [self.playerLayer.player play]; //开始播放
        //注册播放完通知，实现循环播放
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playbackFinished:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:self.playerLayer.player.currentItem];
    }
}

- (void)playbackFinished:(NSNotification *)notification {
    [self.playerLayer.player seekToTime:CMTimeMake(0, 1)];
    [self.playerLayer.player play];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.playerLayer.frame = self.bounds;
    self.imgView.frame = self.bounds;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIImageView *)buildGIFViewWithUrl:(NSURL *)url color:(UIColor *)color {
    if (url == nil) { return nil; }
    UIImageView *view = [[UIImageView alloc] init];
    view.contentMode = UIViewContentModeScaleAspectFill;
    [view sd_setImageWithURL:url];
    if (color) {
        view.backgroundColor = color;
    }
    return view;
}

- (AVPlayerLayer *)buildVideoViewWithUrl:(NSURL *)url color:(UIColor *)color {
    if (url == nil) { return nil; }
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:url];
    AVPlayer *player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    player.muted = YES;
    AVPlayerLayer *playLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    if (color) {
        playLayer.backgroundColor = color.CGColor;
    }
    return playLayer;
}

@end
