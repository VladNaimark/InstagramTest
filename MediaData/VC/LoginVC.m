//
//  ViewController.m
//  MediaData
//
//  Created by Vlad Naimark on 9/1/17.
//  Copyright © 2017 Vlad Naimark. All rights reserved.
//

#import "LoginVC.h"
#import "InstaAPI.h"

@interface LoginVC () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[InstaAPI sharedInstance].loginURL]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue
{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[InstaAPI sharedInstance].loginURL]];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([[InstaAPI sharedInstance] checkAndUpdateToken:request.URL])
    {
        [self performSegueWithIdentifier:@"toGridSegue" sender:self];
        return NO;
    }
    return YES;
}

@end
