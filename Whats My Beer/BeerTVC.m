//
//  BeerTVC.m
//  Whats My Beer
//
//  Created by Edgar Miranda on 7/22/13.
//  Copyright (c) 2013 Edgar Miranda. All rights reserved.
//

#import "BeerTVC.h"

@interface BeerTVC ()
@property (weak, nonatomic) IBOutlet UITableViewSection *beerNameSection;

@end

@implementation BeerTVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-tableview


@end
