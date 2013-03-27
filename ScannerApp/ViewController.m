//
//  ViewController.m
//  ScannerApp
//
//  Created by Seb on 20.03.13.
//  Copyright (c) 2013 Gobas GmbH. All rights reserved.
//

#import "ViewController.h"
#import "VCardImporter.h"
#import "CardScanViewController.h"

typedef enum {
   ScanModeQR,
    ScanModeVCard
} ScanMode;

@interface ViewController () {
    ScanMode _scanMode;
}

@property(nonatomic, strong) QRScanner *scanner;
@property(nonatomic, strong) VCardImporter *parser;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)openQRWidget {
    self.scanner = [[QRScanner alloc] init];
    _scanner.delegate = self;
    [_scanner presentScanWidgetOn:self];
}

-(IBAction)showQRWidget:(id)sender {
    _scanMode = ScanModeQR;
    
    [self openQRWidget];
}

-(IBAction)scanVCard:(id)sender {
    _scanMode = ScanModeVCard;
    
    [self openQRWidget];
}

-(IBAction)scanCard:(id)sender {
    CardScanViewController *controller = [[CardScanViewController alloc] initWithNibName:@"CardScanViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - QRScanner delegate

- (void)didScannedCode:(NSString*)result {
    
    if (_scanMode == ScanModeQR) {
        _textView.text = result;
    }
    else if (_scanMode == ScanModeVCard) {
        NSArray *substrings = [result componentsSeparatedByString:@"\n"];
        if (substrings.count > 0 && [substrings[0] isEqualToString:@"BEGIN:VCARD"]) {
            _parser = [[VCardImporter alloc]init];
            [_parser parse:result];
            
            ABRecordRef person = _parser.parsedPerson;
            
            ABUnknownPersonViewController *picker = [[ABUnknownPersonViewController alloc] init];
			picker.unknownPersonViewDelegate = self;
			picker.displayedPerson = person;
			picker.allowsAddingToAddressBook = YES;
		    picker.allowsActions = YES;
            
            [self.navigationController pushViewController:picker animated:YES];
        }
    }
}

- (void)didCancelScanning {
    NSLog(@"canceled scanning");
}


#pragma mark ABUnknownPersonViewControllerDelegate methods
// Dismisses the picker when users are done creating a contact or adding the displayed person properties to an existing contact.
- (void)unknownPersonViewController:(ABUnknownPersonViewController *)unknownPersonView didResolveToPerson:(ABRecordRef)person
{
	[self dismissViewControllerAnimated:YES completion:nil];
}


// Does not allow users to perform default actions such as emailing a contact, when they select a contact property.
- (BOOL)unknownPersonViewController:(ABUnknownPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person
						   property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
	return NO;
}


@end
