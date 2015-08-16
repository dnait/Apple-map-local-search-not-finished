

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "searchresultsCell.h"

@interface ViewController : UIViewController <UISearchBarDelegate,MKMapViewDelegate,CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *resulttableView;



@end
