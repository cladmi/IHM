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
	IBOutlet UITextField *value;
	IBOutlet UITableView *deptList;
	
}

@property(nonatomic, retain) UIButton *reinit;
@property(nonatomic, retain) UIButton *validate;
@property(nonatomic, retain) UITextField *value;
@property(nonatomic, retain) UITableView *deptList;


@end
