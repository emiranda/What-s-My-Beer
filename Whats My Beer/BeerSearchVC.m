//
//  BeerSearchTVC.m
//  Whats My Beer
//
//  Created by Edgar Miranda on 7/5/13.
//  Copyright (c) 2013 Edgar Miranda. All rights reserved.
//

#import "BeerSearchVC.h"
#import "BeerFectcher.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface BeerSearchVC ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *beerTableView;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;
@property (strong, nonatomic) NSArray *beers;
@end

@implementation BeerSearchVC

- (IBAction)onViewTap:(UITapGestureRecognizer *)sender {
    
//    [self.searchBar endEditing:TRUE];
    [self.searchBar resignFirstResponder];
    NSLog(@"this was tapped");
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchBar.delegate = self;
    self.beerTableView.dataSource = self;
    self.beerTableView.delegate = self;
    self.tapGesture.cancelsTouchesInView = NO;
    
    
//    [self.view addGestureRecognizer:tap];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

-(void)dismissKeyboard {
//    [self.searchBar resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    printf("this is a test");
        
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // Run this in another thread
    
    self.beers = [BeerFectcher searchForBeersWithString:searchBar.text];
    
    [self.view endEditing:YES];
    
    [self.beerTableView reloadData];
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
    return [self.beers count];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]])
    {
        NSIndexPath *indexPath = [self.beerTableView indexPathForCell:sender];
        
        if (indexPath)
        {
            if ([segue.identifier isEqualToString:@"Show Beer"])
            {
                if ([segue.destinationViewController respondsToSelector:@selector(setBeer:)])
                {
                    NSDictionary *beer = [self.beers objectAtIndex:indexPath.row];
                    
                    [segue.destinationViewController performSelector:@selector(setBeer:) withObject:beer];
                }
            }
        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    NSDictionary *beer = [self.beers objectAtIndex:indexPath.row];
    
    NSString *imageStringUrl = [[beer objectForKey:@"labels"] objectForKey:@"icon"];
  
    NSString *beerName = [beer objectForKey:@"name"];
    
    cell.textLabel.text = beerName;
    
    UIImage *placeholder = [UIImage imageNamed:@"noBeerAvatar.png"];
    
    [cell.imageView setImageWithURL:[NSURL URLWithString:imageStringUrl] placeholderImage:placeholder];
    
    
    /*
    cell.imageView.image = placeholder;
    
//    cell.imageView.image = nil;

//    cell.imageView.image = [UIImage alloc] initWithContentsOfFile:
    if(imageStringUrl)
    {
    
        // TODO: Do not load the actual image if the beer is
        // not in display anymore
        dispatch_queue_t imageLoadQueue = dispatch_queue_create("image load", NULL);
        dispatch_async(imageLoadQueue, ^{
            
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imageStringUrl]];
            UIImage *beerImage = [[UIImage alloc] initWithData:imageData];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UITableViewCell *updateCell = [tableView cellForRowAtIndexPath:indexPath];
                
                if (updateCell) {
                    updateCell.imageView.image = beerImage;
                    [updateCell setNeedsDisplay];
                }
            });
            
        });
         
    }
     */
    
    return cell;
}

@end
