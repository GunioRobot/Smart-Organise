//
//  Organise By Date.h
//  Smart-Organise
//
//  Created by Mannie Tagarira on 24/06/2010.
//  Copyright (c) 2010 Mannie Tagarira.


#import <Cocoa/Cocoa.h>
#import <Automator/AMBundleAction.h>

@interface Organise_By_Date : AMBundleAction {
  NSMutableArray *output;
  NSFileManager *fileManager;
  NSString *organiseDirectory;
  
  BOOL isDirectory;  
  NSEnumerator *enumerator;
  NSError *error;
  id path;
  
  NSString *fileName;
  NSString *newFileName;
  
  NSMutableArray *pathComponents;
  
  NSString *currentDate;
}

- (id)runWithInput:(id)input fromAction:(AMAction *)anAction error:(NSDictionary **)errorInfo;

@end
