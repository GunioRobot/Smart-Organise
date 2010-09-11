//
//  Collect Similar Items.m
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

#import "Collect Similar Items.h"


@implementation Collect_Similar_Items

- (id)runWithInput:(id)input fromAction:(AMAction *)anAction error:(NSDictionary **)errorInfo {
  // set work vars
  output = [NSMutableArray array];
  fileManager = [NSFileManager defaultManager];

  // iterate over the input
  objectEnumerator = [input objectEnumerator];
  
  while (path = [objectEnumerator nextObject]) {
    @try {
      fileName = [path lastPathComponent];
      
      if ([[fileName pathExtension] length] == 0) continue;
        
      // create directory to move files to
      pathComponents = [NSMutableArray array];
      [pathComponents addObject:[path stringByDeletingLastPathComponent]];

      // enumerator for the containing directory
      organiseDirectory = [NSString pathWithComponents:pathComponents];
      directoryEnumerator = [[fileManager contentsOfDirectoryAtPath:organiseDirectory 
                                                              error:NULL] objectEnumerator];

      // new directory with name of extension
      [pathComponents addObject:[fileName pathExtension]];
      organiseDirectory = [NSString pathWithComponents:pathComponents];
      [fileManager createDirectoryAtPath:organiseDirectory
             withIntermediateDirectories:YES
                              attributes:nil 
                                   error:NULL];
                    
      // iterate over the container directory looking for files with the same extension
      while (currentFile = [directoryEnumerator nextObject]) {

        if (![[currentFile pathExtension] isEqualToString:[fileName pathExtension]]) 
          continue;
              
        // set the current file name
        [pathComponents removeLastObject];
        [pathComponents addObject:currentFile];
        organiseDirectory = [NSString pathWithComponents:pathComponents];

        // set the new file path, renaming if necessary
        [pathComponents removeLastObject];
        [pathComponents addObject:[fileName pathExtension]];
        [pathComponents addObject:currentFile];
        
        int x = 1;
        while ([fileManager fileExistsAtPath:[NSString pathWithComponents:pathComponents]]) {
          [pathComponents removeLastObject];
          
          newFileName = [NSString stringWithFormat:@"%@ %i.%@", 
                         [fileName stringByDeletingPathExtension], x++, [currentFile pathExtension]];
          
          [pathComponents addObject:newFileName];  
        }
        
        // move file to new path
        newFileName = [NSString pathWithComponents:pathComponents];
        [fileManager moveItemAtPath:organiseDirectory toPath:newFileName error:&error];
        
        // add file path to output array
        [pathComponents removeLastObject];
        organiseDirectory = [NSString pathWithComponents:pathComponents];
        
        if (![output containsObject:organiseDirectory])
          [output addObject:organiseDirectory];
     } // while [directoryEnumerator nextObject]
    } @catch (NSException *e) {
      // TODO: handle exception properly
    } // try catch
  } // while [enumerator nextObject]
  
  [[NSGarbageCollector defaultCollector] collectExhaustively]; // explicitly release memory

	return output;
} 

@end
