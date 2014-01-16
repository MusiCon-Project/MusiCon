//
//  CuttingView.m
//  Modules
//
//  Created by JHLee on 11. 6. 4..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CuttingView.h"


@implementation CuttingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code           
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code

    [self drawBoundary];
}

- (void)drawBoundary
{
    for(UIView *subviews in [self subviews])
    {
        [subviews removeFromSuperview];
    }

    //Top
    for (int i = 0 ; i < 10; i ++) {
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, i, self.frame.size.width * 0.8 - i, 1)];
        [line setBackgroundColor:[UIColor yellowColor]];
        
        [self addSubview:line];
        [line release];
    }
    
    //left
    for (int i = 0 ; i < 10; i ++) {
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(i, 0, 1, self.frame.size.height * 0.8 - i)];
        [line setBackgroundColor:[UIColor yellowColor]];
        
        [self addSubview:line];
        [line release];
    }
    
    //end
    for (int i = 0 ; i < 10; i ++) {
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width * 0.2 + i, self.frame.size.height - i, self.frame.size.width * 0.8 - i, 1)];
        [line setBackgroundColor:[UIColor yellowColor]];
        
        [self addSubview:line];
        [line release];
    }
    
    //right
    for (int i = 0 ; i < 10; i ++) {
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width - i, self.frame.size.height * 0.2 + i, 1, self.frame.size.height * 0.8 - i)];
        [line setBackgroundColor:[UIColor yellowColor]];
        
        [self addSubview:line];
        [line release];
    }

    
    [self setBackgroundColor:[UIColor clearColor]];
    
}

- (void)dealloc
{
    [super dealloc];
}

@end
