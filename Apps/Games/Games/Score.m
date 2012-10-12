#import "Score.h"

@implementation Score

@dynamic score;
@dynamic creationTime;
@dynamic updateTime;
@dynamic game;

- (void)awakeFromInsert {
    [super awakeFromInsert];
    NSDate *theDate = [NSDate date];
    
    [self setPrimitiveValue:theDate forKey:@"creationTime"];
    [self setPrimitiveValue:theDate forKey:@"updateTime"];
}

- (void)willSave {
    [super willSave];
    if(!self.isDeleted) {
        NSDate *theDate = [NSDate date];
        
        [self setPrimitiveValue:theDate forKey:@"updateTime"];
    }
}

@end
