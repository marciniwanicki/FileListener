/* Copyright (c) 2012 Marcin Iwanicki.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "SetupViewController.h"

@interface SetupViewController ()


@end

@implementation SetupViewController

@synthesize statusTextView, fileAddressTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    FileChecker *fileChecker = [[FileChecker alloc] init];
    NSString *remoteFileUrl = [[fileChecker loadUrlFromFile: nil] absoluteString];
    if ([[fileAddressTextField text] length] == 0 && remoteFileUrl != nil) {
        [fileAddressTextField setText: remoteFileUrl];
    }
}

- (IBAction)textFieldFinished:(id)sender {
    [sender resignFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Custom actions
- (IBAction) listen: (id)sender {
    FileChecker *fileChecker = [[FileChecker alloc] init];
    [fileChecker setRemoteFileUrl: [NSURL URLWithString: [fileAddressTextField text]]];
    NSError *error;
    BOOL result = [fileChecker isFileChanged: &error];
    if (!result && error) {
        [statusTextView setText: [NSString stringWithFormat: @"Error: %@", [error localizedFailureReason]]];
    } else {
        NSString *remoteFileUrl = [[fileChecker loadUrlFromFile: nil] absoluteString];
        [statusTextView setText: [NSString stringWithFormat: @"Ok, the application is listening changes of \"%@\" file. You can go out.", remoteFileUrl]];
    }
}


@end
