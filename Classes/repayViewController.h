//
//  repayViewController.h
//  IHM
//
//  Created by Adrien on 29/03/10.
//  Copyright 2010 Ensimag. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface repayViewController : UIViewController {

	IBOutlet UIButton *reinit;
	IBOutlet UIButton *validate;
	IBOutlet UILabel *value;
	IBOutlet UITableView *deptList;
	IBOutlet UIToolbar *tool;
	IBOutlet UISegmentedControl *segm;
	NSInteger sort;
	NSMutableArray *nameArray;
	NSMutableArray *eventArray;
	NSMutableArray *dateArray;
	NSMutableArray *amountArray;
	NSMutableArray *selectArray;
	
	NSMutableArray *queryResults;
	

	
}

@property(nonatomic, retain) UIButton *reinit;
@property(nonatomic, retain) UIButton *validate;
@property(nonatomic, retain) UILabel *value;
@property(nonatomic, retain) UITableView *deptList;
@property(nonatomic, retain) NSMutableArray *queryResults;

- (IBAction) reset:(id)sender;
- (IBAction) validate:(id)sender; 
- (IBAction) segmentSelected:(id)sender;


@end
