#import "BrushData.h"  

@implementation BrushData  

@synthesize selectedChapter = _selectedChapter;
@synthesize selectedLevel = _selectedLevel;

- (id)initWithSelectedChapter:(int)selectedChapter
                SelectedLevel:(int)selectedLevel
{
    if ((self = [super init])) {
        self.selectedChapter = selectedChapter;
        self.selectedLevel = selectedLevel; 
    }
    return self;
}

@end