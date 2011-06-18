//
//  Collect Similar Items.m
//  Smart-Organise
//
//  Created by Mannie Tagarira on 24/06/2010.
//  Copyright (c) 2010 Mannie Tagarira.


#import "Collect Similar Items.h"


@implementation Collect_Similar_Items

- (id)runWithInput:(id)input fromAction:(AMAction *)anAction error:(NSDictionary **)errorInfo {
  // set work vars
  output = [[NSMutableArray alloc] init];
  pathComponents = [[NSMutableArray alloc] init];
  
  fileManager = [NSFileManager defaultManager];

  // iterate over the input
  inputEnumerator = [input objectEnumerator];
  while (path = [inputEnumerator nextObject]) {
    @try {
      fileName = [path lastPathComponent];
      
      if ([[fileName pathExtension] length] == 0) continue;
        
      // create directory to move files to
      [pathComponents removeAllObjects];
      [pathComponents addObjectsFromArray:[[path stringByDeletingLastPathComponent] pathComponents]];

      // enumerator for the containing directory
      organiseDirectory = [NSString pathWithComponents:pathComponents];
      directoryEnumerator = [[fileManager contentsOfDirectoryAtPath:organiseDirectory error:&error] objectEnumerator]; // TODO: use error object

      // new directory with name of extension
      [pathComponents addObject:[fileName pathExtension]];
      organiseDirectory = [NSString pathWithComponents:pathComponents];
      [fileManager createDirectoryAtPath:organiseDirectory withIntermediateDirectories:YES attributes:nil error:&error]; // TODO: use error object
      
      // iterate over the container directory looking for files with the same extension
      while (currentFile = [directoryEnumerator nextObject]) {
        // does file have extension? if not, go to next
        if (![[currentFile pathExtension] isEqualToString:[fileName pathExtension]]) continue;
              
        // set the current file name
        [pathComponents removeLastObject];
        [pathComponents addObject:currentFile];
        organiseDirectory = [NSString pathWithComponents:pathComponents];

        // set the new file path
        [pathComponents removeLastObject];
        [pathComponents addObject:[fileName pathExtension]];
        [pathComponents addObject:currentFile];
        
        // rename file if necessary
        int x = 1;
        while ([fileManager fileExistsAtPath:[NSString pathWithComponents:pathComponents]]) {
          [pathComponents removeLastObject];
          
          newFileName = [NSString stringWithFormat:@"%@ %i.%@", [fileName stringByDeletingPathExtension], x++, [currentFile pathExtension]];
          [pathComponents addObject:newFileName];  
        }
        
        // move file to new path
        newFileName = [NSString pathWithComponents:pathComponents];
        [fileManager moveItemAtPath:organiseDirectory toPath:newFileName error:&error]; // TODO: use error object
        
        // add file path to output array
        [pathComponents removeLastObject];
        organiseDirectory = [NSString pathWithComponents:pathComponents];
        
        // add this file to the output array
        if (![output containsObject:organiseDirectory]) [output addObject:organiseDirectory];
     } // while [directoryEnumerator nextObject]
    } @catch (NSException *e) {
      NSLog(@"Exception: %@ - %@", [e name], [e reason]);
      // TODO: handle exception properly
    } // try catch
  } // while [enumerator nextObject]
  
  // cleanup
  [pathComponents release];
  
	return [output autorelease];
} 

@end
