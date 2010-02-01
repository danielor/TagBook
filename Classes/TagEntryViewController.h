//
//  TagEntryViewController.h
//  TagBook
//
//  Created by Daniel  Ortiz on 12/13/09.
//  Copyright 2009 University Michigan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface TagEntryViewController : UIViewController {
	// Create the tag
	IBOutlet UITextField * commentOfTag;
	IBOutlet UITextField * nameOfTag;
	IBOutlet UISlider * ratingSliderOfTag;
	IBOutlet UISwitch * isTagPublic;
	
	// Control the tag
	IBOutlet UIButton * sendButton;
	IBOutlet UIButton * cancelButton;
	
	// The delegate controller
	id flipDelegate;
	BOOL isPublic;
}

@property (nonatomic, assign) id<MyFlipControllerDelegate> flipDelegate;
@property (nonatomic, retain) UITextField * commentOfTag;
@property (nonatomic, retain) UITextField * nameOfTag;
@property (nonatomic, retain) UISlider * ratingSliderOfTag;
@property (nonatomic, retain) UISwitch * isTagPublic;
@property (nonatomic, retain) UIButton * sendButton;
@property (nonatomic, retain) UIButton * cancelButton;
@property (nonatomic) BOOL isPublic;


// The action files
-(IBAction) touchSendButton:(id)sender;
-(IBAction) touchCancelButton:(id)sender;
-(IBAction) dismissKeyboard:(id)sender;

@end
