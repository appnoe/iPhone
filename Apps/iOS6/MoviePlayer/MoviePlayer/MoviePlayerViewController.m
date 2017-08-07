//
//  MoviePlayerViewController.m
//  MoviePlayer
//
//  Created by Clemens Wagner on 09.06.13.
//  Copyright (c) 2013 Clemens Wagner. All rights reserved.
//

#import "MoviePlayerViewController.h"
#import "UIViewController+MoviePlayer.h"
#import "BookmarksViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface MoviePlayerViewController ()<BookmarksViewControllerDelegate>

@property (nonatomic, strong) MPMoviePlayerController *moviePlayerController;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addBookmarkButton;
@property (nonatomic) BOOL resume;

@end

@implementation MoviePlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSNotificationCenter *theCenter = [NSNotificationCenter defaultCenter];
    NSURL *theURL = [[NSBundle mainBundle] URLForResource:@"elephants-dream" withExtension:@"mp4"];
    MPMoviePlayerController *theController = [[MPMoviePlayerController alloc] initWithContentURL:theURL];

    self.addBookmarkButton.enabled = NO;
    self.moviePlayerController = theController;
    [theController prepareToPlay];
    theController.shouldAutoplay = NO;
    theController.view.frame = self.view.bounds;
    theController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:theController.view];
    [theCenter addObserver:self selector:@selector(moviePlayerLoadStateDidChange:) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
}

- (void)viewWillAppear:(BOOL)inAnimated {
    [super viewWillAppear:inAnimated];
    if(self.resume) {
        [self.moviePlayerController play];
    }
}

- (void)viewWillDisappear:(BOOL)inAnimated {
    self.resume = self.moviePlayerController.playbackState == MPMoviePlaybackStatePlaying;
    [self.moviePlayerController pause];
    [super viewWillDisappear:inAnimated];
}

- (IBAction)addBookmark {
    NSTimeInterval theTime = self.moviePlayerController.currentPlaybackTime;

    [self addBookmarkWithTime:theTime];
}

- (void)prepareForSegue:(UIStoryboardSegue *)inSegue sender:(id)inSender {
    id theController = inSegue.destinationViewController;

    if([theController respondsToSelector:@selector(setDelegate:)]) {
        [theController setDelegate:self];
    }
}

#pragma mark MPMoviePlayerController notifications

- (void)moviePlayerLoadStateDidChange:(NSNotification *)inNotification {
    MPMoviePlayerController *theController = inNotification.object;
    MPMovieLoadState theState = theController.loadState;
    
    self.addBookmarkButton.enabled = (theState & (MPMovieLoadStatePlayable | MPMovieLoadStatePlaythroughOK)) != 0;
}

#pragma mark BookmarksViewControllerDelegate

- (void)bookmarksViewController:(BookmarksViewController *)inController needsImageAtTime:(NSTimeInterval)inTime {
    [self.moviePlayerController requestThumbnailImagesAtTimes:@[@(inTime)]
                                                   timeOption:MPMovieTimeOptionExact];
}

- (void)bookmarksViewController:(BookmarksViewController *)inController didUpdatePlaybackTime:(NSTimeInterval)inTime {
    [self.moviePlayerController setCurrentPlaybackTime:inTime];
}


@end
