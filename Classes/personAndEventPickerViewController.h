//
//  personAndEventPickerViewController.h
//  IHM
//
//  Created by Ta Soeur on 5/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "addViewController.h"


@interface personAndEventPickerViewController : UITableViewController {

	addViewController *fatherController;
	
	bool isTypePerson; // false => isTypeEvent
	NSMutableArray *selectionList;
	NSMutableArray *newlyAddedList;
	
	
	
}

@property(nonatomic, retain) addViewController *fatherController;
@property(nonatomic, retain) NSMutableArray *selectionList;
@property(nonatomic, retain) NSMutableArray *newlyAddedList;


- (IBAction) addPerson:(id)sender;
- (IBAction) dismiss:(id)sender;
@end
