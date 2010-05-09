//
//  addViewController.h
//  IHM
//
//  Created by Adrien on 29/03/10.
//  Copyright 2010 Ensimag. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface addViewController : UIViewController {
	IBOutlet UITextField *montant;
	IBOutlet UITextField *personnes;
	IBOutlet UITextField *cause;
	IBOutlet UIButton *valider;
	bool causeEditActive;
	NSMutableArray *personsArray;
	
	int personID;
	int eventID;
}

@property(nonatomic, retain) UITextField *montant;
@property(nonatomic, retain) UITextField *personnes;
@property(nonatomic, retain) UITextField *cause;
@property(nonatomic, retain) UIButton *valider;

@property(nonatomic) int personID;
@property(nonatomic) int eventID;

- (IBAction) TextFieldDownEditing:(id)sender;
- (IBAction) ValidateDept:(id)sender;
- (IBAction) UpView:(id)sender;

- (IBAction) openList:(id)sender;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void) addDebt;

@end
