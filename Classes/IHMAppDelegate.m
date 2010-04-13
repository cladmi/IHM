//
//  IHMAppDelegate.m
//  IHM
//
//  Created by Adrien on 29/03/10.
//  Copyright Ensimag 2010. All rights reserved.
//

#import "IHMAppDelegate.h"
#import "homeViewController.h"

@implementation IHMAppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	
	navController = [[UINavigationController alloc] init];
	
	homeViewController *hviewcontroller = [[homeViewController alloc] initWithNibName:@"homeView" bundle:nil];
	[navController pushViewController:hviewcontroller animated:NO];
	[hviewcontroller release];
	
	[window addSubview:navController.view];
	
	

    // Override point for customization after application launch
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
