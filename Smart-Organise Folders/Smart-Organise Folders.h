//
//  Smart-Organise Folders.h
//  Smart-Organise
//
//  Created by Mannie Tagarira on 24/06/2010.
//  Copyright (c) 2010 Mannie Tagarira.


#import <Cocoa/Cocoa.h>
#import <Automator/AMBundleAction.h>

@interface Smart_Organise_Folders : AMBundleAction {
  NSMutableArray *output;
  NSFileManager *fileManager;

  NSString *organiseDirectory;
  
  NSEnumerator *inputEnumerator;
  NSEnumerator *directoryEnumerator;
  
  NSError *error;
  
  NSDictionary *fileAttributes;

  NSString *currentPath;
  NSString *filePath;
  NSString *fileName;
  NSString *newFileName;
  
  NSMutableArray *pathComponents;    
}

- (id)runWithInput:(id)input fromAction:(AMAction *)anAction error:(NSDictionary **)errorInfo;

@end
