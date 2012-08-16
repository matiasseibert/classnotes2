//
//  ViewController.h
//  Notes_attempt2
//
//  Created by Thomas Wilson on 25/06/2012.
//  Copyright (c) 2012 aberystwyth university. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWInputView.h"
#import "Document.h"

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UIPopoverControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong)IBOutlet TWInputView *textInputView;
@property (nonatomic, strong)Document *currentDocument;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *boldButton;
@property (strong, nonatomic)UIPopoverController *popoverViewController;

- (IBAction)imagePicker:(id)sender;
- (void)imageTapped:(id)sender withEvent:(UIEvent *)event;
- (void)imageDragged:(id)sender withEvent:(UIEvent *)event;
@end
