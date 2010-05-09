//
//  repayViewController.h
//  IHM
//
//  Created by Adrien on 29/03/10.
//  Copyright 2010 Ensimag. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SORT_AMOUNT 0
#define SORT_DATE 1
#define SORT_PERSON 2
#define SORT_EVENT 3

@interface repayViewController : UIViewController {

	IBOutlet UIButton *reinit;
	IBOutlet UIButton *validate;
	IBOutlet UILabel *value;
	IBOutlet UITableView *deptList;

	NSMutableArray *queryResults;
	
	NSDateFormatter *format;	
	
	int sort_type;

}

@property(nonatomic, retain) UIButton *reinit;
@property(nonatomic, retain) UIButton *validate;
@property(nonatomic, retain) UILabel *value;
@property(nonatomic, retain) UITableView *deptList;
@property(nonatomic, retain) NSMutableArray *queryResults;

- (IBAction) reset:(id)sender;
- (IBAction) validate:(id)sender; 
- (IBAction) sort:(id)sender;




@end
