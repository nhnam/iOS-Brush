#import <Foundation/Foundation.h>

@interface BrushData : NSObject {}

@property (nonatomic, assign) int selectedChapter;
@property (nonatomic, assign) int selectedLevel;
   
-(id)initWithSelectedChapter:(int)selectedChapter
               SelectedLevel:(int)selectedLevel;

@end
