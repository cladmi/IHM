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
	
	
	
}

@property(nonatomic, retain) addViewController *fatherController;


- (IBAction) addPerson:(id)sender;
- (IBAction) dismiss:(id)sender;
@end
