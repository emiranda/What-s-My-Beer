//
//  BeerVC.m
//  Whats My Beer
//
//  Created by Edgar Miranda on 7/10/13.
//  Copyright (c) 2013 Edgar Miranda. All rights reserved.
//

#import "BeerVC.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface BeerVC ()
@property (weak, nonatomic) IBOutlet UILabel *beerNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *beerDescriptionTextView;
@property (weak, nonatomic) IBOutlet UIImageView *beerImageView;
@property (weak, nonatomic) IBOutlet UILabel *abvLabel;
@property (weak, nonatomic) IBOutlet UILabel *styleLabel;
    
@end

@implementation BeerVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setBeer:(NSDictionary *)beer
{
    _beer = beer;
    [self reloadBeerData];
}

-(void)reloadBeerData
{
    self.beerNameLabel.text = [self.beer valueForKey:@"name"];
    
    if([self.beer valueForKey:@"description"])
        self.beerDescriptionTextView.text = [self.beer valueForKey:@"description"];
    
    if([self.beer valueForKey:@"abv"])
        self.abvLabel.text = [[self.beer valueForKey:@"abv"] stringByAppendingString:@"%"];
    
    if([[[self.beer valueForKey:@"style"] valueForKey:@"category"] valueForKey:@"name"])
    {
        self.styleLabel.text = [[[self.beer valueForKey:@"style"] valueForKey:@"category"] valueForKey:@"name"];
    }
    
    
    
    
    NSString *imageStringUrl;
    
    NSDictionary *labels = [self.beer objectForKey:@"labels"];
    NSURL *imageURL;
    
    if(labels){
        imageStringUrl = [labels objectForKey:@"medium"];
        imageURL = [[NSURL alloc] initWithString:imageStringUrl];
    }
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadWithURL:imageURL
                     options:0
                    progress:^(NSUInteger receivedSize, long long expectedSize)
     {
         // progression tracking code
     } 
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
     {
         if(image)
         {
             self.beerImageView.image = image;
         }
     }];
    
        /*
        // TODO: Do not load the actual image if the beer is
        // not in display anymore
        dispatch_queue_t imageLoadQueue = dispatch_queue_create("image load", NULL);
        dispatch_async(imageLoadQueue, ^{
         
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imageStringUrl]];
            
            UIImage *beerImage = [[UIImage alloc] initWithData:imageData];
            
            self.beerImageView.frame = CGRectMake(self.beerImageView.frame.origin.x, self.beerImageView.frame.origin.y, 101, 101);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.beerImageView.image = beerImage;
	
            });
            
        });
         
         }
        */
        
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self reloadBeerData];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
