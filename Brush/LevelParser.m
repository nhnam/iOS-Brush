//
//  LevelParser.m
//  Brush
//
//  Created by Jeff Merola on 10/30/12.
//  Copyright (c) 2012 SDD_Team. All rights reserved.
//

// XML Parser used to load/save the Level information from Levels-ChapterX.xml

#import "LevelParser.h"
#import "Levels.h"
#import "Level.h"
#import "GDataXMLNode.h"

@implementation LevelParser

// Gets the file path to the xml file using string manipulation.
// Opens the file for read/write, or creates/copies file into correct directory.
+ (NSString *)dataFilePath:(BOOL)forSave ForChapter:(int)chapter
{

    NSString *xmlFileName = [NSString stringWithFormat:@"Levels-Chapter%i", chapter];

    NSString *xmlFileNameWithExtension = [NSString stringWithFormat:@"%@.xml",xmlFileName];    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentsPath = [documentsDirectory stringByAppendingPathComponent:xmlFileNameWithExtension];
    if (forSave || [[NSFileManager defaultManager] fileExistsAtPath:documentsPath]) {
        return documentsPath;   
        NSLog(@"%@ opened for read/write",documentsPath);
    } else {
        NSLog(@"Created/copied in default %@",xmlFileNameWithExtension);
        return [[NSBundle mainBundle] pathForResource:xmlFileName ofType:@"xml"];
    }    
}

// Loads the level data using GDataXML.
+ (Levels *)loadLevelsForChapter:(int)chapter
{
    NSString *name;
    int number;
    BOOL unlocked;
    int stars;
    NSString *data;
    int three;
    int two;
    Levels *levels = [[Levels alloc] init];

    NSString *filePath = [self dataFilePath:FALSE ForChapter:chapter];
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    if (doc == nil) { return nil; NSLog(@"xml file is empty!");}
    NSLog(@"Loading %@", filePath);
    
    NSArray *dataArray = [doc nodesForXPath:@"//Levels/Level" error:nil];
    NSLog(@"Array Contents = %@", dataArray);
    
    // Implementation for each node in the XML file
    for (GDataXMLElement *element in dataArray) {
        
        NSArray *nameArray = [element elementsForName:@"Name"];
        NSArray *numberArray = [element elementsForName:@"Number"];
        NSArray *unlockedArray = [element elementsForName:@"Unlocked"];
        NSArray *starsArray = [element elementsForName:@"Stars"];
        NSArray *levelDataArray = [element elementsForName:@"Data"];
        NSArray *threeArray = [element elementsForName:@"Three"];
        NSArray *twoArray = [element elementsForName:@"Two"];
        
        // Gets the name as a string
        if (nameArray.count > 0) {
            GDataXMLElement *nameElement = (GDataXMLElement *) [nameArray objectAtIndex:0];
            name = [nameElement stringValue];
        }

        // Gets the number as an int
        if (numberArray.count > 0) {
            GDataXMLElement *numberElement = (GDataXMLElement *) [numberArray objectAtIndex:0];
            number = [[numberElement stringValue] intValue];
        }
        
        // Gets the unlocked status as a bool
        if (unlockedArray.count > 0) {
            GDataXMLElement *unlockedElement = (GDataXMLElement *) [unlockedArray objectAtIndex:0];
            unlocked = [[unlockedElement stringValue] boolValue];
        }

        // Gets the number of stars as an int
        if (starsArray.count > 0) {
            GDataXMLElement *starsElement = (GDataXMLElement *) [starsArray objectAtIndex:0];
            stars = [[starsElement stringValue] intValue];
        }
        
        // Gets the level data as a string
        if (levelDataArray.count > 0) {
            GDataXMLElement *levelDataElement = (GDataXMLElement *) [levelDataArray objectAtIndex:0];
            data = [levelDataElement stringValue];
        }
        
        // Gets the maximum number of moves for three stars
        if (threeArray.count > 0) {
            GDataXMLElement *threeElement = (GDataXMLElement *) [threeArray objectAtIndex:0];
            three = [[threeElement stringValue] intValue];
        }
        
        // Gets the maximum number of moves for two stars
        if (twoArray.count > 0) {
            GDataXMLElement *twoElement = (GDataXMLElement *) [twoArray objectAtIndex:0];
            two = [[twoElement stringValue] intValue];
        }
        
        Level *level = [[Level alloc] initWithName:name Number:number Unlocked:unlocked Stars:stars Data:data Three:three Two:two];
        [levels.levels addObject:level];
    }
    return levels;
}

// Saves the level data using GDataXML.
+ (void)saveData:(Levels *)saveData ForChapter:(int)chapter
{
    GDataXMLElement *levelsElement = [GDataXMLNode elementWithName:@"Levels"];
    
    // For each level, build the new XML element line by line.
    for (Level *level in saveData.levels) {
        GDataXMLElement *levelElement = [GDataXMLNode elementWithName:@"Level"];
        GDataXMLElement *nameElement = [GDataXMLNode elementWithName:@"Name" stringValue:level.name];
        GDataXMLElement *numberElement = [GDataXMLNode elementWithName:@"Number" stringValue:[[NSNumber numberWithInt:level.number] stringValue]];
        GDataXMLElement *unlockedElement = [GDataXMLNode elementWithName:@"Unlocked" stringValue:[[NSNumber numberWithBool:level.unlocked] stringValue]];
        GDataXMLElement *starsElement = [GDataXMLNode elementWithName:@"Stars" stringValue:[[NSNumber numberWithInt:level.stars] stringValue]];
        GDataXMLElement *dataElement = [GDataXMLNode elementWithName:@"Data" stringValue:level.data];
        GDataXMLElement *threeElement = [GDataXMLNode elementWithName:@"Three" stringValue:[[NSNumber numberWithInt:level.three] stringValue]];
        GDataXMLElement *twoElement = [GDataXMLNode elementWithName:@"Two" stringValue:[[NSNumber numberWithInt:level.two] stringValue]];
        
        [levelElement addChild:nameElement];
        [levelElement addChild:numberElement];
        [levelElement addChild:unlockedElement];
        [levelElement addChild:starsElement];
        [levelElement addChild:dataElement];
        [levelElement addChild:threeElement];
        [levelElement addChild:twoElement];
        
        [levelsElement addChild:levelElement];
    }
    
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithRootElement:levelsElement];
    NSData *xmlData = document.XMLData;
    
    NSString *filePath = [self dataFilePath:TRUE ForChapter:chapter];
    NSLog(@"Saving data to %@...", filePath);
    [xmlData writeToFile:filePath atomically:YES];
}

@end