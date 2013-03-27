//
//  ViewController.m
//  ScannerApp
//
//  Created by Seb on 20.03.13.
//  Copyright (c) 2013 Gobas GmbH. All rights reserved.
//

#import "ViewController.h"
#import "VCardImporter.h"

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


#pragma mark - QRScanner delegate

- (void)didScannedCode:(NSString*)result {
    NSLog(@"Result: %@", result);
    
    if (_scanMode == ScanModeQR) {
        _textView.text = result;
    }
    else if (_scanMode == ScanModeVCard) {
        NSArray *substrings = [result componentsSeparatedByString:@"\n"];
        if (substrings.count > 0 && [substrings[0] isEqualToString:@"BEGIN:VCARD"]) {
            _parser = [[VCardImporter alloc]init];
            [_parser parse:result];
            
            ABRecordRef person = _parser.parsedPerson;
            
            ABPersonViewController *personController = [[ABPersonViewController alloc] init];
            [personController setDisplayedPerson:person];
            [personController setPersonViewDelegate:self];
            [personController setAllowsEditing:YES];
            [personController setAllowsActions:YES];
            
            [self.navigationController pushViewController:personController animated:YES];
        }
    }
}

- (void)didCancelScanning {
    NSLog(@"canceled scanning");
}


#pragma mark - ABPersonViewControllerDelegate

- (BOOL) personViewController:(ABPersonViewController*)personView shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifierForValue
{
    // This is where you pass the selected contact property elsewhere in your program
    [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
    return NO;
}

@end
