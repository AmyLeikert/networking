//
//  GCFlipsideViewController.h
//  Networking
//
//  Created by Thomas Crawford on 11/9/13.
//  Copyright (c) 2013 Thomas Crawford. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GCFlipsideViewController;


@protocol GCFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(GCFlipsideViewController *)controller;
@end

@interface GCFlipsideViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) NSString *sendingSegue;
@property (nonatomic, strong) NSString *webViewString;

@property (weak, nonatomic) id <GCFlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
