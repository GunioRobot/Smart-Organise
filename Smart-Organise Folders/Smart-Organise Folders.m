//
//  Smart-Organise Folders.m
//  Smart-Organise
//
//  Created by Mannie Tagarira on 24/06/2010.
//  Copyright (c) 2010 Mannie Tagarira, All Rights Reserved.

/*
 This file is part of Smart-Organise.
 
 Smart-Organise is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 Smart-Organise is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with Smart-Organise.  If not, see <http://www.gnu.org/licenses/lgpl.html>.
 */ 

#import "Smart-Organise Folders.h"


@implementation Smart_Organise_Folders

- (id)runWithInput:(id)input fromAction:(AMAction *)anAction error:(NSDictionary **)errorInfo {
  // set work vars
  output = [NSMutableArray arrayWithCapacity:[input count]];
  fileManager = [NSFileManager defaultManager];
  
  // iterate over the input
  inputEnumerator = [input objectEnumerator];
  
  while (currentPath = [inputEnumerator nextObject]) {
    directoryEnumerator = [fileManager enumeratorAtPath:currentPath];
    
    while (fileName = [directoryEnumerator nextObject]) {
      @try {        
        if ([[fileName pathExtension] length] == 0) continue;
        
        // construct the path to the current file
        pathComponents = [NSMutableArray arrayWithCapacity:3];
        [pathComponents addObject:currentPath];
        [pathComponents addObject:fileName];
        
        filePath = [NSString pathWithComponents:pathComponents];
        
        // create directory to move files to
        [pathComponents removeLastObject];
        [pathComponents addObject:[fileName pathExtension]];
        
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
          
          newFileName = [NSString stringWithFormat:@"%@ %i.%@", 
                         [fileName stringByDeletingPathExtension], x++, [fileName pathExtension]];
          
          [pathComponents addObject:newFileName];  
        }
        
        // move file to new path
        organiseDirectory = [NSString pathWithComponents:pathComponents];
        [fileManager moveItemAtPath:filePath toPath:organiseDirectory error:&error];
        
        // add file path to output array
        [pathComponents removeLastObject];
        organiseDirectory = [NSString pathWithComponents:pathComponents];
        
        if (![output containsObject:organiseDirectory])
          [output addObject:organiseDirectory];
      } @catch (NSException *e) {
        // TODO: handle exception properly
      } // try catch
    } // while [directoryEnumerator nextObject]
    
  } // while [inputEnumerator nextObject]
  
	return output;
}

@end
