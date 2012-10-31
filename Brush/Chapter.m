#import "Chapter.h"

@implementation Chapter

@synthesize name = _name;
@synthesize number = _number;

-(id)initWithName:(NSString *)name Number:(int)number 
{
    if ((self = [super init])) {
		self.name = name;
		self.number = number;
    }
    return self;
}

@end