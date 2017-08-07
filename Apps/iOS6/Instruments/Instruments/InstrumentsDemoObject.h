#import <Foundation/Foundation.h>

@interface InstrumentsDemoObject : NSObject {
    @private
}

@property (nonatomic, readonly) NSUInteger counter;

+ (id)object;
- (NSUInteger)successorCount;
- (NSUInteger)sum;
- (InstrumentsDemoObject *)successorWithIndex:(NSUInteger)inIndex;
- (void)prepend:(InstrumentsDemoObject *)inObject;

@end
