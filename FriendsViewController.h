//
//  FriendsViewController.h
//  QuickChat
//
//  Created by Taylor on 12/2/13.
//  Copyright (c) 2013 Taylor Beck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "EditFriendsViewController.h"
#import "GravatarUrlBuilder.h"
#import <QuartzCore/CALayer.h>

@interface FriendsViewController : UITableViewController

@property (nonatomic, strong) PFRelation *friendsRelation;
@property (nonatomic, strong) NSArray *friends;

@end
