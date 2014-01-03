//
//  CameraViewController.m
//  QuickChat
//
//  Created by Taylor on 12/2/13.
//  Copyright (c) 2013 Taylor Beck. All rights reserved.
//

#import "CameraViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface CameraViewController ()

@end

@implementation CameraViewController

UIColor *disclosureColor;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    
    self.friendsRelation = [[PFUser currentUser] objectForKey:@"friendsRelation"];
    
    PFQuery *query = [self.friendsRelation query];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error %@ %@", error, [error userInfo]);
        }
        else {
            self.friends = objects;
            [self.tableView reloadData];
        }
    }];
    
    if (self.image == nil && self.videoFilePath.length == 0)
    {
        
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        self.imagePicker.allowsEditing = NO;
        self.imagePicker.videoMaximumDuration = 10;
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        } else {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        
        self.imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.imagePicker.sourceType];
        
        [self presentViewController:self.imagePicker animated:NO completion:nil];
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.recipients = [[NSMutableArray alloc] init];
    
    disclosureColor = [UIColor colorWithRed:1 green:0.584 blue:0 alpha:1.0];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    
    if ([self.recipients containsObject:user.objectId])
    {
        cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_CHECKMARK color:disclosureColor];
    } else {
        cell.accessoryView = nil;
    }
    
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    
    if (cell.accessoryView == nil) {
        cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_CHECKMARK color:disclosureColor];
        
        [self.recipients addObject:user.objectId];
    } else {
        cell.accessoryView = nil;
        [self.recipients removeObject:user.objectId];
    }
}

#pragma mark - imagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        // A photo was taken or selected
        self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera )
        {
            // Save the image
            UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil);
        }
    }
    else {
        // Video was taken or selected
        self.videoFilePath = (__bridge NSString *)([[info objectForKey:UIImagePickerControllerMediaURL] path]);
        
        if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera )
        {
            // Save the video
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(self.videoFilePath))
            {
                UISaveVideoAtPathToSavedPhotosAlbum(self.videoFilePath, nil, nil, nil);
            }
            
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.tabBarController setSelectedIndex:0];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - IBActions


- (IBAction)cancel:(id)sender
{
    [self reset];
    
    [self.tabBarController setSelectedIndex:0];
}

- (IBAction)send:(id)sender
{
    if (self.image == nil && self.videoFilePath.length == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Try Again" message:@"Please capture a photo or video to share!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
        [self presentViewController:self.imagePicker animated:NO completion:nil];
    } else {
        [self uploadMessage];
        [self.tabBarController setSelectedIndex:0];
    }
}

#pragma mark - Helper Methods

- (void)uploadMessage
{
    NSData *fileData;
    NSString *fileName;
    NSString *fileType;
    
    //check if it's an image or video
    
    if (self.image != nil)
    {
        NSLog(@"It's an image");
        UIImage *newImage = [self resizeImage:self.image toWidth:320.0f andHeight:480.0f];
        fileData = UIImagePNGRepresentation(newImage);
        fileName = @"image.png";
        fileType = @"image";
    } else {
        NSLog(@"It's a video");
        fileData = [NSData dataWithContentsOfFile:self.videoFilePath];
        fileName = @"video.mov";
        fileType = @"video";
    }
    
    PFFile *file = [PFFile fileWithName:fileName data:fileData];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"An error occurred!" message:@"Please try sending your message again!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        } else {
            PFObject *message = [PFObject objectWithClassName:@"Messages"];
            [message setObject:file forKey:@"file"];
            [message setObject:fileType forKey:@"fileType"];
            [message setObject:self.recipients forKey:@"recipientIds"];
            [message setObject:[[PFUser currentUser] objectId] forKey:@"senderId"];
            [message setObject:[[PFUser currentUser] username] forKey:@"senderName"];
            [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"An error occurred!" message:@"Please try sending your message again!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertView show];
                } else {
                    //Everything was successful!

                    
                    // handle recipient push after sending message
                    
                   //NSArray *megRecipients = [message objectForKey:@"recipientIds"];
                    
                   // NSLog(@"%@", megRecipients);
                    
                    //PFQuery *pushQuery = [PFInstallation query];
                    //[pushQuery whereKey:@"owner" containedIn:megRecipients];
                    
                    //PFPush *push = [[PFPush alloc] init];
                    //[push setQuery:pushQuery];
                    //[push setMessage:[NSString stringWithFormat: @"%@ send you a new message",  [PFUser currentUser].username ]];
                    //[push sendPushInBackground];
   
                    
            
                    
                    
 /*                   // Send Push Notification to recipients
                    
                    NSArray *messageRecipients = [message objectForKey:@"recipientIds"];
                    
                    PFQuery *pushQuery = [PFInstallation query];
                    [pushQuery whereKey:@"owner" containedIn:messageRecipients];
                    
                    PFPush *push = [[PFPush alloc] init];
                    [push setQuery:pushQuery];
                    [push setMessage:[NSString stringWithFormat: @"New Message from %@!",  [PFUser currentUser].username]];
                    [push sendPushInBackground];
*/
                    [self reset];
                }
            }];
        }
    }];
}

- (void)reset
{
    self.image = nil;
    self.videoFilePath = nil;
    [self.recipients removeAllObjects];
}


- (UIImage *)resizeImage:(UIImage *)image toWidth:(float)width andHeight:(float)height
{
    CGSize newSize = CGSizeMake(width, height);
    CGRect newRectangle = CGRectMake(0, 0, width, height);
    UIGraphicsBeginImageContext(newSize);
    [self.image drawInRect:newRectangle];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
    
    
    
}


@end