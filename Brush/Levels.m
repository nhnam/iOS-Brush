#import "Levels.h"

@implementation Levels

@synthesize levels = _levels;

-(id)init
{
    if ((self = [super init])) {
		self.levels = [[NSMutableArray alloc] init];
    }
    return self;
}

@end