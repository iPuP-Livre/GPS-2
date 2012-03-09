//
//  ViewController.h
//  GPS
//
//  Created by Marian PAUL on 08/03/12.
//  Copyright (c) 2012 IPuP SARL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <MKMapViewDelegate>
{
    MKMapView *_myMapView; 
    CLGeocoder *_geoCoder;

    UILabel *_labelReverseGeoCoder;
    UIButton *_buttonLaunchReverseGeocoder;
    UIActivityIndicatorView *_activityReverseGeoCoder;
    
    NSMutableArray *_arrayOfAnnotations; 
}
@end
