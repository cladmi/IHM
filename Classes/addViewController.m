//
//  addViewController.m
//  IHM
//
//  Created by Adrien on 29/03/10.
//  Copyright 2010 Ensimag. All rights reserved.
//

#import "addViewController.h"


@implementation addViewController

@synthesize montant;
@synthesize personnes;
@synthesize cause;
@synthesize valider;


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		self.title = @"Ajouter dette";
    }
    return self;
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	valider.enabled = NO;
	[valider setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
}


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

- (IBAction) TextFieldDownEditing:(id)sender {
	[sender resignFirstResponder];
	if ([sender isEqual:cause]) {
		[UIView beginAnimations:@"1" context:nil];
		self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 100, self.view.frame.size.width, self.view.frame.size.height);
		[UIView commitAnimations];
	}
	if (![montant.text isEqualToString:@""] && ![personnes.text isEqualToString:@""] && ![cause.text isEqualToString:@""]) {
		valider.enabled = YES;
		[valider setTitleColor:[UIColor colorWithRed:0.2f green:0.31f blue:0.52f alpha:1.0f] forState:UIControlStateNormal];
	}
}

- (IBAction) ValidateDept:(id)sender {
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"Dette ajoutée" 
						  message:[NSString stringWithFormat:@"Dette de %@€ ajoutée à %@ avec succès",montant.text,personnes.text] 
						  delegate:nil 
						  cancelButtonTitle:@"Fermer" 
						  otherButtonTitles:nil];
	[alert show];
	[alert release];
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) UpView:(id)sender {
	[UIView beginAnimations:@"1" context:nil];
	self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 100, self.view.frame.size.width, self.view.frame.size.height);
	[UIView commitAnimations];
}
	

@end
