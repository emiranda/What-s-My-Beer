//
//  BreweryAnnotation.m
//  Whats My Beer
//
//  Created by Edgar Miranda on 7/26/13.
//  Copyright (c) 2013 Edgar Miranda. All rights reserved.
//

#import "BreweryAnnotation.h"

@interface BreweryAnnotation()
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, readwrite) NSDictionary *brewery;

@end

@implementation BreweryAnnotation 

- (id)initWithCoordinates:(CLLocationCoordinate2D)location placeTitle:(NSString *)placeTitle placeSubTittle:(NSString *)subTitle placeImageURL:(NSString *) imageURL withBrewery:(NSDictionary *) brewery;
{
    self = [super init];
    if (self != nil) {
        self.coordinate = location;
        self.title = placeTitle;

        self.subtitle = subTitle;
        self.imageURL = imageURL;
        self.brewery = brewery;
    }
    return self;
}


@end
