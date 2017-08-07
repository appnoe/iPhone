#import "UIToolbar+Extensions.h"

@implementation UIToolbar (Extensions)

- (void)setEnabled:(BOOL)inEnabled {
    for(UIBarButtonItem *theItem in self.items) {
        theItem.enabled = inEnabled;
    }
}

@end
