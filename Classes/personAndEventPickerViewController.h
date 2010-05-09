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
	IBOutlet UITextField *addText;
	IBOutlet UIButton *addButton;
	IBOutlet UIView *addView;
	IBOutlet UITableView *tab;
	bool isTypePerson; // false => isTypeEvent
	NSMutableArray *selectionList;
	NSMutableArray *newlyAddedList;
	NSDateFormatter *format;
	
}

@property(nonatomic, retain) addViewController *fatherController;
@property(nonatomic, retain) NSMutableArray *selectionList;
@property(nonatomic, retain) NSMutableArray *newlyAddedList;
@property(nonatomic) bool isTypePerson;


- (IBAction) addPerson:(id)sender;
- (IBAction) dismiss:(id)sender;
- (IBAction) TextFieldDownEditing:(id)sender;
@end
