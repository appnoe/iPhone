#import <UIKit/UIKit.h>


@interface DiaryEntryCell : UITableViewCell

@property (nonatomic, assign, readonly) UIControl *imageControl;

- (void)setText:(NSString *)inText;
- (void)setIcon:(UIImage *)inImage;
- (void)setDate:(NSDate *)inDate;

@end
