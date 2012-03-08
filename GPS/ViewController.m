//
//  ViewController.m
//  GPS
//
//  Created by Marian PAUL on 08/03/12.
//  Copyright (c) 2012 IPuP SARL. All rights reserved.
//

#import "ViewController.h"

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
    _labelReverseGeoCoder = [[UILabel alloc] initWithFrame:CGRectMake(20, 380, 280, 38)];
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
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
