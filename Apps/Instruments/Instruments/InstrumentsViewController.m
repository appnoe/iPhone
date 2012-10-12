#import "InstrumentsViewController.h"
#import "InstrumentsDemoObject.h"

@interface InstrumentsViewController()

@property (nonatomic, retain) NSMutableSet *zombies;
@property (nonatomic, retain) InstrumentsDemoObject *rootObject;;
@property (nonatomic, retain) InstrumentsDemoObject *attributeLeak;
@property (nonatomic, retain) InstrumentsDemoObject *attributeZombie;

@end

@implementation InstrumentsViewController

@synthesize sumLabel;
@synthesize rootObject;
@synthesize zombies;
@synthesize attributeLeak;
@synthesize attributeZombie;

- (void)dealloc {
    self.rootObject = nil;
    self.zombies = nil;
    self.attributeLeak = nil;
    self.sumLabel = nil;
    [super dealloc];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.rootObject = [InstrumentsDemoObject object];
    self.zombies = [NSMutableSet set];
}

- (void)viewDidUnload {
    self.sumLabel = nil;
    [super viewDidUnload];
}

- (IBAction)makeZombie {
    id theZombie = [InstrumentsDemoObject object];
    
    NSLog(@"zombies=%@", self.zombies);
    [self.zombies addObject:theZombie];
    [theZombie release];
}

- (IBAction)makeLeak {
    id theLeak = [[InstrumentsDemoObject alloc] init];
    
    NSLog(@"leak=%@", theLeak);
}

- (IBAction)makeAttributeLeak {
    attributeLeak = [[InstrumentsDemoObject object] retain];
}

- (IBAction)makeAttributeZombie {
    NSLog(@"attributeZombie = %@", attributeZombie);
    attributeZombie = [InstrumentsDemoObject object];
}

- (IBAction)computeSum {
    NSUInteger theCount = self.rootObject.successorCount;
    NSUInteger theSum = self.rootObject.sum;
    
    self.sumLabel.text = [NSString stringWithFormat:@"%u / %u",
                          theCount, theSum];
    for(NSUInteger i = 0; i <= theCount; ++i) {
        [self.rootObject prepend:[InstrumentsDemoObject object]];
    }
}


@end
