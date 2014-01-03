//
//  EditFriendsViewController.h
//  QuickChat
//
//  Created by Taylor on 12/2/13.
//  Copyright (c) 2013 Taylor Beck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MSCellAccessory.h"

@interface EditFriendsViewController : UITableViewController

@property (nonatomic, strong) NSArray *allUsers;
@property (nonatomic, strong) PFUser *currentUser;
@property (nonatomic, strong) NSMutableArray *friends;

- (BOOL)isFriend:(PFUser *)user;

@end
