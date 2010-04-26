//
//  repayViewController.m
//  IHM
//
//  Created by Adrien on 29/03/10.
//  Copyright 2010 Ensimag. All rights reserved.
//

#import "repayViewController.h"
#import "sqlite3.h"

#define SORT_AMOUNT 0
#define SORT_DATE 1
#define SORT_PERSON 2
#define SORT_EVENT 3



static int MyCallback(void *context, int count, char **values, char **colums)
{
	
	// TODO
	NSMutableArray *result = (NSMutableArray *)context;
	for (int i = 0; i < count; i++) {
		const char *nameCString = values[i];
		[result addObject:[NSString stringWithUTF8String:nameCString]];
	}
	return SQLITE_OK;
}

@implementation repayViewController



@synthesize reinit;
@synthesize validate;
@synthesize value;
@synthesize deptList;



- (void) loadDebts:(int)sort
{
	NSString *query = @"SELECT P.name, D.amount, D.currency, E.name, E.date FROM event E, debt D, person P WHERE D.id_event = E.id AND D.id_person = P.id SORT BY ";
	
	NSString *file = [[NSBundle mainBundle] pathForResource:@"debts" ofType:@"db"];
	sqlite3 *database = NULL;
	
	switch (sort) {
		case SORT_AMOUNT:
			query = [query stringByAppendingString:@"D.amount DESC;"];
			break;
		case SORT_DATE:
			query = [query stringByAppendingString:@"E.date DESC;"];
			break;
		case SORT_PERSON:
			query = [query stringByAppendingString:@"P.name ASC;"];
			break;
		case SORT_EVENT:
			query = [query stringByAppendingString:@"E.name ASC;"];
			break;
		default:
			query = [query stringByAppendingString:@"P.name ASC;"];
			break;
	}
	
	if (sqlite3_open([file UTF8String], &database) == SQLITE_OK) {
		if (sqlite3_exec(database, [query UTF8String], MyCallback, debtList, NULL) != SQLITE_OK) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"SQLITEAlert" message:@"Error while executing query" delegate:self cancelButtonTitle:@"Cancel"  otherButtonTitles: nil];
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



/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


- (void)keyboardWillShow:(NSNotification *)note {  
    // create custom button
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(0, 163, 106, 53);
    doneButton.adjustsImageWhenHighlighted = NO;
    if ([[[UIDevice currentDevice] systemVersion] hasPrefix:@"3"]) {
        [doneButton setImage:[UIImage imageNamed:@"DoneUp3.png"] forState:UIControlStateNormal];
        [doneButton setImage:[UIImage imageNamed:@"DoneDown3.png"] forState:UIControlStateHighlighted];
    } else {        
        [doneButton setImage:[UIImage imageNamed:@"DoneUp.png"] forState:UIControlStateNormal];
        [doneButton setImage:[UIImage imageNamed:@"DoneDown.png"] forState:UIControlStateHighlighted];
    }
    [doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
	
    // locate keyboard view
    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    UIView* keyboard;
    for(int i=0; i<[tempWindow.subviews count]; i++) {
        keyboard = [tempWindow.subviews objectAtIndex:i];
        // keyboard view found; add the custom button to it
        if([[keyboard description] hasPrefix:@"<UIKeyboard"] == YES)
            [keyboard addSubview:doneButton];
    }
}

- (void)doneButton:(id)sender {
    NSLog(@"Input: %@", value.text);
    [value resignFirstResponder];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(keyboardWillShow:) 
												 name:UIKeyboardWillShowNotification 
											   object:nil];
    [super viewDidLoad];
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
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (IBAction) TextFieldDownEditing:(id)sender {
	[sender resignFirstResponder];
	/*if (![montant.text isEqualToString:@""] && ![personnes.text isEqualToString:@""] && ![cause.text isEqualToString:@""]) {
		valider.enabled = YES;
		[valider setTitleColor:[UIColor colorWithRed:0.2f green:0.31f blue:0.52f alpha:1.0f] forState:UIControlStateNormal];
	}*/
}


@end
