ScannerApp
==========

Barcode and QR Code Scanner Demo App


# Dependencies

## zxing

Reading QR Codes

* URL: http://code.google.com/p/zxing
* License: Apache License 2.0 (https://code.google.com/p/zxing/wiki/LicenseQuestions)
* Included as a submodule

## Tesseract

OCR library for scanning business cards

* URL: https://github.com/ldiqual/tesseract-ios
* License: See license file (library is free to use)

## Tesserat iOS Wrapper

Objective-C wrapper for Tesseract OCR.

* URL: https://github.com/ldiqual/tesseract-ios
* License: MIT


# zxing landscape

For supporting landscape orientation I add 'didRotateFromInterfaceOrientation' in the ZXingWidgetController.m file. Here the 'self.prevLayer' will be rotated.

The method:

    //see http://stackoverflow.com/a/9689874/470964
    -(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
        float angle;
        switch ([UIApplication sharedApplication].statusBarOrientation) {
            case UIInterfaceOrientationPortrait:
                angle = 0;
                break;
            
            case UIInterfaceOrientationPortraitUpsideDown:
                angle = M_PI;
                break;
            
            case UIInterfaceOrientationLandscapeRight:
                angle = -M_PI/2;
                break;
            
            case UIInterfaceOrientationLandscapeLeft:
                angle = M_PI/2;
                break;
            
            default:
                angle = 0;
                break;
        }
    
        CATransform3D transform =  CATransform3DMakeRotation(angle, 0, 0, 1.0);
        self.prevLayer.transform = transform;
        self.prevLayer.frame = self.view.bounds;
    }
