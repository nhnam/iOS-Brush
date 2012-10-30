#import <Foundation/Foundation.h>

@class BrushData;  

@interface BrushDataParser : NSObject {}  

+ (BrushData *)loadData;  
+ (void)saveData:(BrushData *)saveData;  

@end