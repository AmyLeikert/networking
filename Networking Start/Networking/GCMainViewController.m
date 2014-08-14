//
//  GCMainViewController.m
//  Networking
//
//  Created by Thomas Crawford on 11/9/13.
//  Copyright (c) 2013 Thomas Crawford. All rights reserved.
//

#import "GCMainViewController.h"
#import "Reachability.h"

@interface GCMainViewController ()

@property (strong, nonatomic) IBOutlet UITextField   *inputTextField;
@property (strong, nonatomic) IBOutlet UIButton      *emailButton;
@property (strong, nonatomic) IBOutlet UIButton      *textButton;
@property (strong, nonatomic) IBOutlet UIButton      *facebookButton;
@property (strong, nonatomic) IBOutlet UIButton      *twitterButton;
@property (strong, nonatomic) IBOutlet UIButton      *websiteButton;
@property (strong, nonatomic) IBOutlet UIButton      *getFileButton;

@end

@implementation GCMainViewController
{
    Reachability *hostReach;
    Reachability *internetReach;
    Reachability *wifiReach;
    BOOL internetAvailable;
    BOOL serverAvailable;
}
NSString *hostName = @"www.moveablebytes.com";

#pragma mark - Core Methods

- (void)updateReachabilityStatus:(Reachability *)curReach {
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if(curReach == hostReach) {
        switch (netStatus)
        {
            case NotReachable:
            {
                NSLog(@"Server Not Available");
                serverAvailable = NO;
                break;
            }
                
            case ReachableViaWWAN:
            {
                NSLog(@"Server Reachable via WWAN");
                serverAvailable = YES;
                break;
            }
            case ReachableViaWiFi:
            {
                NSLog(@"Server Reachable via WiFi");
                serverAvailable = YES;
                break;
            }
        }
    }
    if(curReach == internetReach || curReach == wifiReach) {
        switch (netStatus)
        {
            case NotReachable:
            {
                NSLog(@"Internet Not Available");
                internetAvailable = NO;
                break;
            }
                
            case ReachableViaWWAN:
            {
                NSLog(@"Internet Reachable via WWAN");
                internetAvailable = YES;
                break;
            }
            case ReachableViaWiFi:
            {
                NSLog(@"Internet Reachable via WiFi");
                internetAvailable = YES;
                break;
            }
        }
    }
}

- (void)reachabilityChanged:(NSNotification*)note
{
    Reachability* curReach = [note object];
    [self updateReachabilityStatus:curReach];
}


#pragma mark - System Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    hostReach = [Reachability reachabilityWithHostName:hostName];
    [hostReach startNotifier];
    [self updateReachabilityStatus:hostReach];
    
    internetReach = [Reachability reachabilityForInternetConnection];
    [internetReach startNotifier];
    [self updateReachabilityStatus:internetReach];
    
    wifiReach = [Reachability reachabilityForLocalWiFi];
    [wifiReach startNotifier];
    [self updateReachabilityStatus:wifiReach];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Interactivity Methods

- (IBAction)emailButtonPressed:(id)sender {
    NSLog(@"eMail Pressed with: %@", _inputTextField.text);
    [_inputTextField resignFirstResponder];
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        mailController.mailComposeDelegate = self;
        [mailController setSubject:@"Subject Goes Here"];
        [mailController setMessageBody:_inputTextField.text isHTML:NO];
        [mailController setToRecipients:[NSArray arrayWithObject:@"derek@grandcircus.co"]];
        if (mailController != nil) {
            [self presentViewController:mailController animated:YES completion:nil];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email not available" message:@"Email is not configured on this device" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:nil];
        [alert show];
    }
}

-(void) messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [self dismissMessageControllers];
}

-(void)dismissMessageControllers {
    [self becomeFirstResponder];
    [self dismissViewControllerAnimated:YES completion:NO];
    
}

-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Cancelled");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Failed");
        case MFMailComposeResultSaved:
            NSLog(@"Saved");
        case MFMailComposeResultSent:
            NSLog(@"Sent");
            break;
            default:
            break;
    }
    [self dismissMessageControllers];
    
}

- (IBAction)textButtonPressed:(id)sender {
    NSLog(@"Text/SMS Pressed with: %@", _inputTextField.text);
    [_inputTextField resignFirstResponder];
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *controller = ([[MFMessageComposeViewController alloc] init]);
        controller.body = self.inputTextField.text;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Text/SMS not available" message:@"Either Text/SMS is not configured on this device or this device cannot sent text/SMS" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
    
    }
}

- (IBAction)facebookButtonPressed:(id)sender {
    NSLog(@"Facebook Pressed with: %@", _inputTextField.text);
    [_inputTextField resignFirstResponder];
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *fbSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [fbSheet setInitialText:_inputTextField.text];
        [self presentViewController:fbSheet animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook not available" message:@"Either facebook is not configured on this device or the internet is not currently available" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)twitterButtonPressed:(id)sender {
    NSLog(@"Twitter Pressed with: %@", _inputTextField.text);
    [_inputTextField resignFirstResponder];
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:self.inputTextField.text];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter Not available" message:@"Either Twitter is not configured on this device or the internet is not currently available" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
        [alert show];
    }
}

- (IBAction)getFileButtonPressed:(id)sender {
    NSLog(@"Get File Pressed with: %@", _inputTextField.text);
    [_inputTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"Tapped");
    [_inputTextField resignFirstResponder];
    return YES;
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(GCFlipsideViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [[segue destinationViewController] setSendingSegue:[segue identifier]];
    [[segue destinationViewController] setDelegate:self];
    [self.inputTextField resignFirstResponder];
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
    } else if ([[segue identifier] isEqualToString:@"showWebsite"]) {
        [[segue destinationViewController] setWebViewString:self.inputTextField.text];
    } else if ([[segue identifier] isEqualToString:@"showHTML"]) {
        [[segue destinationViewController] setWebViewString:@"<HTML><BODY><P>My HTML goes here. Add whatever.</P></BODY></HTML>"];
    } else if ([[segue identifier] isEqualToString:@"showImage"]) {
        [[segue destinationViewController] setWebViewString:@"HappyHourIcon300"];
        
    }
}

@end
