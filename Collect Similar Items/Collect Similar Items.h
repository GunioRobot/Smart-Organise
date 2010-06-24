//
//  Collect Similar Items.h
//  Collect Similar Items
//
//  Created by Mannie Tagarira on 24/06/2010.
//  Copyright (c) 2010 Mannie Tagarira, All Rights Reserved.
//

#import <Cocoa/Cocoa.h>
#import <Automator/AMBundleAction.h>

@interface Collect_Similar_Items : AMBundleAction {
  NSMutableArray *output;
  NSFileManager *fileManager;
  NSString *organiseDirectory;
  
  NSEnumerator *enumerator;
  NSError *error;
  id path;

  NSString *fileName;
  NSString *newFileName;
  
  NSMutableArray *pathComponents;  
}

- (id)runWithInput:(id)input fromAction:(AMAction *)anAction error:(NSDictionary **)errorInfo;

@end
