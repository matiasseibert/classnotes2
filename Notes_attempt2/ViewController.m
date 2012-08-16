//
//  ViewController.m
//  Notes_attempt2
//
//  Created by Thomas Wilson on 25/06/2012.
//  Copyright (c) 2012 aberystwyth university. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property BOOL _bold;

@end

@implementation ViewController
@synthesize textInputView = _textInputView;
@synthesize popoverViewController = _popoverViewController;
@synthesize currentDocument = _currentDocument;
@synthesize boldButton = _boldButton;
@synthesize _bold;
-(void)dealloc{
	[_textInputView release];
	self.textInputView = nil;
	[_boldButton release];
	[_currentDocument release];
	[super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	_bold = false;
	_currentDocument = [[Document alloc]init];
	self.textInputView.currentDocument = _currentDocument;
	self.textInputView.textView.images =_currentDocument.images;
}

- (void)viewDidUnload
{
	[self setBoldButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


-(void)viewDidAppear:(BOOL)animated{
	
}
- (IBAction)imagePicker:(id)sender {
	
	UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
	imagePickerController.delegate = self;
	if (!_popoverViewController) {
		NSLog(@"popover made");
		_popoverViewController = [[UIPopoverController alloc]initWithContentViewController:imagePickerController];
	}
	
		
	[self.popoverViewController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	
	
	
}

#pragma mark image picker controller delegate methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
	NSLog(@"image picked");
	UIImage *selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
	
	UIImageView *imageview= [[UIImageView alloc]initWithImage:selectedImage];
	UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(imageDragged:withEvent:)];
	
	[imageview setUserInteractionEnabled:YES];
	[imageview addGestureRecognizer:panGR];
	
	imageview.center = self.textInputView.center;
	[self.currentDocument.images addObject:imageview];
	NSLog(@"images count VC %d", [self.currentDocument.images count]);
	[self.textInputView insertSubview:imageview aboveSubview:self.textInputView.textView];
	
	[self.popoverViewController dismissPopoverAnimated:YES];
	[imageview release];
	[panGR release];
	NSLog(@"kjfdalsj");
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
	NSLog(@"picker removed");
	[self.popoverViewController dismissPopoverAnimated:YES];
}

#pragma mark drag and drop methods

-(void)imageDragged:(id)sender withEvent:(UIEvent *)event{
	
}
-(void)imageTapped:(id)sender withEvent:(UIEvent *)event{
	NSLog(@"dragging");
	UIImageView *selectedImage = (UIImageView *)sender;
	CGPoint point = [[[event allTouches] anyObject] locationInView:self.view];
	selectedImage.center = point;
}
@end
