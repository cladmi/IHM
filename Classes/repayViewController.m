//
//  repayViewController.m
//  IHM
//
//  Created by Adrien on 29/03/10.
//  Copyright 2010 Ensimag. All rights reserved.
//

#import "repayViewController.h"
#import "sqlite3.h"



@implementation repayViewController



@synthesize reinit;
@synthesize validate;
@synthesize value;
@synthesize debtList;
@synthesize queryResults;




- (void) loadDebts
{
	NSString *query = @"SELECT D.id, P.name, D.amount, D.currency, E.name, E.date FROM event E, debt D, person P  WHERE D.id_event = E.id AND D.id_person = P.id ORDER BY P.name ASC";

	NSString *file = [[NSBundle mainBundle] pathForResource:@"debts_new" ofType:@"db"];
	sqlite3 *database = NULL;

	
	if (sqlite3_open([file UTF8String], &database) == SQLITE_OK) {
		sqlite3_stmt *cs; // compiledStatement
		if(sqlite3_prepare_v2(database, [query UTF8String], -1, &cs, NULL) == SQLITE_OK) {
			
			queryResults = [[NSMutableArray alloc] init];
			
			while(sqlite3_step(cs) == SQLITE_ROW) {
				NSMutableDictionary *row = [[NSMutableDictionary alloc] init];
				
				[row setValue:[NSNumber numberWithInt:(int) sqlite3_column_int(cs, 0)]				forKey:@"id"]; 						   
				[row setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(cs, 1)]	forKey:@"name"];
				[row setValue:[NSNumber numberWithDouble:(double) sqlite3_column_double(cs, 2)]	forKey:@"amount"];
				// les devises sont dans IHM_Prefix.pch sous forme de #define	
				[row setValue:[NSNumber numberWithInt:(int) sqlite3_column_int(cs, 3)]				forKey:@"currency"]; 				
				[row setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(cs, 4)]	forKey:@"event"];
				[row setValue:[NSNumber numberWithLong:(long) sqlite3_column_double(cs, 5)]		forKey:@"date"];
				[row setValue:[NSNumber numberWithBool:NO]											forKey:@"selected"];
			
		
				[queryResults addObject:row];
				
				[row release];
			}
		} else {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"SQLITEAlert" message:@"Error while executing query" delegate:self cancelButtonTitle:@"Cancel"  otherButtonTitles: nil];
			[alert show];
			[alert release];
			[queryResults release];
			queryResults = nil;
		}
		sqlite3_finalize(cs);
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"SQLITEAlert" message:@"Error opening file" delegate:self cancelButtonTitle:@"OK"  otherButtonTitles: nil];
		[alert show];
		[alert release];
		[queryResults release];
		queryResults = nil;
		
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





// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {

	
	[self loadDebts];

	format = [[NSDateFormatter alloc] init];
	[format setDateFormat:@"dd MMM yyyy"];
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
/*
- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}
 */


- (void)dealloc {


	
	[format release];
    [super dealloc];
}

- (IBAction) reset:(id)sender {
	for (NSMutableDictionary *row in queryResults) {
		if ([[row objectForKey:@"selected"] boolValue]) {
			value.text = [NSString stringWithFormat:@"%8.2f",[value.text floatValue] + [[row objectForKey:@"amount"] floatValue]];
		}
		[row setValue:[NSNumber numberWithBool:FALSE] forKey:@"selected"];
	}	
	[debtList reloadData];
}



- (void) reimburseDebt {
	NSString *query;
	sqlite3 *database;
	
	NSString *file = [[NSBundle mainBundle] pathForResource:@"debts_new" ofType:@"db"];
	if (sqlite3_open([file UTF8String], &database) == SQLITE_OK) {
		
		for (NSDictionary *row in queryResults) {
			if ([[row objectForKey:@"selected"] boolValue]) {
				
				query = [NSString stringWithFormat:@"DELETE FROM debt WHERE id=%d", [[row objectForKey:@"id"] intValue]];
				
				if(sqlite3_exec(database, [query UTF8String], 0, 0, 0) != SQLITE_OK) {
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"SQLITEAlert" message:@"Error while deleting entry" delegate:self cancelButtonTitle:@"Annuler"  otherButtonTitles: nil];
					[alert show];
					[alert release];
				}
			}
			
		}
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"SQLITEAlert" message:@"Error opening file" delegate:self cancelButtonTitle:@"OK"  otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
	
	sqlite3_close(database);
}

- (IBAction) validate:(id)sender {
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"Rembourser dettes" 
						  message:@""
						  delegate:self 
						  cancelButtonTitle:@"Annuler" 
						  otherButtonTitles:@"Oui",nil];
	alert.message = @"Je veux rembourser les dettes sélectionnées";
	[alert show];
	[alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSLog(@"Button %d pushed",buttonIndex);
	if(buttonIndex == 1) {
		[self reimburseDebt];
		[self.navigationController popViewControllerAnimated:YES];
	}
}

- (IBAction) TextFieldDownEditing:(id)sender {
	[sender resignFirstResponder];	
}

/*
#define SORT_AMOUNT 0	on trie en décroissant
#define SORT_DATE 1		on trie en décroissant
#define SORT_PERSON 2	on trie en croissant
#define SORT_EVENT 3	on trie en croissant
 
 on utilise le 4è bit de sort_type comme indicateur de croissance ou décroissance pour le tri
 */


NSComparisonResult sortFunction (id first, id second, void *context) {

	
	NSString *key;
	int sort = (int) context;
	NSComparisonResult result;
	switch (sort & 7) {
		case SORT_AMOUNT :
			key = @"amount";
			break;
		case SORT_DATE :
			key = @"date";
			break;
		case SORT_PERSON :
			key = @"name";
			break;
		case SORT_EVENT :
			key = @"event";
			break;
		default:
			key = @"name";
			break;

	}
	NSLog(@" sort by %@", key);
	NSLog(@" ascending : %d", (sort & 8));
	result = [[first objectForKey:key] compare: [second objectForKey:key]];
	[key release];
	
	if (result == NSOrderedSame) {
		return NSOrderedSame;
	} else if (sort & 8) {
		return result;
	} else {
		if (result == NSOrderedAscending) {
			return NSOrderedDescending;
		} else {
			return NSOrderedAscending;
		}
	}
	return 42; 

}

- (IBAction) sort:(id)sender {
	
	//NSLog(@" tag = %d, sort_type = %4d", [sender tag], sort_type);
	if ([sender tag] == (sort_type & 7)) {
		if (sort_type & 8) {
			sort_type = [sender tag];
		} else {
			sort_type = [sender tag] + 8;
		}
	//	sort_type = sort_type ^ (sort_type & 8);
	//	NSLog(@" sort_type = %4d", sort_type);
	} else {
		if ([sender tag] >= 2) {
			sort_type = [sender tag] + 8;
		} else {
			sort_type = [sender tag];
		}
	//	NSLog(@" sort_type else = %4d", sort_type);
	}
	//	NSLog(@" type de trie %d", (sort_type & 7));
	[queryResults sortUsingFunction:&sortFunction context:(void *)sort_type];
	[queryResults sortUsingFunction:&sortFunction context:(void *)(sort_type ^ 8)];
	[queryResults sortUsingFunction:&sortFunction context:(void *)sort_type];
	[debtList reloadData];
	
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

	// Content of the cell
	double amount = [[[queryResults objectAtIndex:indexPath.row] objectForKey:@"amount"] doubleValue];
	// assumed that currency == €	
	// cellvalue = "name amount currency"
	// detailvalue = "date event"
	cell.textLabel.text = [NSString stringWithFormat:@"%@ %.2f €",
						   [[queryResults objectAtIndex:indexPath.row] objectForKey:@"name"],
						   amount];
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",
								 [format stringFromDate:[NSDate dateWithTimeIntervalSince1970:	
														 [[[queryResults objectAtIndex:indexPath.row] objectForKey:@"date"] longValue]]],
								 [[queryResults objectAtIndex:indexPath.row] objectForKey:@"event"]];
	
	if (amount > 0) {
		cell.textLabel.textColor = [[UIColor alloc] initWithHue:0.005 saturation:0.87 brightness:0.78 alpha:1.0];	//Red
	} else {
		cell.textLabel.textColor = [[UIColor alloc] initWithHue:0.34 saturation:0.83 brightness:0.44 alpha:1.0];	//Green
	}
	
	// Checked ?
	if ([[[queryResults objectAtIndex:indexPath.row] objectForKey:@"selected"] boolValue]) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
    return cell;
}

// Select/unselect cells with checkmarks and updates amount
- (void)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	if ([[[queryResults objectAtIndex:indexPath.row] objectForKey:@"selected"] boolValue]) {
		[[queryResults objectAtIndex:indexPath.row] setValue:[NSNumber numberWithBool:FALSE] forKey:@"selected"];
		[tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
		value.text = [NSString stringWithFormat:@"%.2f",[value.text floatValue] + [[[queryResults objectAtIndex:indexPath.row] objectForKey:@"amount"] longValue]];
	} else {
		[[queryResults objectAtIndex:indexPath.row] setValue:[NSNumber numberWithBool:TRUE] forKey:@"selected"];
		[tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
		value.text = [NSString stringWithFormat:@"%.2f",[value.text floatValue] - [[[queryResults objectAtIndex:indexPath.row] objectForKey:@"amount"] longValue]];
		
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
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	return @" ";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [queryResults count];
	//return [nameArray count];
}

@end
