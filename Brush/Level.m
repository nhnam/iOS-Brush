#import "Level.h"

@implementation Level

@synthesize name = _name;
@synthesize number = _number;
@synthesize unlocked = _unlocked;
@synthesize stars = _stars;
@synthesize data = _data;

-(id)initWithName:(NSString *)name
           Number:(int)number
         Unlocked:(BOOL)unlocked
            Stars:(int)stars
             Data:(NSString *)data
{
    if ((self = [super init])) {
        self.name = name;
        self.number = number;
        self.unlocked = unlocked;
        self.stars = stars;
        self.data = data;
    }
    return self;
}

@end