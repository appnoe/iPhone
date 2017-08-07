#import "InstrumentsViewController.h"
#import "InstrumentsDemoObject.h"

@interface InstrumentsViewController()

@property (nonatomic, strong) IBOutlet UILabel *sumLabel;

@property (nonatomic, strong) NSMutableSet *zombies;
@property (nonatomic, strong) InstrumentsDemoObject *rootObject;;
@property (nonatomic, strong) InstrumentsDemoObject *attributeLeak;
@property (nonatomic, strong) InstrumentsDemoObject *attributeZombie;

- (IBAction)makeZombie;
- (IBAction)makeMallocLeak;
- (IBAction)makeAttributeLeak;
- (IBAction)makeRetainCycle;
- (IBAction)makeAttributeZombie;
- (IBAction)computeSum;

@end

@implementation InstrumentsViewController {
    int *danglingPointer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rootObject = [InstrumentsDemoObject object];
    self.zombies = [NSMutableSet set];
}

- (IBAction)makeZombie {
    id theZombie = [InstrumentsDemoObject object];
    
    NSLog(@"zombies=%@", self.zombies);
    [self.zombies addObject:theZombie];
    [theZombie release];
}

- (IBAction)makeMallocLeak {
    void *theLeak = malloc(1234);
    
    NSLog(@"leak=0x%p", theLeak);
}

- (IBAction)makeRetainCycle {
    id theFirstArray = [NSMutableArray array];
    id theSecondArray = @[ theFirstArray ];

    [theFirstArray addObject:theSecondArray];
}

- (IBAction)makeAttributeLeak {
    _attributeLeak = [[InstrumentsDemoObject object] retain];
}

- (IBAction)makeAttributeZombie {
    NSLog(@"attributeZombie = %@", _attributeZombie);
    _attributeZombie = [InstrumentsDemoObject object];
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
