//
//  Organise By Date.m
//  Organise By Date
//
//  Created by Mannie Tagarira on 24/06/2010.
//  Copyright (c) 2010 Mannie Tagarira, All Rights Reserved.
//

#import "Organise By Date.h"


@implementation Organise_By_Date

- (id)runWithInput:(id)input fromAction:(AMAction *)anAction error:(NSDictionary **)errorInfo {
  // set work vars
  output = [NSMutableArray arrayWithCapacity:[input count]];
  fileManager = [NSFileManager defaultManager];
  
  // set the current date in format YYYY-MM-DD
  currentDate = [[NSDate date] descriptionWithCalendarFormat:@"%Y-%m-%d"
                                                    timeZone:nil
                                                      locale:nil];
  
  // iterate over the input
  enumerator = [input objectEnumerator];
  while (path = [enumerator nextObject]) {
    @try {
      if ([fileManager fileExistsAtPath:path isDirectory:&isDirectory] && !isDirectory) {
        fileName = [path lastPathComponent];
        
        // create directory to move files to
        pathComponents = [NSMutableArray arrayWithCapacity:3];
        [pathComponents addObject:[path stringByDeletingLastPathComponent]];
        [pathComponents addObject:currentDate];
        
        organiseDirectory = [NSString pathWithComponents:pathComponents];
        [fileManager createDirectoryAtPath:organiseDirectory
               withIntermediateDirectories:YES
                                attributes:nil 
                                     error:NULL];
        
        // set the new file path, renaming if necessary
        [pathComponents addObject:fileName];
        
        int x = 1;
        while ([fileManager fileExistsAtPath:[NSString pathWithComponents:pathComponents]]) {
          [pathComponents removeLastObject];

          
          if ([[fileName pathExtension] length] == 0)
            newFileName = [NSString stringWithFormat:@"%@ %i", fileName, x++];
          else
            newFileName = [NSString stringWithFormat:@"%@ %i.%@", 
                           [fileName stringByDeletingPathExtension], x++, [fileName pathExtension]];
          
          [pathComponents addObject:newFileName];  
        }
        
        // move file to new path
        organiseDirectory = [NSString pathWithComponents:pathComponents];
        [fileManager moveItemAtPath:path toPath:organiseDirectory error:&error];

        // add file path to output array
        [pathComponents removeLastObject];
        organiseDirectory = [NSString pathWithComponents:pathComponents];

        if (![output containsObject:organiseDirectory])
          [output addObject:organiseDirectory];
      }
    } @catch (NSException *e) {
      // TODO: handle exception properly
    } // try catch
  } // while [enumerator nextObject]
    
	return output;
}

@end
