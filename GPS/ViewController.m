//
//  ViewController.m
//  GPS
//
//  Created by Marian PAUL on 08/03/12.
//  Copyright (c) 2012 IPuP SARL. All rights reserved.
//

#import "ViewController.h"
#import "MyAnnotation.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // initialisation de la carte
    _myMapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 360)];
    // affichage de la position de l'utilisateur
    _myMapView.showsUserLocation = YES;
    // on change le type d'affichage pour mettre carte + satellite
    _myMapView.mapType = MKMapTypeHybrid;
    // self recevra les événements de maMapView
    _myMapView.delegate = self;
    
    [self.view addSubview:_myMapView];
    
    // déclaration du label affichant l'adresse actuelle de l'utilisateur
    _labelReverseGeoCoder = [[UILabel alloc] initWithFrame:CGRectMake(20, 360, 280, 70)];
    _labelReverseGeoCoder.numberOfLines = 2;
    _labelReverseGeoCoder.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_labelReverseGeoCoder];
    
    // déclaration du bouton qui va servir à lancer le reverse geo coder
    _buttonLaunchReverseGeocoder = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _buttonLaunchReverseGeocoder.frame = CGRectMake(20, 420, 180, 30);
    [_buttonLaunchReverseGeocoder setTitle:@"Donne mon adresse" forState:UIControlStateNormal];
    [_buttonLaunchReverseGeocoder addTarget:self action:@selector(reverseGeocodeCurrentLocation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_buttonLaunchReverseGeocoder];
    
    // déclaration de la roue qui indique une activité
    _activityReverseGeoCoder = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityReverseGeoCoder.hidesWhenStopped = YES;
    _activityReverseGeoCoder.center = CGPointMake(260, 430);
    [self.view addSubview:_activityReverseGeoCoder];
    
    
    
    // Ajout des annotations
    _arrayOfAnnotations = [[NSMutableArray alloc] initWithCapacity:2];
    
    MyAnnotation *annotation = [[MyAnnotation alloc] init];
    annotation.title = @"Paris";
    annotation.subtitle = @"Capitale de la france";
    annotation.coordinate = CLLocationCoordinate2DMake(48.0+52.0/60.0, 2.0+20.0/60.0);
    [_arrayOfAnnotations addObject:annotation];
    
    annotation = [[MyAnnotation alloc] init];
    annotation.title = @"Marseille";
    annotation.subtitle = @"La ville du soleil";
    annotation.coordinate = CLLocationCoordinate2DMake(43.0+17.0/60.0, 5.0+22.0/60.);
    [_arrayOfAnnotations addObject:annotation];
    
    [_myMapView addAnnotations:_arrayOfAnnotations];
    
}

#pragma mark - Button methods
- (void)reverseGeocodeCurrentLocation : (id) sender
{
    // test de la précision
    if(_myMapView.userLocation.location.horizontalAccuracy > 100.0) // distance en mètres
    {
        //précision insuffisante, on affiche une alert view
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Erreur" 
                                                       message:[NSString stringWithFormat:@"La précision de %.2f m est insuffisante", _myMapView.userLocation.location.horizontalAccuracy]    
                                                      delegate:nil
                                             cancelButtonTitle:@"Ok"
                                             otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        // la précision est suffisante, on demande à faire un reverse
        [_activityReverseGeoCoder startAnimating];
        
        // on lance le reverse geo coder
        // on alloue init, si pas encore alloué
        if (!_geoCoder) _geoCoder = [[CLGeocoder alloc] init];
        // on lance le reverse geo coding
        [_geoCoder reverseGeocodeLocation:_myMapView.userLocation.location
                        completionHandler:^(NSArray *placemarks, NSError *error) {
                            if (!error) {
                                if (placemarks.count != 0) {
                                    // Si pas d'erreurs et si un ou plusieurs résultats ont été trouvés, alors on affiche le premier résultat du tableau
                                    CLPlacemark *placemark = (CLPlacemark*)[placemarks objectAtIndex:0];
                                    _labelReverseGeoCoder.text = [NSString stringWithFormat:@"%@, %@, %@, %@", placemark.country, placemark.postalCode, placemark.locality, placemark.thoroughfare];
                                    // on arrête l'animation de chargement
                                    [_activityReverseGeoCoder stopAnimating]; 
                                }
                            }
                            else {
                                NSLog(@"error on geo code %@", [error localizedDescription]);
                            }
                        }];
    }    
}

- (void) displayDetails : (id) sender {
    NSLog(@"ici, on pourrait présenter un controller qui afficherait le détail de l'annotation");  
}

#pragma mark - MKMapView delegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    // on zoome
    MKCoordinateSpan span = {0.01, 0.01};
    [mapView setRegion:MKCoordinateRegionMake(mapView.userLocation.location.coordinate, span) animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // si c'est la position de l'utilisateur, on laisse tel quel
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // On teste nos types d'annotations. Ici c'est inutile car on en a qu'une, mais au moins vous saurez le faire !
    if ([annotation isKindOfClass:[MyAnnotation class]])
    {
        //On essaye de dépiler une annotation view en premier
        static NSString* MyAnnotationIdentifier = @"myAnnotationIdentifier";
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)[theMapView dequeueReusableAnnotationViewWithIdentifier:MyAnnotationIdentifier];
        if (!pinView)
        {
            // Si il n'y en avait aucune de disponible, on en crée une tout simplement !
            MKPinAnnotationView* customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                                                 reuseIdentifier:MyAnnotationIdentifier];
            
            customPinView.pinColor = MKPinAnnotationColorGreen;
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
            
            // On ajoute une petite flèche sur le côté pour afficher plus d'informations en cliquant dessus
            //
            // Info : on pourrait implémenter directement :
            //  - (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;
            //L'avantage ici est de choisir ce que l'on veut mettre
            
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButton addTarget:self
                            action:@selector(displayDetails:)
                  forControlEvents:UIControlEventTouchUpInside];
            customPinView.rightCalloutAccessoryView = rightButton;
            
            // ajout d'une image à gauche
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            imageView.image = [UIImage imageNamed:@"annotationImage.png"];
            customPinView.leftCalloutAccessoryView = imageView;
            
            return customPinView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    
    return nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    _myMapView = nil; 
    _activityReverseGeoCoder = nil;
    _labelReverseGeoCoder = nil;
    _buttonLaunchReverseGeocoder = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
