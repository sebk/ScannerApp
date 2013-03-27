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
        [self presentViewController:_ipc animated:YES completion:nil];
    }
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
