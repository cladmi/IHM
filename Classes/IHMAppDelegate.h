//
//  IHMAppDelegate.h
//  IHM
//
//  Created by Adrien on 29/03/10.
//  Copyright Ensimag 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IHMAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	
	UINavigationController *navController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

