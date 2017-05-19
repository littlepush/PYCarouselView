//
//  PYCarouselView.h
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

#import <UIKit/UIKit.h>
#import "PYCarouselContentView.h"

typedef void (^PYCarouselViewClick)(NSInteger index);

typedef NS_ENUM(NSInteger, PYCarouselViewIndicatorAlignment) {
    PYCarouselViewIndicatorAlignmentLeft        = 0,
    PYCarouselViewIndicatorAlignmentCenter      = 1,
    PYCarouselViewIndicatorAlignmentRight       = 2
};

@interface PYCarouselView : PYView

// If current carsousel content view has been click
@property (nonatomic, copy)     PYCarouselViewClick onClick;

@property (nonatomic, assign)   BOOL                                    allowAutoPlay;
@property (nonatomic, assign)   CGFloat                                 interval;
@property (nonatomic, assign)   BOOL                                    showIndicator;
@property (nonatomic, assign)   PYCarouselViewIndicatorAlignment        indicatorAlignment;
@property (nonatomic, strong)   UIColor                                 *indicatorHighlightColor;
@property (nonatomic, strong)   UIColor                                 *indicatorNormalColor;

// Properties for content view
@property (nonatomic, strong)   UIImage                                 *placeholdImage;
@property (nonatomic, assign)   CGFloat                                 descriptionHeight;
@property (nonatomic, strong)   UIColor                                 *descriptionBackground;
@property (nonatomic, strong)   UIFont                                  *descriptionFont;
@property (nonatomic, strong)   UIColor                                 *descriptionTextColor;
@property (nonatomic, assign)   NSTextAlignment                         descriptionTextAlign;

// Load Carousel View without description
- (void)loadCarouselViewWithImages:(NSArray *)imageUrls;
// Load Carousel View with image and description
- (void)loadCarouselViewWithImages:(NSArray *)imageUrls descriptions:(NSArray *)descriptions;

@end

// @littlepush
// littlepush@gmail.com
// PYLab
