//
//  PYCarouselContentView.m
//  PYCarouselView
//
//  Created by Push Chen on 19/05/2017.
//  Copyright © 2017 PushLab. All rights reserved.
//

/*
 LGPL V3 Lisence
 This file is part of cleandns.
 
 PYUIKit is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 PYData is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with cleandns.  If not, see <http://www.gnu.org/licenses/>.
 */

/*
 LISENCE FOR IPY
 COPYRIGHT (c) 2013, Push Chen.
 ALL RIGHTS RESERVED.
 
 REDISTRIBUTION AND USE IN SOURCE AND BINARY
 FORMS, WITH OR WITHOUT MODIFICATION, ARE
 PERMITTED PROVIDED THAT THE FOLLOWING CONDITIONS
 ARE MET:
 
 YOU USE IT, AND YOU JUST USE IT!.
 WHY NOT USE THIS LIBRARY IN YOUR CODE TO MAKE
 THE DEVELOPMENT HAPPIER!
 ENJOY YOUR LIFE AND BE FAR AWAY FROM BUGS.
 */

#import "PYCarouselContentView.h"

@interface PYCarouselContentView ()
{
    PYImageView                 *_ivContentImage;
    UIView                      *_vDespContainer;
    PYLabel                     *_lbDescription;
    
    CGFloat                     _fDescriptionHeight;
    BOOL                        _bShowDescription;
}

@end

@implementation PYCarouselContentView

@dynamic placeholdImage;
- (UIImage *)placeholdImage { return _ivContentImage.placeholdImage; }
- (void)setPlaceholdImage:(UIImage *)placeholdImage
{
    [_ivContentImage setPlaceholdImage:placeholdImage];
}
@dynamic imageUrl;
- (NSString *)imageUrl { return _ivContentImage.loadingUrl; }
- (void)setImageUrl:(NSString *)imageUrl
{
    [_ivContentImage setImageUrl:imageUrl];
}
@dynamic descriptionHeight;
- (CGFloat)descriptionHeight { return _fDescriptionHeight; }
- (void)setDescriptionHeight:(CGFloat)descriptionHeight
{
    _fDescriptionHeight = descriptionHeight;
    // Redraw
    [self setNeedsDisplay];
}
@dynamic descriptionBackground;
- (UIColor *)descriptionBackground { return _vDespContainer.backgroundColor; }
- (void)setDescriptionBackground:(UIColor *)descriptionBackground
{
    [_vDespContainer setBackgroundColor:descriptionBackground];
}
@dynamic descriptionText;
- (NSString *)descriptionText { return _lbDescription.text; }
- (void)setDescriptionText:(NSString *)descriptionText
{
    [_lbDescription setText:descriptionText];
}
@synthesize descriptionLabel = _lbDescription;

@dynamic showDescription;
- (BOOL)showDescription { return _bShowDescription; };
- (void)setShowDescription:(BOOL)showDescription
{
    _bShowDescription = showDescription;
    [self setNeedsDisplay];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)viewJustBeenCreated
{
    [super viewJustBeenCreated];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    _ivContentImage = [[PYImageView alloc] init];
    [self addChild:_ivContentImage];
    _vDespContainer = [[UIView alloc] init];
    [self addChild:_vDespContainer];
    _lbDescription = [PYLabel object];
    [_vDespContainer addChild:_lbDescription];
    
    _fDescriptionHeight = 48.f;
    _bShowDescription = YES;
    [_vDespContainer setBackgroundColor:[UIColor colorWithString:@"#000000" alpha:.5]];
    [_lbDescription setTextFont:[UIFont systemFontOfSize:14.f]];
    [_lbDescription setPaddingLeft:10.f];
    [_lbDescription setPaddingRight:10.f];
    [_lbDescription setMultipleLine:YES];
    [_lbDescription setTextColor:[UIColor whiteColor]];
    [_lbDescription setBackgroundColor:[UIColor clearColor]];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGRect _b = [self bounds];
    [_ivContentImage setFrame:_b];
    
    [_vDespContainer setFrame:CGRectMake(0, _b.size.height - _fDescriptionHeight, _b.size.width, _fDescriptionHeight)];
    [_lbDescription setFrame:_vDespContainer.bounds];
    
    if ( _bShowDescription == YES ) {
        [_vDespContainer setAlpha:1];
    } else {
        [_vDespContainer setAlpha:0];
    }
}

@end

// @littlepush
// littlepush@gmail.com
// PYLab
