//
//  BreweryAnnotation.h
//  Whats My Beer
//
//  Created by Edgar Miranda on 7/26/13.
//  Copyright (c) 2013 Edgar Miranda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface BreweryAnnotation : NSObject<MKAnnotation>


@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *subtitle;
@property (nonatomic, readonly) NSString *imageURL;
@property (nonatomic, readonly) NSDictionary *brewery;

- (id)initWithCoordinates:(CLLocationCoordinate2D)location placeTitle:(NSString *)placeTitle placeSubTittle:(NSString *)subTitle placeImageURL:(NSString *) imageURL withBrewery:(NSDictionary *) brewery;

@end