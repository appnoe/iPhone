#import "InstrumentsDemoObject.h"

static NSUInteger objectCounter = 1;

@interface InstrumentsDemoObject()

@property (nonatomic, retain) InstrumentsDemoObject *successor;

@end

@implementation InstrumentsDemoObject

@synthesize counter;
@synthesize successor;

+ (id)object {
    return [[[self alloc] init] autorelease];
}

- (id)init {
    self = [super init];
    if (self) {
        counter = objectCounter++;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"dealloc: %u", counter);
    self.successor = nil;
    [super dealloc];
}

- (NSUInteger)successorCount {
    NSUInteger theCount = 0;
    id theItem = self;

    while([theItem successor]) {
        theCount++;
        theItem = [theItem successor];
    }
    return theCount;
}

- (NSUInteger)sum {
    NSUInteger theCount = self.successorCount;
    NSUInteger theSum = 0;
    
    for(NSUInteger i = 0; i < theCount; ++i) {
        InstrumentsDemoObject *theItem = [self successorWithIndex:i];
        
        theSum += theItem.counter;
    }
    return theSum;
}

- (InstrumentsDemoObject *)successorWithIndex:(NSUInteger)inIndex {
    id theItem = self;
    
    for(NSUInteger theIndex = 0; theIndex < inIndex; ++theIndex) {
        theItem = [theItem successor];
    }
    return theItem;
}

- (void)prepend:(InstrumentsDemoObject *)inObject {
    inObject.successor = self.successor;
    self.successor = inObject;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%u", counter];
}

@end
