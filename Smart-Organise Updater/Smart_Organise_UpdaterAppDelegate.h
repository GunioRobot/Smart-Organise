//
//  Smart_Organise_UpdaterAppDelegate.h
//  Smart-Organise Updater
//
//  Created by Mannie Tagarira on 29/06/2010.
//  Copyright (c) 2010 Mannie Tagarira, Some Rights Reserved.

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
#import <Sparkle/Sparkle.h>

@interface Smart_Organise_UpdaterAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
