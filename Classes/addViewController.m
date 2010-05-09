//
//  addViewController.m
//  IHM
//
//  Created by Adrien on 29/03/10.
//  Copyright 2010 Ensimag. All rights reserved.
//

#import "addViewController.h"
#import "personAndEventPickerViewController.h"
#import "sqlite3.h"


@implementation addViewController

@synthesize montant;
@synthesize personnes;
@synthesize cause;
@synthesize valider;
@synthesize personID;
@synthesize eventID;


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
	causeEditActive = NO;
	valider.enabled = NO;
	[valider setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
	personsArray = [[NSMutableArray alloc] init];
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
		causeEditActive = NO;
	}
	if (![montant.text isEqualToString:@""] && ![personnes.text isEqualToString:@""] && ![cause.text isEqualToString:@""]) {
		valider.enabled = YES;
		[valider setTitleColor:[UIColor colorWithRed:0.2f green:0.31f blue:0.52f alpha:1.0f] forState:UIControlStateNormal];
	}
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	//NSLog(@"auie");
	return NO;
}
 
	
- (IBAction) openList:(id)sender {
	//NSLog(@"coucou");
	[personnes resignFirstResponder];
	
	personAndEventPickerViewController *pViewController = [[personAndEventPickerViewController alloc] initWithNibName:@"personAndEventPickerViewController" bundle:nil];

	navController = [[UINavigationController alloc] init];
	pViewController.fatherController = self;
	
	if (sender == personnes) {
		pViewController.isTypePerson = TRUE;
	} else if (sender == cause) {
		pViewController.isTypePerson = FALSE;
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"openList Alert" message:@"action performed by someone else than personnes or cause" delegate:self cancelButtonTitle:@"Cancel"  otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
	
	[navController pushViewController:pViewController animated:NO];
	[pViewController release];
	//[self presentModalViewController:pViewController animated:YES];
	[self presentModalViewController:navController animated:YES];
	[navController release];
}


- (void) addDebt {

	NSString *query;
	query = [NSString stringWithFormat:@"INSERT INTO debt (amount, currency, id_person, id_event) VALUES (%f, 0, %d,%d)", [montant.text floatValue], personID, eventID];		
		
		sqlite3 *database = NULL;
		NSString *file = [[NSBundle mainBundle] pathForResource:@"debts_new" ofType:@"db"];
		
		if (sqlite3_open([file UTF8String], &database) == SQLITE_OK) {
			if(sqlite3_exec(database, [query UTF8String], 0, 0, 0) != SQLITE_OK) {
									
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"SQLITEAlert" message:@"Error while adding debt" delegate:self cancelButtonTitle:@"Annuler"  otherButtonTitles: nil];
				[alert show];
				[alert release];
				
			}
		} else {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"SQLITEAlert" message:@"Error opening file" delegate:self cancelButtonTitle:@"OK"  otherButtonTitles: nil];
			[alert show];
			[alert release];
		}
		sqlite3_close(database);
}


- (IBAction) ValidateDept:(id)sender {
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"Ajouter Dette" 
						  message:@""
						  delegate:self 
						  cancelButtonTitle:@"Annuler" 
						  otherButtonTitles:@"OK",nil];
	if ([self.title isEqualToString:@"On me prête"]) {
		alert.message = [NSString stringWithFormat:@"%@ m'avance %@€ pour \"%@\"",personnes.text,montant.text,cause.text];
	} else {
		alert.message = [NSString stringWithFormat:@"J'avance %@€ à %@ pour \"%@\"",montant.text,personnes.text,cause.text];
	}
	[alert show];
	[alert release];
}


/* delegate methode for the pickerviewController */

- (void) dimsissWithType:(BOOL)isTypePerson Name:(NSString *)text Id:(int)identifier {
	[text retain];
	if (isTypePerson) {
		personnes.text = text;
		personID = identifier;
	} else {
		cause.text = text;
		eventID = identifier;
	}
	[self dismissModalViewControllerAnimated:YES];
	if (![montant.text isEqualToString:@""] && ![personnes.text isEqualToString:@""] && ![cause.text isEqualToString:@""]) {
		valider.enabled = YES;
		[valider setTitleColor:[UIColor colorWithRed:0.2f green:0.31f blue:0.52f alpha:1.0f] forState:UIControlStateNormal];
	}
}
		
		





- (IBAction) UpView:(id)sender {
	if (!causeEditActive) {
		causeEditActive = YES;
		[UIView beginAnimations:@"1" context:nil];
		self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 100, self.view.frame.size.width, self.view.frame.size.height);
		[UIView commitAnimations];
	}	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSLog(@"Button %d pushed",buttonIndex);
	if(buttonIndex == 1) {
		[self addDebt];
		[self.navigationController popViewControllerAnimated:YES];
	}
}


@end
