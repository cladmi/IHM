//
//  homeViewController.m
//  IHM
//
//  Created by Adrien on 29/03/10.
//  Copyright 2010 Ensimag. All rights reserved.
//

#import "homeViewController.h"
#import "addViewController.h"
#import "repayViewController.h"
#import "IHMAppDelegate.h"


@implementation homeViewController



@synthesize ajouterDette;
@synthesize rembourserDette;



- (IBAction) ajouter:(id)sender {
	
	
	addViewController *aviewcontroller = [[addViewController alloc] initWithNibName:@"addView" bundle:nil];
	[self.navigationController pushViewController:aviewcontroller animated:YES];
	[aviewcontroller release];
	
}

- (IBAction) rembourser:(id)sender {
	
	UINavigationController *tabController = [[UINavigationController alloc] init];
	
	addViewController *tviewcontroller = [[repayViewController alloc] initWithNibName:@"repayView" bundle:nil];
	[self.navigationController pushViewController:tviewcontroller animated:YES];
	[tviewcontroller release];
	
//	[((IHMAppDelegate *) [[UIApplication sharedApplication] delegate]).window addSubview:tabController.view];
	[tabController release];

	
}


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		self.title = @"Accueil";
    }
    return self;
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
