//
//  homeViewController.h
//  IHM
//
//  Created by Adrien on 29/03/10.
//  Copyright 2010 Ensimag. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface homeViewController : UIViewController {
	IBOutlet UIButton *ajouterDette;
	IBOutlet UIButton *rembourserDette;

}

@property(nonatomic, retain) UIButton *ajouterDette;
@property(nonatomic, retain) UIButton *rembourserDette;



- (IBAction) ajouter:(id)sender;
- (IBAction) rembourser:(id)sender;

@end