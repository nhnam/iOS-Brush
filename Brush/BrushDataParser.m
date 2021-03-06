//
//  BrushDataParser.m
//  Brush
//
//  Created by Jeff Merola on 10/30/12.
//  Copyright (c) 2012 SDD_Team. All rights reserved.
//

// XML Parser used to load/save the BrushData information from BrushData.xml

#import "BrushDataParser.h"
#import "BrushData.h"  
#import "GDataXMLNode.h"

@implementation BrushDataParser  

// Gets the file path to the xml file using string manipulation.
// Opens the file for read/write, or creates/copies file into correct directory.
+ (NSString *)dataFilePath:(BOOL)forSave
{
    NSString *xmlFileName = @"BrushData";  

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

// Loads the BrushData using GDataXML.
+ (BrushData *)loadData
{
    int selectedChapter;
    int selectedLevel;
    
    NSString *filePath = [self dataFilePath:FALSE];
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    if (doc == nil) { return nil; NSLog(@"xml file is empty!");}
    NSLog(@"Loading %@", filePath);
    
    NSArray *dataArray = [doc nodesForXPath:@"//BrushData" error:nil];
    NSLog(@"Array Contents = %@", dataArray);
    
    // Implementation for each node in the XML file
    for (GDataXMLElement *element in dataArray) {
        
        NSArray *selectedChapterArray = [element elementsForName:@"SelectedChapter"];
        NSArray *selectedLevelArray = [element elementsForName:@"SelectedLevel"];
        
        // Gets the selected chapter as an int
        if (selectedChapterArray.count > 0) {
            GDataXMLElement *selectedChapterElement = (GDataXMLElement *) [selectedChapterArray objectAtIndex:0];
            selectedChapter = [[selectedChapterElement stringValue] intValue];
        } 
   
        // Gets the selected level as an int
        if (selectedLevelArray.count > 0) {
            GDataXMLElement *selectedLevelElement = (GDataXMLElement *) [selectedLevelArray objectAtIndex:0];
            selectedLevel = [[selectedLevelElement stringValue] intValue];
        }
    }
        
    BrushData *Data = [[BrushData alloc] initWithSelectedChapter:selectedChapter
                                                   SelectedLevel:selectedLevel];
    return Data;
}

// Saves the BrushData using GDataXML.
// Must be careful, save will overwrite
//  xml file, not just add new elements.
+ (void)saveData:(BrushData *)saveData {
    
    GDataXMLElement *brushDataElement = [GDataXMLNode elementWithName:@"BrushData"];
   
    // Build the new XML element.
    GDataXMLElement *selectedChapterElement = [GDataXMLNode elementWithName:@"SelectedChapter"
                                                           stringValue:[[NSNumber numberWithInt:saveData.selectedChapter] stringValue]];

    GDataXMLElement *selectedLevelElement = [GDataXMLNode elementWithName:@"SelectedLevel"
                                                            stringValue:[[NSNumber numberWithInt:saveData.selectedLevel] stringValue]];
        
    [brushDataElement addChild:selectedChapterElement];
    [brushDataElement addChild:selectedLevelElement];
    
    GDataXMLDocument *document = [[GDataXMLDocument alloc] 
                                   initWithRootElement:brushDataElement];
   
    NSData *xmlData = document.XMLData;
    
    NSString *filePath = [self dataFilePath:TRUE];
    NSLog(@"Saving data to %@...", filePath);
    [xmlData writeToFile:filePath atomically:YES];
}

@end