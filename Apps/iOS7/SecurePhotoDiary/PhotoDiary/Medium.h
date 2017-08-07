#import <CoreData/CoreData.h>

@class DiaryEntry;

@interface Medium : NSManagedObject

@property (nonatomic) NSString *type;
@property (nonatomic) NSData *data;
@property (nonatomic) DiaryEntry *diaryEntry;

@end
