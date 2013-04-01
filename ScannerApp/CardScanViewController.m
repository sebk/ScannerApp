//
//  CardScanViewController.m
//  ScannerApp
//
//  Created by Seb on 27.03.13.
//  Copyright (c) 2013 Gobas GmbH. All rights reserved.
//

#import "CardScanViewController.h"
#import "CardReader.h"

@interface CardScanViewController () {
    UIImagePickerController *_ipc;
}

@property(nonatomic, strong) UIPopoverController *popover;

@end

@implementation CardScanViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Scan business card";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)chooseFromCamera:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        _ipc = [[UIImagePickerController alloc] init];
        _ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
        _ipc.delegate = self;
        [self presentViewController:_ipc animated:YES completion:nil];
    }
}

-(IBAction)chooseFromLibrary:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        _ipc = [[UIImagePickerController alloc] init];
        _ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _ipc.delegate = self;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:_ipc];
            [popover presentPopoverFromRect:((UIButton*)sender).bounds inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            self.popover = popover;
        } else {
            [self presentViewController:_ipc animated:YES completion:nil];
        }
    }
}

-(IBAction)scanImage:(id)sender {
    CardReader *reader = [[CardReader alloc] init];
    
    dispatch_as
    
    NSString *result = [reader scanCard:_imageView.image];
    _textView.text = result;
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editInfo {
    
    [[picker parentViewController] dismissModalViewControllerAnimated:YES];
    [_ipc dismissModalViewControllerAnimated:TRUE];
        
    _imageView.image = image;
    
    CardReader *reader = [[CardReader alloc] init];
    NSString *result = [reader scanCard:image];
    _textView.text = result;
}


@end
