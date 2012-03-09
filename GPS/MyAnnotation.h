//
//  MyAnnotation.h
//  GPS
//
//  Created by Marian PAUL on 08/03/12.
//  Copyright (c) 2012 iPuP SARL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MyAnnotation : NSObject <MKAnnotation> 

// pour être conforme au protocole MKAnnotation
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
// requis par le protocole
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end
