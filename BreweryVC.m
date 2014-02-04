//
//  BreweryVC.m
//  Whats My Beer
//
//  Created by Edgar Miranda on 7/29/13.
//  Copyright (c) 2013 Edgar Miranda. All rights reserved.
//

#import "BreweryVC.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface BreweryVC ()
@property (strong, nonatomic) IBOutlet UILabel *breweryNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *breweryImage;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *webLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UITextView *descriptionText;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *descriptionHeight;

@property (strong,nonatomic) NSDictionary *stateAbbreviations;
@end

@implementation BreweryVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setBrewery:(NSDictionary *)brewery
{
    _brewery = brewery;
//    [self reloadData];
    
}
- (IBAction)onWebsiteTap:(UITapGestureRecognizer *)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: self.webLabel.text]];
}
- (IBAction)tapThisThing:(UITapGestureRecognizer *)sender {
    NSLog(@"Thing was tapped");
}


- (IBAction)onDamnPhoneTap:(id)sender {
    NSLog(@"tap this shit");
}

- (IBAction)onPhoneTap:(UITapGestureRecognizer *)sender {
    
    NSString *URLString = [@"tel://" stringByAppendingString:self.phoneLabel.text];
    
    NSURL *URL = [NSURL URLWithString:URLString];
    
    [[UIApplication sharedApplication] openURL:URL];
    
    NSLog(@"freakin work bitch");
}

-(void)reloadData
{

    // Remember to remove my number and address from the interface builder file
    self.breweryNameLabel.text = [[self.brewery objectForKey:@"brewery"] objectForKey:@"name"];
    
    if([[self.brewery objectForKey:@"brewery"] objectForKey:@"website"])
        self.webLabel.text = [[self.brewery objectForKey:@"brewery"] objectForKey:@"website"];
    
    if([self.brewery objectForKey:@"phone"])
        self.phoneLabel.text = [self.brewery objectForKey:@"phone"];
    
    if([[self.brewery objectForKey:@"brewery"] objectForKey:@"description"])
        self.descriptionText.text = [[self.brewery objectForKey:@"brewery"] objectForKey:@"description"];
    
    NSString *address = [self.brewery objectForKey:@"streetAddress"];
    if(address == nil) address = @"";
    NSString *city = [self.brewery objectForKey:@"locality"];
    if(city == nil) city = @"";
    NSString *state = [self.stateAbbreviations objectForKey:[self.brewery objectForKey:@"region"]];
    if(state == nil) state = @"";
    NSString *zipCode = [self.brewery objectForKey:@"postalCode"];
    if(zipCode  == nil) zipCode = @"";
    
    NSArray *completeAdress = @[address, @" ", city];
    
//    NSArray *completeAdress = @[address, @" ", city, @", ", state, @" ", zipCode];
    
    address = [completeAdress componentsJoinedByString:@""];
    
    self.addressLabel.text = address;
    
    NSLog(@"height after %.2f", self.descriptionText.contentScaleFactor);
    
    NSString *imageStringUrl = [[[self.brewery objectForKey:@"brewery"] objectForKey:@"images"] objectForKey:@"large"];
    
    if(imageStringUrl)
    {
        
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadWithURL:[NSURL URLWithString:imageStringUrl]
                         options:0
                        progress:^(NSUInteger receivedSize, long long expectedSize)
         {
             // progression tracking code
         }
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
         {
             if(image)
             {
                 self.breweryImage.image = image;
             }
         }];
        
        
        /*
        // TODO: Do not load the actual image if the beer is
        // not in display anymore
        dispatch_queue_t imageLoadQueue = dispatch_queue_create("image load", NULL);
        dispatch_async(imageLoadQueue, ^{
            
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imageStringUrl]];
            UIImage *breweryImage = [[UIImage alloc] initWithData:imageData];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.breweryImage.image = breweryImage;
                
            });
            
        });
         */
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self reloadData];
    
    self.scrollView.delegate = self;
    
//    UIFont *arialBold = [UIFont fontWithName:<#(NSString *)#> size:<#(CGFloat)#>]
    
//    self.breweryNameLabel
    
	// Do any additional setup after loading the view.
    
    /*
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPhoneTap:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.phoneLabel addGestureRecognizer:tapGestureRecognizer];
    self.phoneLabel.userInteractionEnabled = YES;
     */
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x != 0) {
        CGPoint offset = scrollView.contentOffset;
        offset.x = 0;
        scrollView.contentOffset = offset;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    
    self.descriptionHeight.constant = self.descriptionText.contentSize.height + 55;
    
//    CGSize scrollableSize = CGSizeMake(320, self.scrollView.contentSize.height);
//    [self.scrollView setContentSize:scrollableSize];
//    self.scrollView.contentSize = scrollableSize;
}



-(NSDictionary *)stateAbbreviations
{
    if(_stateAbbreviations == nil)
    {
        _stateAbbreviations = @{
            
            @"Alabama" : @"AL",
            @"Alaska"  : @"AK",
            @"Arizona" : @"AZ",
            @"Arkansas" :  @"AR",
            @"California" :	@"CA",
            @"Colorado" :	@"CO",
            @"Connecticut" :	@"CT",
            @"Delaware" :	@"DE",
            @"Florida" :	@"FL",
            @"Georgia" :	@"GA",
            @"Hawaii" :	@"HI",
            @"Idaho" :	@"ID",
            @"Illinois" : @"IL",
            @"Indiana" :	@"IN",
            @"Iowa" :	@"IA",
            @"Kansas" :	@"KS",
            @"Kentucky" :	@"KY",
            @"Louisiana" :	@"LA",
            @"Maine" :	@"ME",
            @"Maryland" :	@"MD",
            @"Massachusetts" :	@"MA",
            @"Michigan" :	@"MI",
            @"Minnesota" :	@"MN",
            @"Mississippi" :	@"MS",
            @"Missouri" :	@"MO",
            @"Montana" :	@"MT",
            @"Nebraska" :	@"NE",
            @"Nevada" :	@"NV",
            @"New Hampshire" :	@"NH",
            @"New Jersey" :	@"NJ",
            @"New Mexico" :	@"NM",
            @"New York" :	@"NY",
            @"North Carolina" :	@"NC",
            @"North Dakota" :	@"ND",
            @"Ohio" :	@"OH",
            @"Oklahoma" :	@"OK",
            @"Oregon" :	@"OR",
            @"Pennsylvania" :	@"PA",
            @"Rhode Island" :	@"RI",
            @"South Carolina" :	@"SC",
            @"South Dakota" :	@"SD",
            @"Tennessee" :	@"TN",
            @"Texas" :	@"TX",
            @"Utah" :	@"UT",
            @"Vermont" :	@"VT",
            @"Virginia" :	@"VA",
            @"Washington" :	@"WA",
            @"West Virginia" :	@"WV",
            @"Wisconsin" :	@"WI",
            @"Wyoming" :	@"WY",
        };
    }
    
    return _stateAbbreviations;
}



@end
