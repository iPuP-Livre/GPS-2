//
//  MyAnnotationView.m
//  GPS
//
//  Created by Marian PAUL on 08/03/12.
//  Copyright (c) 2012 iPuP SARL. All rights reserved.
//

#import "MyAnnotationView.h"

@implementation MyAnnotationView

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self != nil)
    {
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        view.image = [UIImage imageNamed:@"annotationImage.png"];
        [self addSubview:view];
    }
    return self;
}

- (void)setAnnotation:(id <MKAnnotation>)annotation
{
    [super setAnnotation:annotation];
    // pour updater si besoin l'affichage lors que l'on utilise reuseIdentifier
    [self setNeedsDisplay];
}
/*
- (void)drawRect:(CGRect)rect
{
    // à implémenter si besoin de dessiner
}*/

@end
