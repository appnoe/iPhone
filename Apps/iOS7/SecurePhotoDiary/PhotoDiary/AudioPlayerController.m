#import "AudioPlayerController.h"
#import "Medium.h"
#import "MeterView.h"
#import "UIViewController+PhotoDiary.h"
#import <AVFoundation/AVFoundation.h>

@interface AudioPlayerController()<AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) NSTimer *updateTimer;
@property (nonatomic) BOOL loading;
@property (nonatomic) BOOL paused;

- (void)startTimer;
- (void)cancelTimer;
- (void)updateTime:(NSTimer *)inTimer;

@end

@implementation AudioPlayerController

@synthesize playButton;
@synthesize slider;
@synthesize meterView;
@synthesize timeLabel;
@synthesize activityIndicator;

@synthesize audioMedium;
@synthesize audioPlayer;
@synthesize paused;
@synthesize updateTimer;

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
    
    if(thePlayer == nil) {
        NSLog(@"playAudio: %@", theError);
        self.loading = NO;
    }
    else {
        self.audioPlayer = thePlayer;
        thePlayer.delegate = self;
        thePlayer.meteringEnabled = YES;
        self.time = slider.value;
        self.slider.maximumValue = thePlayer.duration;
        self.loading = NO;
        [self updateTime:nil];
        [self startTimer];
        [thePlayer play];
    }
}

- (IBAction)stop {
    [self dismissSubviewAnimated:YES];
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
    self.audioPlayer.currentTime = slider.value;
    if(!self.paused) {
        [self.audioPlayer play];
    }
}

- (IBAction)clear {
    // TODO
    [self.audioPlayer stop];
    self.audioPlayer = nil;
    [self.meterView clear];
    self.time = 0.0;
    [self updatePlayButton];
}

- (IBAction)updateTimeLabel {
    timeLabel.text = [NSString stringWithFormat:@"%.0fs", slider.value];    
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
    
    [self.audioPlayer updateMeters];
    self.meterView.value = [self.audioPlayer averagePowerForChannel:0];
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
