//
//  BreakoutMyScene.m
//  Breakout
//
//  Created by Clemens Wagner on 11.01.14.
//  Copyright (c) 2014 Clemens Wagner. All rights reserved.
//

#import "BreakoutScene.h"

const NSUInteger kRows = 8;
const NSUInteger kBricksPerRow = 8;

static NSString * const kBall = @"ball";
static NSString * const kBrick = @"brick";
static NSString * const kImpulse = @"impulse";
static NSString * const kPoints = @"points";

const uint32_t kWallMask = 1 << 0;
const uint32_t kBallMask = 1 << 1;
const uint32_t kBrickMask = 1 << 2;
const uint32_t kRacketMask = 1 << 3;

static NSString * const kGameOverLabel = @"Game Over";

static inline CGFloat CGVectorLength(CGVector inVector) {
    return sqrtf(inVector.dx * inVector.dx + inVector.dy * inVector.dy);
}

#define PHYSICS 3

@interface BreakoutScene ()<SKPhysicsContactDelegate>

@property (nonatomic, readwrite) BOOL isRunning;
@property (nonatomic, readwrite) NSUInteger score;

@property (nonatomic) CGFloat velocity;
@property (nonatomic, strong) SKNode *ball;
@property (nonatomic, strong) SKNode *racket;

@property (nonatomic, strong) SKAction *contactWall;
@property (nonatomic, strong) SKAction *contactRacket;
@property (nonatomic, strong) SKAction *explosion;

@end

@implementation BreakoutScene

- (id)initWithSize:(CGSize)inSize {
    self = [super initWithSize:inSize];
    if(self) {
        CGSize theBricklSize = self.brickSize;
        CGSize theRacketSize = CGSizeMake(theBricklSize.width, theBricklSize.height / 2.0);
        CGRect theFrame = self.frame;
        SKPhysicsBody *theBody;
        
        self.backgroundColor = [SKColor blueColor];
        self.velocity = inSize.height / 2.0;
        [self buildBricks];
        self.racket = [self racketWithSize:theRacketSize
                                  position:CGPointMake(inSize.width / 2.0, theBricklSize.height)];
        [self addChild:self.racket];
        theFrame.origin.y = -2.0 * theBricklSize.height;
        theFrame.size.height += 2.0 * theBricklSize.height;
        theBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:theFrame];
        theBody.categoryBitMask = kWallMask;
        theBody.collisionBitMask = kBallMask;
        self.contactRacket = [SKAction playSoundFileNamed:@"racket.caf" waitForCompletion:NO];
        self.contactWall = [SKAction playSoundFileNamed:@"wall.caf" waitForCompletion:NO];
        self.explosion = [SKAction playSoundFileNamed:@"explosion.caf" waitForCompletion:NO];
#if PHYSICS > 0
        self.physicsBody = theBody;
#endif
#if PHYSICS > 1
        self.physicsWorld.contactDelegate = self;
#endif
        [self start];
    }
    return self;
}

- (CGSize)brickSize {
    CGSize theSize = self.size;
    
    return CGSizeMake(theSize.width / kBricksPerRow, theSize.width / (3 * kBricksPerRow));
}

- (void)buildBricks {
    CGSize theSize = self.size;
    CGSize theBrickSize = self.brickSize;
    NSArray *theColors = @[ [UIColor redColor], [UIColor orangeColor], [UIColor yellowColor], [UIColor greenColor] ];
    NSUInteger theCount = [theColors count];
    CGFloat theMinimalY = 0.0;

    [self removeAllBricks];
    for(NSUInteger i = 0; i < kRows; ++i) {
        CGPoint thePoint = CGPointMake(theBrickSize.width / 2.0,
                                       theSize.height - (i + 0.5) * theBrickSize.height);
        
        theMinimalY = thePoint.y;
        for(NSUInteger j = 0; j < kBricksPerRow; ++j) {
            NSUInteger theIndex = drand48() * theCount;
            SKColor *theColor = theColors[theIndex];
            SKNode *theBrick = [self brickWithColor:theColor size:theBrickSize position:thePoint];
            
            theBrick.userData[kPoints] = @((theIndex + 1) * 10);
            theBrick.userData[kImpulse] = @(10 + theIndex * 3);
            [self addChild:theBrick];
            thePoint.x += theBrickSize.width;
        }
    }
}

- (void)removeAllBricks {
    NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"name = %@", kBrick];
    NSArray *theNodes = [self.children filteredArrayUsingPredicate:thePredicate];
    
    [theNodes makeObjectsPerformSelector:@selector(removeFromParent)];
}

- (CGFloat)gravity {
    return CGVectorLength(self.physicsWorld.gravity);
}

- (void)addImpulseWithFactor:(CGFloat)inFactor {
    SKPhysicsBody *theBody = self.ball.physicsBody;
    CGVector theVelocity = theBody.velocity;
    CGFloat theLength = CGVectorLength(theVelocity);
    CGFloat theImpulse = theBody.mass * self.gravity * inFactor;
    CGVector theImpulseVector = CGVectorMake(theImpulse * theVelocity.dx / theLength, theImpulse * theVelocity.dy / theLength);
    
    [theBody applyImpulse:theImpulseVector];
}

- (void)updateRacketWithTouches:(NSSet *)inTouches {
    SKNode *theRacket = self.racket;
    UITouch *theTouch = [inTouches anyObject];
    CGPoint thePoint = [theTouch locationInNode:self];
    SKAction *theAction = [SKAction moveToX:thePoint.x duration:0.0];
    
    [theRacket runAction:theAction];
}

- (void)touchesBegan:(NSSet *)inTouches withEvent:(UIEvent *)inEvent {
    if([self isRunning]) {
        [self updateRacketWithTouches:inTouches];
    }
    else {
        [self buildBricks];
        [self start];
    }
}

- (void)touchesMoved:(NSSet *)inTouches withEvent:(UIEvent *)inEvent {
    [self updateRacketWithTouches:inTouches];
}

- (void)start {
    if(self.ball == nil) {
        CGRect theFrame = self.frame;
        CGFloat theRadius = CGRectGetWidth(theFrame) / (6 * kBricksPerRow);
        CGPoint thePosition = CGPointMake(CGRectGetMidX(theFrame), CGRectGetMidY(theFrame));
        SKNode *theLabel = [self childNodeWithName:kGameOverLabel];
        
        self.ball = [self ballWithRadius:theRadius position:thePosition];
        [self addChild:self.ball];
        [theLabel removeFromParent];
        self.score = 0;
        self.isRunning = YES;
    }
}

- (void)stop {
    SKNode *theBall = self.ball;

    self.ball = nil;
    if(theBall != nil) {
        SKLabelNode *theNode = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Bold"];
        CGRect theFrame = self.frame;
        
        [theBall runAction:[SKAction removeFromParent]];
        theNode.name = kGameOverLabel;
        theNode.text = NSLocalizedString(@"Game Over", @"Game Over");
        theNode.position = CGPointMake(CGRectGetMidX(theFrame), CGRectGetMidY(theFrame));
        theNode.alpha = 0.0;
        [self addChild:theNode];
        [theNode runAction:[SKAction fadeInWithDuration:0.25]];
        self.isRunning = NO;
    }
}

- (CGVector)velocityWithDirection:(CGVector)inDirection {
    CGFloat theAbsoluteVelocity = CGVectorLength(inDirection);
    
    if(theAbsoluteVelocity == 0) {
        CGFloat theAngle = 2 * M_PI * drand48();
        
        return CGVectorMake(self.velocity * sinf(theAngle), self.velocity * cosf(theAngle));
    }
    else {
        CGFloat theScale = self.velocity / theAbsoluteVelocity;

        return CGVectorMake(inDirection.dx * theScale, inDirection.dy * theScale);
    }
}

- (SKNode *)rectangleWithColor:(SKColor *)inColor size:(CGSize)inSize position:(CGPoint)inCenter {
    SKShapeNode *theRectangle = [SKShapeNode new];
    CGRect theBounds = CGRectMake(-inSize.width / 2.0, -inSize.height / 2.0, inSize.width, inSize.height);
    CGPathRef thePath = CGPathCreateWithRect(theBounds, NULL);
    SKPhysicsBody *theBody = [SKPhysicsBody bodyWithRectangleOfSize:inSize];
    
    theRectangle.path = thePath;
    theRectangle.fillColor = inColor;
    theRectangle.strokeColor = [SKColor whiteColor];
    theRectangle.glowWidth = 0.0;
    theRectangle.lineWidth = 0.5;
    theRectangle.position = inCenter;
    theRectangle.userData = [NSMutableDictionary new];
    theBody.dynamic = NO;
#if PHYSICS > 0
    theRectangle.physicsBody = theBody;
#endif
    CGPathRelease(thePath);
    return theRectangle;
}

- (SKNode *)brickWithColor:(SKColor *)inColor size:(CGSize)inSize position:(CGPoint)inCenter {
    SKNode *theBrick = [self rectangleWithColor:inColor size:inSize position:inCenter];
    
    theBrick.name = kBrick;
#if PHYSICS > 2
    SKPhysicsBody *theBody = theBrick.physicsBody;

    theBody.categoryBitMask = kBrickMask;
    theBody.collisionBitMask = kBallMask;
#endif
    return theBrick;
}

- (SKNode *)racketWithSize:(CGSize)inSize position:(CGPoint)inCenter {
    SKNode *theRacket = [self rectangleWithColor:[SKColor whiteColor] size:inSize position:inCenter];
    
    theRacket.name = @"racket";
#if PHYSICS > 2
    SKPhysicsBody *theBody = theRacket.physicsBody;
    
    theBody.categoryBitMask = kRacketMask;
    theBody.collisionBitMask = kBallMask;
    theBody.contactTestBitMask = kBallMask;
#endif
    return theRacket;
}

- (SKNode *)ballWithRadius:(CGFloat)inRadius position:(CGPoint)inCenter {
    SKShapeNode *theBall = [SKShapeNode new];
    CGRect theBounds = CGRectMake(-inRadius, -inRadius, 2 * inRadius, 2 * inRadius);
    CGPathRef thePath = CGPathCreateWithEllipseInRect(theBounds, NULL);
    SKPhysicsBody *theBody = [SKPhysicsBody bodyWithCircleOfRadius:inRadius];
    CGFloat theAngle = M_PI / 4.0 + M_PI * drand48() / 2.0;
    
    theBall.name = kBall;
    theBall.path = thePath;
    theBall.fillColor = [SKColor yellowColor];
    theBall.strokeColor = theBall.fillColor;
    theBall.glowWidth = 1.0;
    theBall.position = inCenter;
    theBody.affectedByGravity = NO;
    theBody.mass = 10;
    theBody.velocity = CGVectorMake(self.velocity * cosf(theAngle), self.velocity * sinf(theAngle));
#if PHYSICS > 2
    theBody.categoryBitMask = kBallMask;
    theBody.collisionBitMask = kBrickMask | kRacketMask | kWallMask;
    theBody.contactTestBitMask = kBrickMask | kRacketMask | kWallMask;
#endif
#if PHYSICS > 0
    theBall.physicsBody = theBody;
#endif
    CGPathRelease(thePath);
    return theBall;
}

- (SKEmitterNode *)emitterNodeNamed:(NSString *)inName {
    NSString *thePath = [[NSBundle mainBundle] pathForResource:inName ofType:@"sks"];
    
    return [NSKeyedUnarchiver unarchiveObjectWithFile:thePath];
}

- (void)explosionAtPoint:(CGPoint)inPoint {
    SKNode *theNode = [self emitterNodeNamed:@"explosion"];
    SKAction *theAction = [SKAction sequence:@[[SKAction waitForDuration:0.5],
                                               [SKAction removeFromParent]]];
    
    theNode.position = inPoint;
    [self addChild:theNode];
    [theNode runAction:theAction];
    [theNode runAction:self.explosion];
}

#pragma mark SKPhysicsContactDelegate

- (void)didBeginContact:(SKPhysicsContact *)inContact {
    CGPoint thePoint = inContact.contactPoint;

    [self didBeginContactWithBody:inContact.bodyA atPoint:thePoint];
    [self didBeginContactWithBody:inContact.bodyB atPoint:thePoint];
}

- (void)didBeginContactWithBody:(SKPhysicsBody *)inBody atPoint:(CGPoint)inPoint {
    if(inBody.categoryBitMask == kBrickMask) {
        SKNode *theBrick = inBody.node;
        SKAction *theAction = [SKAction sequence:@[[SKAction fadeOutWithDuration:0.5],
                                                   [SKAction removeFromParent]
                                                   ]];
        
        [theBrick runAction:theAction];
        self.score += [theBrick.userData[kPoints] unsignedIntegerValue];
        [self explosionAtPoint:inPoint];
    }
    else if(inBody.categoryBitMask == kWallMask) {
        if (inPoint.y < 0.0) {
            [self stop];
        }
        else {
            [self runAction:self.contactWall];
        }
    }
    else if(inBody.categoryBitMask == kRacketMask) {
        [self runAction:self.contactRacket];
    }
}

- (void)didEndContact:(SKPhysicsContact *)inContact {
    [self didEndContactWithBody:inContact.bodyA];
    [self didEndContactWithBody:inContact.bodyB];
}

- (void)didEndContactWithBody:(SKPhysicsBody *)inBody {
    if(inBody.categoryBitMask == kBrickMask) {
        SKNode *theBrick = inBody.node;
        CGFloat theImpulse = [theBrick.userData[kImpulse] floatValue];
        
        [self addImpulseWithFactor:theImpulse];
    }
    else if(inBody.categoryBitMask & (kWallMask | kRacketMask)) {
        [self addImpulseWithFactor:15.0];
    }
}

@end
