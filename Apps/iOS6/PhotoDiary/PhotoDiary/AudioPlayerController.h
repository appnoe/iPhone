#import "SubviewController.h"

@class MeterView;
@class Medium;

@interface AudioPlayerController : SubviewController 

@property(nonatomic, strong) Medium *audioMedium;
@property(nonatomic) NSTimeInterval time;

@end
