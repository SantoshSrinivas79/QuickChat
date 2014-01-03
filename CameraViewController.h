//
//  CameraViewController.h
//  QuickChat
//
//  Created by Taylor on 12/2/13.
//  Copyright (c) 2013 Taylor Beck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MSCellAccessory.h"



@interface CameraViewController : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) UIImage                 *image;
@property (nonatomic, strong) NSString                *videoFilePath;
@property (nonatomic, strong) NSArray                 *friends;
@property (nonatomic, strong) PFRelation              *friendsRelation;
@property (nonatomic, strong) NSMutableArray          *recipients;

- (IBAction)cancel:(id)sender;
- (IBAction)send:(id)sender;

- (void)uploadMessage;

- (UIImage *)resizeImage:(UIImage *)image toWidth:(float)width andHeight:(float)height;

@end
