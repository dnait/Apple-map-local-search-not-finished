//
//  ViewController.m
//  MKLocalSearchSample
//
//  Created by koogawa on 2014/03/21.
//  Copyright (c) 2014年 Kosuke Ogawa. All rights reserved.
//

#import "ViewController.h"
#import "mapitemsDict.h"


@interface ViewController ()

{ CLLocationManager *locationManager;
    
    NSString *userLat;
    NSString *userLong;
    
    CLLocation *startLocation;
    CLLocation *endLocation;
    CLLocationDistance distance;
    NSString  *strdistance;
    
    NSObject *resultitems;
    NSMutableDictionary *resultdict;
    NSMutableArray *assortedmapitemArray;
    

    
    NSMutableArray *resultKey;
    
}

@end

@implementation ViewController
{
   
    NSMutableArray *mapItems;
    MKLocalSearchResponse *results;
    NSArray *tableData;

}
@synthesize mapView;
@synthesize resulttableView;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.mapView.delegate=self;
    [self.mapView setShowsUserLocation:YES];
    
    locationManager=[[CLLocationManager alloc]init];
    locationManager.delegate=self;
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    //
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
    
    userLat= [NSString stringWithFormat:@"%.8f", locationManager.location.coordinate.latitude];
        userLong= [NSString stringWithFormat:@"%.8f", locationManager.location.coordinate.longitude];
    //user's accurate location
    startLocation= [[CLLocation alloc] initWithLatitude:locationManager.location.coordinate.latitude longitude:locationManager.location.coordinate.longitude];
    

    NSLog(@"User's latitude: %@", userLat);
    
    NSLog(@"User's longtitude: %@", userLong);

    self.resulttableView.dataSource = self;
    self.resulttableView.delegate = self;
    
    mapItems=[[NSMutableArray alloc]init];
    resultdict=[[NSMutableDictionary alloc]init];
    assortedmapitemArray=[[NSMutableArray alloc]init];
    

    
  
}


-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
      [self.resulttableView reloadData];
}





#pragma mark - UISearchBar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
	[searchBar resignFirstResponder];

  
	MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
	request.naturalLanguageQuery = searchBar.text;
	request.region = mapView.region;
	MKLocalSearch *localsearch = [[MKLocalSearch alloc] initWithRequest:request];

   
	[localsearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error)
     {
         [mapItems removeAllObjects];
         [mapView removeAnnotations:[mapView annotations]];
         
         if (error != nil) {
             [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Map Error",nil)
                                         message:[error localizedDescription]
                                        delegate:nil
                               cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil] show];
             return;
         }
         
         if ([response.mapItems count] == 0) {
             [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No Results",nil)
                                         message:nil
                                        delegate:nil
                               cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil] show];
             return;
         }


         for (MKMapItem *item in response.mapItems)
         {
             MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
             point.coordinate = item.placemark.coordinate;
             point.title = item.placemark.name;
             point.subtitle = item.placemark.title;
             
             //endlocation with coordinate
            endLocation= [[CLLocation alloc] initWithLatitude:item.placemark.coordinate.latitude longitude:item.placemark.coordinate.longitude];
            //get distance and convert it from KM to Miles
            distance = [endLocation distanceFromLocation:startLocation]* 0.000621371;;
            strdistance= [NSString stringWithFormat:@"%.2f", distance];

             [mapView addAnnotation:point];
             [mapItems addObject:item];
            [resultdict setObject:item forKey:strdistance];
             
         }

         [mapView showAnnotations:[mapView annotations] animated:YES];
          [self.resulttableView reloadData];
     }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	[searchBar resignFirstResponder];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
	[searchBar setShowsCancelButton:YES animated:YES];
	return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
	[searchBar setShowsCancelButton:NO animated:YES];
	return YES;
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{ CLLocationCoordinate2D myLocation=[userLocation coordinate];
    MKCoordinateRegion zoomRegion=MKCoordinateRegionMakeWithDistance(myLocation, 1000, 1000);
    [self.mapView setRegion:zoomRegion animated: YES];
    
    
}

#pragma mark --CoreLocationLocationManager methods
-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [locationManager requestAlwaysAuthorization];
    [locationManager startUpdatingLocation];
   
    
}
-(void)locationmanager:(CLLocationManager *)manager didChangeAuthorizationStatus:
(CLAuthorizationStatus)status
{
    if (status==kCLAuthorizationStatusAuthorizedAlways|| status ==kCLAuthorizationStatusAuthorizedWhenInUse){
        self.mapView.showsUserLocation=YES;
    }
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   //return [resultdict count];
  return [mapItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *IDENTIFIER = @"SearchResultsCell";
    
    searchresultsCell *cell = [resulttableView dequeueReusableCellWithIdentifier:IDENTIFIER];
    if (cell == nil) {
        cell = [[searchresultsCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:IDENTIFIER];
    }
    
    //sort the resultdict key and return sorted key array
    NSArray *keys = [resultdict allKeys];
    
    NSArray *sortedkeyArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
    {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    for (NSString *categoryId in sortedkeyArray) {
        
     //   NSArray *object=[resultdict objectForKey:categoryId];
     
        [assortedmapitemArray addObject:[resultdict objectForKey:categoryId]];
        
    };
      //MKMapItem *item = mapItems[indexPath.row];
   
    MKMapItem *item = assortedmapitemArray[indexPath.row];
  
   // resultKey= [[NSMutableArray alloc]initWithArray:[resultdict allKeys]];

    
    cell.name.text = item.name;
    cell.address.text = item.placemark.addressDictionary[@"Street"];
    //cell.milelabel.text=[resultKey objectAtIndex:indexPath.row];
    cell.milelabel.text=[sortedkeyArray objectAtIndex:indexPath.row];
   // cell.milelabel.text=??
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.searchDisplayController setActive:NO animated:YES];
    
    MKMapItem *item = results.mapItems[indexPath.row];
    [self.mapView addAnnotation:item.placemark];
    [self.mapView selectAnnotation:item.placemark animated:YES];
    
    [self.mapView setCenterCoordinate:item.placemark.location.coordinate animated:YES];
    
    [self.mapView setUserTrackingMode:MKUserTrackingModeNone];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
