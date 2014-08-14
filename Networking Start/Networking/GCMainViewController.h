//
//  GCMainViewController.h
//  Networking
//
//  Created by Thomas Crawford on 11/9/13.
//  Copyright (c) 2013 Thomas Crawford. All rights reserved.
//

#import "GCFlipsideViewController.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <MessageUI/MessageUI.h>
#import <CoreData/CoreData.h>
#import <Social/Social.h>

@interface GCMainViewController : UIViewController <GCFlipsideViewControllerDelegate, UITextFieldDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
