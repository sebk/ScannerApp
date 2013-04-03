//
//  CustomOverlayView.m
//  ScannerApp
//
//  Created by Seb on 03.04.13.
//  Copyright (c) 2013 Gobas GmbH. All rights reserved.
//

#import "CustomOverlayView.h"

@implementation CustomOverlayView

static const CGFloat kPadding = 10;
#define kTextMargin 10

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)drawCrossInContext:(CGContextRef)context inRect:(CGRect)rect {    
    CGContextBeginPath(context);
    [[UIColor lightGrayColor] setStroke];
    CGContextSetLineWidth(context, 4);
    CGContextMoveToPoint(context, rect.size.width/2 - 15, rect.size.height/2);
	CGContextAddLineToPoint(context, rect.size.width/2 + 15, rect.size.height/2);
    CGContextMoveToPoint(context, rect.size.width/2, rect.size.height/2 - 15);
	CGContextAddLineToPoint(context, rect.size.width/2, rect.size.height/2 + 15);
	CGContextStrokePath(context);
}

-(void)drawEdgeInContext:(CGContextRef)context forSide:(int)side {
    
    CGPoint startPoint;
    CGPoint endPoint1;
    CGPoint endPoint2;
    float length = 45;
    
    switch (side) {
        case 0: //links oben
            startPoint = CGPointMake(cropRect.origin.x, cropRect.origin.y);
            endPoint1 = CGPointMake(cropRect.origin.x, cropRect.origin.y + length);
            endPoint2 = CGPointMake(cropRect.origin.x + length, cropRect.origin.y);
            break;
            
        case 1: //rechts oben
            startPoint = CGPointMake(cropRect.origin.x +  cropRect.size.width, cropRect.origin.y);
            endPoint1 = CGPointMake(cropRect.origin.x + cropRect.size.width, cropRect.origin.y + length); //down
            endPoint2 = CGPointMake(cropRect.origin.x + cropRect.size.width - length, cropRect.origin.y); //left
            break;
            
        case 2: //links unten
            startPoint = CGPointMake(cropRect.origin.x, cropRect.origin.y + cropRect.size.height);
            endPoint1 = CGPointMake(cropRect.origin.x, cropRect.origin.y + cropRect.size.height - length); //up
            endPoint2 = CGPointMake(cropRect.origin.x + length, cropRect.origin.y + cropRect.size.height); //right
            break;
            
        case 3: //rechts unten
            startPoint = CGPointMake(cropRect.origin.x + cropRect.size.width, cropRect.origin.y + cropRect.size.height);
            endPoint1 = CGPointMake(cropRect.origin.x + cropRect.size.width, cropRect.origin.y + cropRect.size.height - length); //up
            endPoint2 = CGPointMake(cropRect.origin.x + cropRect.size.width - length, cropRect.origin.y + cropRect.size.height); //left
            break;
    }
    
    CGContextBeginPath(context);
    [[UIColor lightGrayColor] setStroke];
    CGContextSetLineWidth(context, 6);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint1.x, endPoint1.y);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint2.x, endPoint2.y);
	CGContextStrokePath(context);
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        //NSLog(@"landscape");

        cropRect = CGRectMake(kPadding*2+10, kPadding*3, 960, 600);
    }
    else {
        //NSLog(@"portraitr");
        
        CGFloat rectSize = self.frame.size.width - kPadding * 2;
        cropRect = CGRectMake(kPadding, (self.frame.size.height - rectSize) / 2, rectSize, rectSize);

    }
    
 
	CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIColor grayColor] setStroke];

    [self drawRect:cropRect inContext:context];

    //draw cross
    //[self drawCrossInContext:context inRect:rect];
    
    [self drawEdgeInContext:context forSide:0];
    [self drawEdgeInContext:context forSide:1];
    [self drawEdgeInContext:context forSide:2];
    [self drawEdgeInContext:context forSide:3];

    
	CGContextSaveGState(context);
	if (oneDMode) {
        NSString *text = NSLocalizedStringWithDefaultValue(@"OverlayView 1d instructions", nil, [NSBundle mainBundle], @"Place a red line over the bar code to be scanned.", @"Place a red line over the bar code to be scanned.");
        UIFont *helvetica15 = [UIFont fontWithName:@"Helvetica" size:15];
        CGSize textSize = [text sizeWithFont:helvetica15];
        
		CGContextRotateCTM(context, M_PI/2);
        // Invert height and width, because we are rotated.
        CGPoint textPoint = CGPointMake(self.bounds.size.height / 2 - textSize.width / 2, self.bounds.size.width * -1.0f + 20.0f);
        [text drawAtPoint:textPoint withFont:helvetica15];
	}

	CGContextRestoreGState(context);
	int offset = rect.size.width / 2;
	if (oneDMode) {
		CGFloat red[4] = {1.0f, 0.0f, 0.0f, 1.0f};
		CGContextSetStrokeColor(context, red);
		CGContextSetFillColor(context, red);
		CGContextBeginPath(context);
		//		CGContextMoveToPoint(c, rect.origin.x + kPadding, rect.origin.y + offset);
		//		CGContextAddLineToPoint(c, rect.origin.x + rect.size.width - kPadding, rect.origin.y + offset);
		CGContextMoveToPoint(context, rect.origin.x + offset, rect.origin.y + kPadding);
		CGContextAddLineToPoint(context, rect.origin.x + offset, rect.origin.y + rect.size.height - kPadding);
		CGContextStrokePath(context);
	}
	if( nil != _points ) {
		CGFloat blue[4] = {0.0f, 1.0f, 0.0f, 1.0f};
		CGContextSetStrokeColor(context, blue);
		CGContextSetFillColor(context, blue);
		if (oneDMode) {
			CGPoint val1 = [self map:[[_points objectAtIndex:0] CGPointValue]];
			CGPoint val2 = [self map:[[_points objectAtIndex:1] CGPointValue]];
			CGContextMoveToPoint(context, offset, val1.x);
			CGContextAddLineToPoint(context, offset, val2.x);
			CGContextStrokePath(context);
		}
		else {
			CGRect smallSquare = CGRectMake(0, 0, 10, 10);
			for( NSValue* value in _points ) {
				CGPoint point = [self map:[value CGPointValue]];
				smallSquare.origin = CGPointMake(
                                                 cropRect.origin.x + point.x - smallSquare.size.width / 2,
                                                 cropRect.origin.y + point.y - smallSquare.size.height / 2);
				[self drawRect:smallSquare inContext:context];
			}
		}
	}
    
    [self setNeedsLayout];


}



@end
