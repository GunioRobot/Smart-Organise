//
//  Organise By Date.m
//  Smart-Organise
//
//  Created by Mannie Tagarira on 24/06/2010.
//  Copyright (c) 2010 Mannie Tagarira.


#import "Organise By Date.h"


@implementation Organise_By_Date

- (id)runWithInput:(id)input fromAction:(AMAction *)anAction error:(NSDictionary **)errorInfo {
  // set work vars
  output = [[NSMutableArray alloc] init];
  pathComponents = [[NSMutableArray alloc] init];

  fileManager = [NSFileManager defaultManager];
  
  // set the current date in format YYYY-MM-DD
  currentDate = [[NSDate date] descriptionWithCalendarFormat:@"%Y-%m-%d" timeZone:nil locale:nil];
  
  // iterate over the input
  enumerator = [input objectEnumerator];
  while (path = [enumerator nextObject]) {
    @try {
      // if file exists and is NOT a directory; 
      // if a user pastes a folder with "." in its name, this folder should not be collected
      if ([fileManager fileExistsAtPath:path isDirectory:&isDirectory] && !isDirectory) {
        fileName = [path lastPathComponent];
        
        // create directory to move files to
        [pathComponents removeAllObjects];
        [pathComponents addObjectsFromArray:[[path stringByDeletingLastPathComponent] pathComponents]];
        [pathComponents addObject:currentDate];
        
        organiseDirectory = [NSString pathWithComponents:pathComponents];
        [fileManager createDirectoryAtPath:organiseDirectory withIntermediateDirectories:YES attributes:nil error:&error]; // TODO: use error object
        
        // set the new file path
        [pathComponents addObject:fileName];
        
        // rename file if necessary
        int x = 1;
        while ([fileManager fileExistsAtPath:[NSString pathWithComponents:pathComponents]]) {
          [pathComponents removeLastObject];
          
          if ([[fileName pathExtension] length] == 0)
            newFileName = [NSString stringWithFormat:@"%@ %i", fileName, x++];
          else
            newFileName = [NSString stringWithFormat:@"%@ %i.%@", [fileName stringByDeletingPathExtension], x++, [fileName pathExtension]];
          
          [pathComponents addObject:newFileName];  
        }
        
        // move file to new path
        organiseDirectory = [NSString pathWithComponents:pathComponents];
        [fileManager moveItemAtPath:path toPath:organiseDirectory error:&error];

        // add file path to output array
        [pathComponents removeLastObject];
        organiseDirectory = [NSString pathWithComponents:pathComponents];

        if (![output containsObject:organiseDirectory]) [output addObject:organiseDirectory];
      }
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
