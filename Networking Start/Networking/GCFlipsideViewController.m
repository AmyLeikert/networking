//
//  GCFlipsideViewController.m
//  Networking
//
//  Created by Thomas Crawford on 11/9/13.
//  Copyright (c) 2013 Thomas Crawford. All rights reserved.
//

#import "GCFlipsideViewController.h"

@interface GCFlipsideViewController ()
@property (nonatomic, strong) IBOutlet UIWebView *myWebView;

@end

@implementation GCFlipsideViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"Got %@ for %@", self.webViewString, self.sendingSegue);
    if ([self.sendingSegue isEqualToString:@"showWebsite"]) {
    NSURL *webURL = [[NSURL alloc]  initWithString:self.webViewString];
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:webURL]];
    } else if ([self.sendingSegue isEqualToString:@"showHTML"]) {
        [self.myWebView loadHTMLString:self.webViewString baseURL:nil];
    } else if ([self.sendingSegue isEqualToString:@"showImage"]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:self.webViewString ofType:@"png"];
        NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL fileURLWithPath:path]];
        [self.myWebView loadRequest:request];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

@end
