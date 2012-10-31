#import <Foundation/Foundation.h>

@interface Chapter : NSObject {}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int number;
   
-(id)initWithName:(NSString *)name Number:(int)number;

@end
