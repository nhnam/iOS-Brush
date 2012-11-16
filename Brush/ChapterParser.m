//
//  ChapterParser.m
//  Brush
//
//  Created by Jeff Merola on 10/30/12.
//  Copyright (c) 2012 SDD_Team. All rights reserved.
//

// XML Parser used to load the Chapter information from Chapters.xml

#import "ChapterParser.h"
#import "Chapter.h"
#import "Chapters.h"
#import "GDataXMLNode.h"

@implementation ChapterParser

// Gets the file path to the xml file using string manipulation.
// Opens the file for read/write, or creates/copies file into correct directory.
+ (NSString *)dataFilePath:(BOOL)forSave 
{
    NSString *xmlFileName = @"Chapters";

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

// Loads the chapter data using GDataXML.
+ (Chapters *)loadData 
{
	NSString *name;
    int number;
	Chapters *chapters = [[Chapters alloc] init];	

    NSString *filePath = [self dataFilePath:FALSE];
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    if (doc == nil) { return nil; NSLog(@"xml file is empty!");}
    NSLog(@"Loading %@", filePath);
    NSArray *dataArray = [doc nodesForXPath:@"//Chapters/Chapter" error:nil];
    NSLog(@"Array Contents = %@", dataArray);
    
    // Implementation for each node in the XML file
    for (GDataXMLElement *element in dataArray) {
        
        NSArray *nameArray = [element elementsForName:@"Name"];
        NSArray *numberArray = [element elementsForName:@"Number"];   
        
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
		
		Chapter *chapter = [[Chapter alloc] initWithName:name Number:number];
		[chapters.chapters addObject:chapter];
    }
    return chapters;
}

@end