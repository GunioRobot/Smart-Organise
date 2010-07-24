//
//  Collect Similar Items.h
//  Smart-Organise
//
//  Created by Mannie Tagarira on 24/06/2010.
//  Copyright (c) 2010 Mannie Tagarira.

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

#import <Cocoa/Cocoa.h>
#import <Automator/AMBundleAction.h>

@interface Collect_Similar_Items : AMBundleAction {
  NSMutableArray *output;
  NSFileManager *fileManager;
  NSString *organiseDirectory;
    
  NSEnumerator *objectEnumerator;
  NSEnumerator *directoryEnumerator;

  NSError *error;

  NSString *path;
  NSString *currentFile;
  NSString *fileName;
  NSString *newFileName;
  
  NSMutableArray *pathComponents;  
}

- (id)runWithInput:(id)input fromAction:(AMAction *)anAction error:(NSDictionary **)errorInfo;

@end
