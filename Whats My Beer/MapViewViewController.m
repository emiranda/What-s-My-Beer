//
//  MapViewViewController.m
//  Whats My Beer
//
//  Created by Edgar Miranda on 7/22/13.
//  Copyright (c) 2013 Edgar Miranda. All rights reserved.
//

#import "MapViewViewController.h"
#import "BeerFectcher.h"
#import "BreweryAnnotation.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface MapViewViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) CLGeocoder *geocoder;

@end

@implementation MapViewViewController

- (IBAction)onMapTapGesture:(UITapGestureRecognizer *)sender {
    
   [self.searchBar endEditing:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
    self.searchBar.delegate = self;
    
    UIBarButtonItem *locationButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:100 target:self action:@selector(locateUser)];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0.0, 320.0, 44.0)];
    self.searchBar.barStyle = UIBarStyleBlack;
    self.searchBar.delegate = self;
    
    self.navigationItem.titleView = self.searchBar;
    self.navigationItem.leftBarButtonItem = locationButton;
    
    [super viewDidLoad];    
}

-(CLGeocoder *)geocoder
{
    if(!_geocoder)
        _geocoder = [[CLGeocoder alloc] init];
    
    return _geocoder;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.geocoder geocodeAddressString:searchBar.text
                 completionHandler:^(NSArray* placemarks, NSError* error){
                     for (CLPlacemark* aPlacemark in placemarks)
                     {
                         MKCoordinateRegion mapRegion;
                         mapRegion.center = aPlacemark.location.coordinate;
                         mapRegion.span.latitudeDelta = 0.05;
                         mapRegion.span.longitudeDelta = 0.05;
                         
                         [self.mapView setRegion:mapRegion animated: YES];
                         
                         [self displayBrewersAtLocation:aPlacemark.location];
                     }
    }];
    
}

-(void)locateUser
{
    if(!self.mapView.userLocationVisible){
        self.mapView.showsUserLocation = true;
    }
    
//    MKUserLocation *userLocation = self.mapView.userLocation;
    
    if(self.mapView.userLocation.location)
        [self gotoUserLocation];
    
}


-(void)gotoUserLocation
{
    MKCoordinateRegion mapRegion;
    mapRegion.center = self.mapView.userLocation.coordinate;
    mapRegion.span.latitudeDelta = 0.05;
    mapRegion.span.longitudeDelta = 0.05;
    
    [self.mapView setRegion:mapRegion animated: YES];

}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [self gotoUserLocation];
    
    [self displayBrewersAtLocation:userLocation.location];

}

-(void)displayBrewersAtLocation:(CLLocation *)location
{
    NSString *lat = [NSString stringWithFormat:@"%.10f", location.coordinate.latitude];
    NSString *lng = [NSString stringWithFormat:@"%.10f", location.coordinate.longitude];
    
    NSArray *breweries = [BeerFectcher searchForBreweriesWithLat:lat Lng:lng];
    
    for (NSDictionary *brewery in breweries) {
        
        CLLocationCoordinate2D location;
        location.longitude = [[brewery objectForKey:@"longitude"] doubleValue];
        location.latitude = [[brewery objectForKey:@"latitude"] doubleValue];;
        
        // There was no call out because the title wasn't being set correctly
        // the key was "brewery" not "Brewery"
        NSString *title = [[brewery objectForKey:@"brewery"] objectForKey:@"name"];
        NSString *subTitle = [[brewery objectForKey:@"distance"] description];
        
        subTitle = [subTitle stringByAppendingString:@" miles"];
        
        NSString *imageURL = [[[brewery objectForKey:@"brewery"] objectForKey:@"images"] objectForKey:@"icon"];
        
        //        NSDictionary *breweryData = [brewery objectForKey:@"brewery"];
        
        BreweryAnnotation *breweryAnnotation = [[BreweryAnnotation alloc] initWithCoordinates:location placeTitle:title placeSubTittle:subTitle placeImageURL:imageURL withBrewery:brewery];

        MKPointAnnotation *myLocation = [[MKPointAnnotation alloc] init];
        [myLocation setCoordinate:(CLLocationCoordinate2D){location.longitude, location.latitude}];
        
        
        [self.mapView addAnnotation:myLocation];
        [self.mapView addAnnotation:breweryAnnotation];
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    
    // If it's the user location return nil to have the blue dot display
    if(mapView.userLocation == annotation) return nil;
    
    static NSString *identifier = @"BreweryLocations";
    
    if([annotation isKindOfClass:[BreweryAnnotation class]])
    {
        MKAnnotationView *annotationView = (MKAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        
        
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.image = [UIImage imageNamed:@"mapPin.png"];
            
            annotationView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,30,30)];
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            
            //        annotationView.image = [UIImage imageNamed:@"arrest.png"];//here we use a nice image instead of the default pins
        } else {
            annotationView.annotation = annotation;
        }
        
        if ([annotationView.leftCalloutAccessoryView isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView = (UIImageView *)(annotationView.leftCalloutAccessoryView);
            imageView.image = nil;
        }
        
        return annotationView;
    }else{
        return nil;
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    BreweryAnnotation *annotation = (BreweryAnnotation *)sender;
    NSDictionary *brewery = annotation.brewery;
    
    
    [segue.destinationViewController performSelector:@selector(setBrewery:) withObject:brewery];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"setBrewery:" sender:view.annotation];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([view.leftCalloutAccessoryView isKindOfClass:[UIImageView class]]) {
//        UIImageView *imageView = (UIImageView *)(view.leftCalloutAccessoryView);
        if ([view.annotation respondsToSelector:@selector(imageURL)]) {
            // this should be done in a different thread!

            UIImageView *imageView = (UIImageView *)(view.leftCalloutAccessoryView);

            UIImage *placeholder = [UIImage imageNamed:@"noBeerAvatar.png"];
            imageView.image = placeholder;
            
            if([view.annotation performSelector:@selector(imageURL)])
            {

                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                [manager downloadWithURL:[view.annotation performSelector:@selector(imageURL)]
                                 options:0
                                progress:^(NSUInteger receivedSize, long long expectedSize)
                 {
                     // progression tracking code
                 }
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
                 {
                     if(image)
                     {
                         UIImageView *imageView = (UIImageView *)(view.leftCalloutAccessoryView);
                         imageView.image = image;
                     }
                 }];
                
                /*
                dispatch_queue_t imageLoadQueue = dispatch_queue_create("image load", NULL);
                dispatch_async(imageLoadQueue, ^{
                    
                    NSString *imageURL = [view.annotation performSelector:@selector(imageURL)];
                    NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imageURL]];
                    UIImage *breweryImage = [[UIImage alloc] initWithData:imageData];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIImageView *imageView = (UIImageView *)(view.leftCalloutAccessoryView);
                        imageView.image = breweryImage;
                    });
                    
                });
                 */
            }
            
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
