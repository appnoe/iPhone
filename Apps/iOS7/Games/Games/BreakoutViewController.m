//
//  BreakoutViewController.m
//  Breakout
//
//  Created by Clemens Wagner on 11.01.14.
//  Copyright (c) 2014 Clemens Wagner. All rights reserved.
//

#import "BreakoutViewController.h"
#import "BreakoutScene.h"
#import "NumberView.h"
#import <SpriteKit/SpriteKit.h>

@interface BreakoutViewController()

@property (nonatomic, strong) BreakoutScene *scene;
@property (nonatomic, weak) IBOutlet UILabel *scoreLabel;

@end

@implementation BreakoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)inAnimated {
    [super viewDidAppear:inAnimated];
    if(self.scene) {
        self.scene.paused = NO;
    }
    else {
        SKView *theView = (SKView *)self.view;
        BreakoutScene *theScene = [BreakoutScene sceneWithSize:theView.bounds.size];

        theScene.scaleMode = SKSceneScaleModeAspectFill;
        [theView presentScene:theScene];
        self.scene = theScene;
    }
    [self.scene addObserver:self forKeyPath:@"score" options:NSKeyValueObservingOptionNew context:nil];
    [self.scene addObserver:self forKeyPath:@"isRunning" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewWillDisappear:(BOOL)inAnimated {
    [super viewWillDisappear:inAnimated];
    self.scene.paused = YES;
    [self.scene removeObserver:self forKeyPath:@"score" context:NULL];
    [self.scene removeObserver:self forKeyPath:@"isRunning" context:NULL];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (NSString *)game {
    return @"breakout";
}

- (void)observeValueForKeyPath:(NSString *)inKeyPath ofObject:(id)inObject change:(NSDictionary *)inChanges context:(void *)inContext {
    if([@"score" isEqualToString:inKeyPath]) {
        NSString *theFormat = NSLocalizedString(@"Score: %06lu", @"");
        
        self.scoreLabel.text = [NSString stringWithFormat:theFormat, self.scene.score];
    }
    else if([@"isRunning" isEqualToString:inKeyPath] && !self.scene.isRunning) {
        [self saveScore:self.scene.score];
    }
}


@end
