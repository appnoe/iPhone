#import "AudioPlayerController.h"
#import "Medium.h"
#import "MeterView.h"
#import <AVFoundation/AVFoundation.h>

static const float kMinimalAmplitude = -160.0;

@interface AudioPlayerController()<AVAudioPlayerDelegate>

@property (nonatomic, weak) IBOutlet UIBarButtonItem *playButton;
@property (nonatomic, weak) IBOutlet UISlider *slider;
@property (nonatomic, weak) IBOutlet MeterView *meterView;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) NSTimer *updateTimer;
@property (nonatomic) BOOL loading;
@property (nonatomic) BOOL paused;

- (IBAction)stop;
- (IBAction)flipPlayback;
- (IBAction)startSearching;
- (IBAction)updatePosition;

- (IBAction)updateTimeLabel;

- (void)startTimer;
- (void)cancelTimer;
- (void)updateTime:(NSTimer *)inTimer;

@end

@implementation AudioPlayerController

- (void)dealloc {
    [self cancelTimer];
}

- (void)viewWillAppear:(BOOL)inAnimated {
    [super viewWillAppear:inAnimated];
    [self clear];
}

- (NSTimeInterval)time {
    return self.slider.value;
}

- (void)setTime:(NSTimeInterval)inTime {
    self.slider.value = inTime;
    self.audioPlayer.currentTime = inTime;
    [self updateTimeLabel];
}

- (BOOL)loading {
    return self.activityIndicator.isAnimating;
}

- (void)setLoading:(BOOL)inLoading {
    if(inLoading) {
        [self.activityIndicator startAnimating];
    }
    else {
        [self.activityIndicator stopAnimating];
    }
}

- (void)updatePlayButton {
    self.playButton.image = [UIImage imageNamed:self.paused ? @"play.png" : @"pause.png"]; 
}

- (void)startAudioPlayer {
    NSError *theError = nil;
    AVAudioPlayer *thePlayer = [[AVAudioPlayer alloc] initWithData:self.audioMedium.data error:&theError];
    
    self.audioPlayer = thePlayer;
    if(thePlayer == nil) {
        NSLog(@"playAudio: %@", theError);
        self.loading = NO;
    }
    else {
        thePlayer.delegate = self;
        thePlayer.meteringEnabled = YES;
        self.time = self.slider.value;
        self.slider.maximumValue = thePlayer.duration;
        self.loading = NO;
        [self updateTime:nil];
        [self startTimer];
        [thePlayer play];
    }
}

- (IBAction)stop {
    [self dismissAnimated:YES];
}

- (IBAction)flipPlayback {
    if(self.audioPlayer == nil) {
        self.loading = YES;
        [self performSelector:@selector(startAudioPlayer) withObject:nil afterDelay:0.0];
        self.paused = NO;
    }
    else if(self.audioPlayer.playing) {
        self.paused = YES;
        [self.audioPlayer pause];
    }
    else {
        self.paused = NO;
        [self.audioPlayer play];        
        [self startTimer];
    }
    [self updatePlayButton];
}

- (IBAction)startSearching {
    if(self.audioPlayer.playing) {
        [self.audioPlayer pause];
        self.paused = NO;
    }
}

- (IBAction)updatePosition {
    self.audioPlayer.currentTime = self.slider.value;
    if(!self.paused) {
        [self.audioPlayer play];
    }
}

- (IBAction)clear {
    self.paused = YES;
    [self.audioPlayer stop];
    self.audioPlayer = nil;
    [self.meterView clear];
    self.time = 0.0;
    [self updatePlayButton];
    [self updateTimeLabel];
}

- (IBAction)updateTimeLabel {
    self.timeLabel.text = [NSString stringWithFormat:@"%.0fs", self.slider.value];
}

- (void)startTimer {
    if(self.updateTimer == nil) {
        self.audioPlayer.meteringEnabled = YES;
        self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.25 
                                                            target:self 
                                                          selector:@selector(updateTime:) 
                                                          userInfo:nil 
                                                           repeats:YES];
    }
}

- (void)cancelTimer {
    [self.updateTimer invalidate];
    self.updateTimer = nil;
}

- (void)updateTime:(NSTimer *)inTimer {
    NSTimeInterval theTime = self.audioPlayer.currentTime;
    float theValue;
    
    [self.audioPlayer updateMeters];
    theValue = [self.audioPlayer averagePowerForChannel:0] - kMinimalAmplitude;
    self.meterView.value = theValue / -kMinimalAmplitude;
    self.slider.value = theTime;
    [self updateTimeLabel];
}

#pragma mark AVAudioPlayerDelegate

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)inPlayer error:(NSError *)inError {
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)inPlayer successfully:(BOOL)inFlag {
    [self cancelTimer];
    self.paused = YES;
    self.time = 0.0;
    [self.meterView clear];
    self.loading = NO;
    [self updatePlayButton];
}

@end
