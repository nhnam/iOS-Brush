#import "Chapters.h"

@implementation Chapters

@synthesize chapters = _chapters;

-(id)init
{
    if ((self = [super init])) {
		self.chapters = [[NSMutableArray alloc] init];
    }
    return self;
}

@end