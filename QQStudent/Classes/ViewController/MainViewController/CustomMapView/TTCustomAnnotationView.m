//
//  TTCustomAnnotationView.m
//  QQStudent
//
//  Created by lynn on 14-2-7.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "TTCustomAnnotationView.h"

@implementation TTCustomAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithAnnotation:(id)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation
                     reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor   = [UIColor clearColor];
        
        //大头针的图片
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//        [imageView setImage:[UIImage imageNamed:@"itop.png"]];
//        [self addSubview:imageView];
        self.image = [UIImage imageNamed:@"itop.png"];
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end
