#import "DiaryEntryCell.h"

#define ICON -100
#define TEXT -101
#define DATE -102

@implementation DiaryEntryCell

- (UIImageView *)imageView {
    return (UIImageView *)[self viewWithTag:ICON];
}

- (UIControl *)imageControl {
    return (UIControl *) self.imageView.superview;
}

- (void)setIcon:(UIImage *)inImage {
    UIImageView *theView = self.imageView;
    
    theView.image = inImage;
}

- (void)setText:(NSString *)inText {
    UILabel *theLabel = (UILabel *)[self viewWithTag:TEXT];
    
    theLabel.text = inText;
}

- (void)setDate:(NSDate *)inDate {
    UILabel *theLabel = (UILabel *)[self viewWithTag:DATE];
    NSDateFormatter *theFormatter = [[NSDateFormatter alloc] init];
    
    theFormatter.dateStyle = NSDateFormatterMediumStyle;
    theLabel.text = [theFormatter stringFromDate:inDate];
}

@end
