//
//  Collect Similar Items.m
//  Collect Similar Items
//
//  Created by Mannie Tagarira on 24/06/2010.
//  Copyright (c) 2010 Mannie Tagarira, All Rights Reserved.
//

#import "Collect Similar Items.h"


@implementation Collect_Similar_Items

- (id)runWithInput:(id)input fromAction:(AMAction *)anAction error:(NSDictionary **)errorInfo {
  // set work vars
  output = [NSMutableArray arrayWithCapacity:[input count]];
  fileManager = [NSFileManager defaultManager];

  // iterate over the input
  enumerator = [input objectEnumerator];
  
  while (path = [enumerator nextObject]) {
    @try {
      fileName = [path lastPathComponent];
      
      if ([[fileName pathExtension] length] == 0) continue;

      // create directory to move files to
      pathComponents = [NSMutableArray arrayWithCapacity:3];
      [pathComponents addObject:[path stringByDeletingLastPathComponent]];
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
      [fileManager moveItemAtPath:path toPath:organiseDirectory error:&error];
      
      // add file path to output array
      [pathComponents removeLastObject];
      organiseDirectory = [NSString pathWithComponents:pathComponents];
      
      if (![output containsObject:organiseDirectory])
        [output addObject:organiseDirectory];
    } @catch (NSException *e) {
      // TODO: handle exception properly
    } // try catch
  } // while [enumerator nextObject]
  
	return output;
} 

@end
