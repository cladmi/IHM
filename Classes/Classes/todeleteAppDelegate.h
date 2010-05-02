//
//  todeleteAppDelegate.h
//  todelete
//
//  Created by Adrien on 01/05/10.
//  Copyright Ensimag 2010. All rights reserved.
//

@interface todeleteAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

