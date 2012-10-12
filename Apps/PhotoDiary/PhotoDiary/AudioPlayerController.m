#import "AudioPlayerController.h"
#import "Medium.h"
#import "MeterView.h"
#import "UIToolbar+Extensions.h"
#import <AVFoundation/AVFoundation.h>

@interface AudioPlayerController()<AVAudioPlayerDelegate>

@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property (nonatomic) BOOL paused;
@property (nonatomic, retain) NSTimer *updateTimer;
@property (nonatomic) BOOL loading;

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
@synthesize toolbar;

@synthesize audioMedium;
@synthesize audioPlayer;
@synthesize paused;
@synthesize updateTimer;

- (void)dealloc {
    self.audioMedium = nil;
    self.audioPlayer = nil;
    self.playButton = nil;
    self.slider = nil;
    self.meterView = nil;
    self.timeLabel = nil;
    self.toolbar = nil;
    self.activityIndicator = nil;
    [self cancelTimer];
    [super dealloc];
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
        [self.toolbar setEnabled:NO];
    }
    else {
        [self.activityIndicator stopAnimating];
        [self.toolbar setEnabled:YES];
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
    [thePlayer release];
}

- (IBAction)stop {
    [self setVisible:NO animated:YES];
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
    [super clear];
    [self.audioPlayer stop];
    self.audioPlayer = nil;
    [meterView clear];
    self.time = 0.0;
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
