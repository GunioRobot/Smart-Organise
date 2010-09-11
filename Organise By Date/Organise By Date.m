//
//  Organise By Date.m
//  Smart-Organise
//
//  Created by Mannie Tagarira on 24/06/2010.
//  Copyright (c) 2010 Mannie Tagarira.

/*
 This file is part of Smart-Organise.
 
 Smart-Organise is free software: you can redistribute it and/or modify
 it under the terms of the GNU Lesser General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 Smart-Organise is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU Lesser General Public License for more details.
 
 You should have received a copy of the GNU Lesser General Public License
 along with Smart-Organise.  If not, see <http://www.gnu.org/licenses/lgpl.html>.
*/ 

#import "Organise By Date.h"


@implementation Organise_By_Date

- (id)runWithInput:(id)input fromAction:(AMAction *)anAction error:(NSDictionary **)errorInfo {
  // set work vars
  output = [NSMutableArray array];
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
        pathComponents = [NSMutableArray array];
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
  
  [[NSGarbageCollector defaultCollector] collectExhaustively]; // explicitly release memory
  
	return output;
}

@end
