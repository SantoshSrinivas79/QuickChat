//
//  FriendsViewController.m
//  QuickChat
//
//  Created by Taylor on 12/2/13.
//  Copyright (c) 2013 Taylor Beck. All rights reserved.
//

#import "FriendsViewController.h"
#import "EditFriendsViewController.h"

@interface FriendsViewController ()

@end

@implementation FriendsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
}

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
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showEditFriends"])
    {
        EditFriendsViewController *viewController = (EditFriendsViewController *)segue.destinationViewController;
        viewController.friends = [NSMutableArray arrayWithArray:self.friends];
    }
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
    
// For Gravatars
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
    
        // Getting Email Address
        NSString *email = [user objectForKey:@"email"];
        
        // Create MD5 Hash
        NSURL *gravatarUrl = [GravatarUrlBuilder getGravatarUrl:email];
        
        // Request Image From Gravatar
        NSData *imageData = [NSData dataWithContentsOfURL:gravatarUrl];
        
        if (imageData != nil) {
            
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Set Image in cell
            cell.imageView.image = [UIImage imageWithData:imageData];
            [cell setNeedsLayout];
        });
        }
        
    });
    
    cell.imageView.image = [UIImage imageNamed:@"icon_personOrange"];
    [cell.imageView.layer setCornerRadius:16.0];
    [cell.imageView.layer setMasksToBounds:YES];
    
    return cell;
}


- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end