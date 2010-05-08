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
		if (sqlite3_exec(database, [query UTF8String], MyCallback, nameArray, NULL) != SQLITE_OK) {
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


// Adds the Done button
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

// Closes the keybord when the Done button is pressed
- (void)doneButton:(id)sender {
    //NSLog(@"Input: %@", value.text);
    [value resignFirstResponder];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(keyboardWillShow:) 
												 name:UIKeyboardWillShowNotification 
											   object:nil];
	
	nameArray = [[NSMutableArray alloc] init];
	[nameArray addObject:@"Adrien"];
	[nameArray addObject:@"Gaëtan"];
	[nameArray addObject:@"Paul"];
	[nameArray addObject:@"Pierre"];
	[nameArray addObject:@"Nicolas"];
	[nameArray addObject:@"Thibault"];
	[nameArray addObject:@"Matthieu"];
	[nameArray addObject:@"Romain"];
	
	eventArray = [[NSMutableArray alloc] init];
	[eventArray addObject:@"Beer"];
	[eventArray addObject:@"Beer"];
	[eventArray addObject:@"S*N*"];
	[eventArray addObject:@"Kfet"];
	[eventArray addObject:@"Old debt"];
	[eventArray addObject:@"Something strange"];
	[eventArray addObject:@"Even stranger"];
	[eventArray addObject:@"Sandwich"];
	
	dateArray = [[NSMutableArray alloc] init];
	[dateArray addObject:@"12/01/04"];
	[dateArray addObject:@"22/12/01"];
	[dateArray addObject:@"15/05/99"];
	[dateArray addObject:@"01/01/01"];
	[dateArray addObject:@"14/02/95"];
	[dateArray addObject:@"04/11/98"];
	[dateArray addObject:@"22/01/02"];
	[dateArray addObject:@"27/08/03"];
	
	amountArray = [[NSMutableArray alloc] init];
	[amountArray addObject:@"12.55"];
	[amountArray addObject:@"-21.50"];
	[amountArray addObject:@"120.00"];
	[amountArray addObject:@"0.24"];
	[amountArray addObject:@"-12.90"];
	[amountArray addObject:@"25.00"];
	[amountArray addObject:@"-100.50"];
	[amountArray addObject:@"4.80"];
	
	selectArray = [[NSMutableArray alloc] init];
	[selectArray addObject:[NSNumber numberWithBool:NO]];
	[selectArray addObject:[NSNumber numberWithBool:NO]];
	[selectArray addObject:[NSNumber numberWithBool:NO]];
	[selectArray addObject:[NSNumber numberWithBool:NO]];
	[selectArray addObject:[NSNumber numberWithBool:NO]];
	[selectArray addObject:[NSNumber numberWithBool:NO]];
	[selectArray addObject:[NSNumber numberWithBool:NO]];
	[selectArray addObject:[NSNumber numberWithBool:NO]];

	
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
	[nameArray release];
	[eventArray release];
	[dateArray release];
	[selectArray release];
    [super dealloc];
}

- (IBAction) reset:(id)sender {
	int i;
	for (i = 0; i < [selectArray count]; i++) {
		if ([selectArray objectAtIndex:i] == [NSNumber numberWithBool:YES]) {
			value.text = [NSString stringWithFormat:@"%8.2f",[value.text floatValue] + [[amountArray objectAtIndex:i] floatValue]];
		}
		[selectArray replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:FALSE]];
	}	
	[deptList reloadData];
}

- (IBAction) validate:(id)sender {
	
}

- (IBAction) TextFieldDownEditing:(id)sender {
	[sender resignFirstResponder];
	
}



/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * * IMPLEMENTATION DU TABLE VIEW DELEGATE * * * * * * * * * * * * * * * *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
		//cell.accessoryType = nil;
    }
	
	// Checked ?
	if ([[selectArray objectAtIndex:indexPath.row] boolValue]) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
		
	
	// Content of the cell
	NSString *nameValue = [nameArray objectAtIndex:indexPath.row];
	NSString *eventValue = [eventArray objectAtIndex:indexPath.row];
	NSString *dateValue = [dateArray objectAtIndex:indexPath.row];
	NSString *amountValue = [amountArray objectAtIndex:indexPath.row];
	
	NSString *cellValue;
	NSString *detailValue;
	
	cellValue = nameValue;
	// Green/Red colors
	if ([amountValue floatValue] > 0) {
		//Red
		cell.textLabel.textColor = [[UIColor alloc] initWithHue:0.005 saturation:0.87 brightness:0.78 alpha:1.0];
	} else if ([amountValue floatValue] < 0) {
		//Green
		cell.textLabel.textColor = [[UIColor alloc] initWithHue:0.34 saturation:0.83 brightness:0.44 alpha:1.0];
	}
	cellValue = [cellValue stringByAppendingString:@" "];
	cellValue = [cellValue stringByAppendingString:amountValue];
	cellValue = [cellValue stringByAppendingString:@" €"];
	cell.textLabel.text = cellValue;
	detailValue = dateValue;
	detailValue = [detailValue stringByAppendingString:@" "];
	detailValue = [detailValue stringByAppendingString:eventValue];
	cell.detailTextLabel.text = detailValue;
    return cell;
}

// Select/unselect cells with checkmarks and updates amount
- (void)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if ([[selectArray objectAtIndex:indexPath.row] boolValue]) {
		[selectArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:NO]];
		[tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
		value.text = [NSString stringWithFormat:@"%8.2f",[value.text floatValue] + [[amountArray objectAtIndex:indexPath.row] floatValue]];
	} else {
		[selectArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:YES]];
		[tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
		value.text = [NSString stringWithFormat:@"%8.2f",[value.text floatValue] - [[amountArray objectAtIndex:indexPath.row] floatValue]];
	}
	[tableView cellForRowAtIndexPath:indexPath].selected = NO;
}


/* 
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {	
	//[tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
}*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Dettes";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	return @" ";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [nameArray count];
}

@end
