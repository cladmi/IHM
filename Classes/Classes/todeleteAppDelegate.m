//
//  todeleteAppDelegate.m
//  todelete
//
//  Created by Adrien on 01/05/10.
//  Copyright Ensimag 2010. All rights reserved.
//

#import "todeleteAppDelegate.h"
#import "RootViewController.h"


@implementation todeleteAppDelegate

@synthesize window;
@synthesize navigationController;


#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
	
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

