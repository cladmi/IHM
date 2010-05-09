//
//  personAndEventPickerViewController.m
//  IHM
//
//  Created by Ta Soeur on 5/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "personAndEventPickerViewController.h"


@implementation personAndEventPickerViewController

@synthesize fatherController;
@synthesize selectionList;
@synthesize newlyAddedList;
@synthesize isTypePerson;
@synthesize addText;



/* 
 *
 *	Our custom methods
 *
 */


- (void) loadDatabase {
	
	
	NSString *query;
	if (isTypePerson) {
		query = @"SELECT id, name FROM person ORDER BY name ASC";
	} else {
		query = @"SELECT id, name, date FROM event ORDER BY name ASC";
	}
	
	
	NSString *file = [[NSBundle mainBundle] pathForResource:@"debts_new" ofType:@"db"];
	sqlite3 *database = NULL;
	
	
	if (sqlite3_open([file UTF8String], &database) == SQLITE_OK) {
		sqlite3_stmt *cs; // compiledStatement
		if(sqlite3_prepare_v2(database, [query UTF8String], -1, &cs, NULL) == SQLITE_OK) {
			
			selectionList = [[NSMutableArray alloc] init];
			
			while(sqlite3_step(cs) == SQLITE_ROW) {
				NSMutableDictionary *row = [[NSMutableDictionary alloc] init];
				
				[row setValue:[NSNumber numberWithInt:(int) sqlite3_column_int(cs, 0)]				forKey:@"id"]; 						   
				[row setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(cs, 1)]	forKey:@"name"];
				if (!isTypePerson) {
					[row setValue:[NSNumber numberWithLong:(long) sqlite3_column_double(cs, 2)]		forKey:@"date"];
					
				}
				[row setValue:[NSNumber numberWithBool:NO]											forKey:@"selected"];
				
				
				[selectionList addObject:row];
				
				[row release];
			}
		} else {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"SQLITEAlert" message:@"Error while executing query" delegate:self cancelButtonTitle:@"Annuler"  otherButtonTitles: nil];
			[alert show];
			[alert release];
			[selectionList release];
			selectionList = nil;
		}
		sqlite3_finalize(cs);
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"SQLITEAlert" message:@"Error opening file" delegate:self cancelButtonTitle:@"OK"  otherButtonTitles: nil];
		[alert show];
		[alert release];
		[selectionList release];
		selectionList = nil;
		
	}
	sqlite3_close(database);
	[tab reloadData];
	
}

- (IBAction) addItem:(id)sender {
	
	
	if (![addText.text  isEqualToString:@""]) {
		NSString *query;
		if (isTypePerson) {
			query = [NSString stringWithFormat:@"INSERT INTO person (name) VALUES ('%@')", addText.text];
		} else {
			query = [NSString stringWithFormat:@"INSERT INTO event (name, date) VALUES ('%@', %f)", addText.text, [[NSDate date] timeIntervalSince1970]];
		}
		
		
		NSString *file = [[NSBundle mainBundle] pathForResource:@"debts_new" ofType:@"db"];
		sqlite3 *database = NULL;
		
		if (sqlite3_open([file UTF8String], &database) == SQLITE_OK) {
			sqlite3_exec(database, "BEGIN", 0, 0, 0);
			if(sqlite3_exec(database, [query UTF8String], 0, 0, 0) == SQLITE_OK) {
				NSLog(@" 3");
				sqlite3_exec(database, "COMMIT", 0, 0, 0);
				
				if (isTypePerson) {
					query = [NSString stringWithFormat:@"SELECT id, name FROM person WHERE name='%@' ORDER BY id DESC LIMIT 1", addText.text];
				} else {
					query = [NSString stringWithFormat:@"SELECT id, name, date FROM event WHERE name='%@' ORDER BY id DESC LIMIT 1", addText.text];
				}
				
				sqlite3_stmt *cs; // compiledStatement
				if(sqlite3_prepare_v2(database, [query UTF8String], -1, &cs, NULL) == SQLITE_OK) {
					if (sqlite3_step(cs) == SQLITE_ROW) {
						NSMutableDictionary *row = [[NSMutableDictionary alloc] init];
						[row setValue:[NSNumber numberWithInt:(int) sqlite3_column_int(cs, 0)]				forKey:@"id"]; 						   
						[row setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(cs, 1)]	forKey:@"name"];
						if (!isTypePerson) {
							[row setValue:[NSNumber numberWithLong:(long) sqlite3_column_double(cs, 2)]		forKey:@"date"];
						}
						[row setValue:[NSNumber numberWithBool:NO]											forKey:@"selected"];
						
						
						[newlyAddedList addObject:row];
						
						[row release];
					} else {
						UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"SQLITEAlert" message:@"Error while searching for data" delegate:self cancelButtonTitle:@"Annuler"  otherButtonTitles: nil];
						[alert show];
						[alert release];
					}
					
				} else {
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"SQLITEAlert" message:@"Error while executing query" delegate:self cancelButtonTitle:@"Annuler"  otherButtonTitles: nil];
					[alert show];
					[alert release];
				}
				sqlite3_finalize(cs);
			}
			
		} else {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"SQLITEAlert" message:@"Error opening file" delegate:self cancelButtonTitle:@"OK"  otherButtonTitles: nil];
			[alert show];
			[alert release];
		}
		sqlite3_close(database);
		[self.addText resignFirstResponder];
		self.addText.text = @"";
		[tab reloadData];
	}
}

- (IBAction) dismiss:(id)sender {
	[fatherController dimsissWithType:isTypePerson	Name:@""  Id:-1];
	
}


- (IBAction) TextFieldDownEditing:(id)sender {
	NSLog(@"sender : %@",sender);
	[sender resignFirstResponder];	
}




/*
 *
 *	//////// End of our custom methodes
 *
 */




/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/


- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self loadDatabase];
	if (isTypePerson) {
		self.title = @"Choisir une personne";
	} else {
		self.title = @"Choisir un évènement";
	}
	
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Annuler" style:UIBarButtonItemStyleBordered target:self action:@selector(dismiss:)];
	self.navigationItem.leftBarButtonItem = backButton;
	[backButton release];
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	format = [[NSDateFormatter alloc] init];
	[format setDateFormat:@"dd MMM yyyy"];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	newlyAddedList = [[NSMutableArray alloc] init];
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
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


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
		if ([newlyAddedList count] == 0) {
			return nil;
		} else {
			if (isTypePerson) {
				return @"Nouvelle(s) personne(s)";
			} else {
				return @"Nouveaux évènements";
			}
		}
	}
	return @"Déjà enregistrées";
}
/*
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	return @" ";
}*/


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return [newlyAddedList count];
	}
    return [selectionList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
	
	NSString *cellText;
	if (indexPath.section == 0) {
		cellText = [NSString stringWithFormat:@"%@ ", [[newlyAddedList objectAtIndex:indexPath.row] objectForKey:@"name"]]; 
		if (!isTypePerson) {
			cell.detailTextLabel.text = [format stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[[newlyAddedList objectAtIndex:indexPath.row] objectForKey:@"date"] longValue]]];
			//cellText = [cellText stringByAppendingString:[format stringFromDate:[NSDate dateWithTimeIntervalSince1970:	
			//														  [[[newlyAddedList objectAtIndex:indexPath.row] objectForKey:@"date"] longValue]]]];
		}

	} else {
		cellText = [NSString stringWithFormat:@"%@ ", [[selectionList objectAtIndex:indexPath.row] objectForKey:@"name"]]; 
		if (!isTypePerson) {
			cell.detailTextLabel.text = [format stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[[selectionList objectAtIndex:indexPath.row] objectForKey:@"date"] longValue]]];
			//cellText = [cellText stringByAppendingString:[format stringFromDate:[NSDate dateWithTimeIntervalSince1970:	
			//														  [[[selectionList objectAtIndex:indexPath.row] objectForKey:@"date"] longValue]]]];
		}
	}
	
	cell.textLabel.text = [cellText capitalizedString];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.section == 0) {
		[fatherController dimsissWithType:isTypePerson	Name:[[newlyAddedList objectAtIndex:indexPath.row] objectForKey:@"name"] 
														Id:[[[newlyAddedList objectAtIndex:indexPath.row] objectForKey:@"id"] intValue]];
	} else {
		[fatherController dimsissWithType:isTypePerson	Name:[[selectionList objectAtIndex:indexPath.row] objectForKey:@"name"] 
									   Id:[[[selectionList objectAtIndex:indexPath.row] objectForKey:@"id"] intValue]];
	}
		
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
    [super dealloc];
	[format release];
}


@end

