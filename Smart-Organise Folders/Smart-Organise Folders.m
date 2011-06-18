//
//  Smart-Organise Folders.m
//  Smart-Organise
//
//  Created by Mannie Tagarira on 24/06/2010.
//  Copyright (c) 2010 Mannie Tagarira.


#import "Smart-Organise Folders.h"


@implementation Smart_Organise_Folders

- (id)runWithInput:(id)input fromAction:(AMAction *)anAction error:(NSDictionary **)errorInfo {
  // set work vars
  output = [[NSMutableArray alloc] init];
  pathComponents = [[NSMutableArray alloc] init];

  fileManager = [NSFileManager defaultManager];
  
  // iterate over the input
  inputEnumerator = [input objectEnumerator];
  while (currentPath = [inputEnumerator nextObject]) {
    directoryEnumerator = [[fileManager contentsOfDirectoryAtPath:currentPath error:&error] objectEnumerator]; // TODO: use error object
    
    while (fileName = [directoryEnumerator nextObject]) {
      @try {
        if ([[fileName pathExtension] length] == 0) continue;
        
        // check that the file is not a .download bundle or a .part bundle
        BOOL isDownloadBundle = [[fileName pathExtension] isEqualToString:@"download"];
        BOOL isPartBundle = [[fileName pathExtension] isEqualToString:@"part"];
        if (isDownloadBundle || isPartBundle) continue;
        
        // construct the path to the current file
        [pathComponents removeAllObjects];
        [pathComponents addObjectsFromArray:[currentPath pathComponents]];
        [pathComponents addObject:fileName];
        
        filePath = [NSString pathWithComponents:pathComponents];
        
        // create directory to move files to
        [pathComponents removeLastObject];
        [pathComponents addObject:[fileName pathExtension]];
        
        organiseDirectory = [NSString pathWithComponents:pathComponents];
        [fileManager createDirectoryAtPath:organiseDirectory withIntermediateDirectories:YES attributes:nil error:&error]; // TODO: use error object
        
        // set the new file path
        [pathComponents addObject:fileName];
        
        // rename file if necessary
        int x = 1;
        while ([fileManager fileExistsAtPath:[NSString pathWithComponents:pathComponents]]) {
          [pathComponents removeLastObject];
          
          newFileName = [NSString stringWithFormat:@"%@ %i.%@", [fileName stringByDeletingPathExtension], x++, [fileName pathExtension]];
          [pathComponents addObject:newFileName];  
        }
        
        // move file to new path
        organiseDirectory = [NSString pathWithComponents:pathComponents];
        [fileManager moveItemAtPath:filePath toPath:organiseDirectory error:&error]; // TODO: use error object
        
        // add file path to output array
        [pathComponents removeLastObject];
        organiseDirectory = [NSString pathWithComponents:pathComponents];
        
        if (![output containsObject:organiseDirectory]) [output addObject:organiseDirectory];
      } @catch (NSException *e) {
        NSLog(@"Exception: %@ - %@", [e name], [e reason]);
        // TODO: handle exception properly
      } // try catch
    } // while [directoryEnumerator nextObject]
    
  } // while [inputEnumerator nextObject]

  // cleanup
  [pathComponents release];

	return [output autorelease];
}

@end
