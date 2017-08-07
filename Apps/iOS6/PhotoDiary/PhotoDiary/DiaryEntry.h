#import <CoreData/CoreData.h>

extern NSString * const kMediumTypeImage;
extern NSString * const kMediumTypeAudio;

@class Medium;

@interface DiaryEntry : NSManagedObject

@property (nonatomic) NSData *icon;
@property (nonatomic) NSDate *creationTime;
@property (nonatomic) NSDate *updateTime;
@property (nonatomic) NSString *text;
@property (nonatomic, copy) NSSet *media;

- (BOOL)hasContent;

- (Medium *)mediumForType:(NSString *)inType;
- (void)removeMediumForType:(NSString *)inType;

- (void)addMedium:(Medium *)inMedium;
- (void)removeMedium:(Medium *)inMedium;

@end