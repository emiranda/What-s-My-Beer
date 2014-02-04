//
//  BeerFectcher.h
//  Whats My Beer
//
//  Created by Edgar Miranda on 7/5/13.
//  Copyright (c) 2013 Edgar Miranda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeerFectcher : NSObject

typedef enum {
	FlickrPhotoFormatSquare = 1,
	FlickrPhotoFormatLarge = 2,
	FlickrPhotoFormatOriginal = 64
} SearchType;

+(NSArray *)searchForBeersWithString:(NSString *)searchText;
+(NSArray *)searchForBreweriesWithLat:(NSString *)lat Lng:(NSString *)lng;

@end
