//
//  BeerFectcher.m
//  Whats My Beer
//
//  Created by Edgar Miranda on 7/5/13.
//  Copyright (c) 2013 Edgar Miranda. All rights reserved.
//

#import "BeerFectcher.h"

@implementation BeerFectcher

#define BreweryDbApiKey @"a98da967d8ca78984b865a43ada143ea"

+(NSArray *)searchForBeersWithString:(NSString *)searchText
{
    
    NSString *baseUrl = @"http://api.brewerydb.com/v2/search?";

    // Refactor this so you can make a search for a brewery and beer from the same
    // function
    NSString *query = [NSString stringWithFormat:@"%@key=%@&q=%@&type=beer", baseUrl, BreweryDbApiKey, searchText];
    
    NSArray *beers = [BeerFectcher beerDBQueryResults:query];

    // Remove all the beers that do not have a description
    
    return beers;
     
}

+(NSArray *)searchForBreweriesWithLat:(NSString *)lat Lng:(NSString *)lng
{
    NSString *baseUrl = @"http://api.brewerydb.com/v2/search/geo/point?";
    NSString *query = [NSString stringWithFormat:@"%@key=%@&lat=%@&lng=%@", baseUrl, BreweryDbApiKey, lat, lng];
    
    NSArray *brewieres = [BeerFectcher beerDBQueryResults:query];
    
    return brewieres;
}

+(NSArray *)beerDBQueryResults:(NSString *)query
{
    query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:query]];
    
    NSError *error;
    
    NSData *response = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&error];
    
    NSDictionary *results = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:&error];
    
    NSArray *beers = [results valueForKey:@"data"];
    
    return beers;
}

@end
