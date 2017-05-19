//
//  PYCarouselView.m
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

#import "PYCarouselView.h"

typedef PYCarouselViewIndicatorAlignment    PY_CVIAlign;
@interface PYCarouselView () <UIScrollViewDelegate>
{
    // Subviews
    UIScrollView                *_scrollView;
    PYCarouselContentView       *_currentContent;
    PYCarouselContentView       *_nextContent;
    UIPageControl               *_pctlIndicator;
    
    // Flags
    BOOL                        _bAllowAutoPlay;
    NSTimer                     *_tAutoPlayTimer;
    CGFloat                     _fInterval;
    PY_CVIAlign                 _aIndicatorAlign;
    
    // Data
    NSArray                     *_images;
    NSArray                     *_descTexts;
    NSInteger                   _currentIndex;
    NSInteger                   _nextIndex;
    
    // Gesture
    UITapGestureRecognizer      *_tapGesture;
}
@end

@implementation PYCarouselView

@synthesize onClick;

@dynamic allowAutoPlay;
- (BOOL)allowAutoPlay { return _bAllowAutoPlay; }
- (void)setAllowAutoPlay:(BOOL)allowAutoPlay
{
    PYSingletonLock
    if ( allowAutoPlay == _bAllowAutoPlay ) return;
    _bAllowAutoPlay = allowAutoPlay;
    if ( allowAutoPlay ) {
        [self beginAutoPlayTimer];
    } else {
        [self endAutoPlayTimer];
    }
    PYSingletonUnLock
}

@dynamic interval;
- (CGFloat)interval { return _fInterval; }
- (void)setInterval:(CGFloat)interval
{
    PYSingletonLock
    _fInterval = interval;
    if ( !_bAllowAutoPlay ) return;
    // Restart if current is auto playing
    [self endAutoPlayTimer];
    [self beginAutoPlayTimer];
    PYSingletonUnLock
}

@dynamic showIndicator;
- (BOOL)showIndicator { return _pctlIndicator.alpha > 0.f; }
- (void)setShowIndicator:(BOOL)showIndicator
{
    if ( showIndicator ) {
        [_pctlIndicator setAlpha:1.f];
    } else {
        [_pctlIndicator setAlpha:0.f];
    }
}

@dynamic indicatorAlignment;
- (PYCarouselViewIndicatorAlignment)indicatorAlignment { return _aIndicatorAlign; }
- (void)setIndicatorAlignment:(PYCarouselViewIndicatorAlignment)indicatorAlignment
{
    PYSingletonLock
    if ( indicatorAlignment == _aIndicatorAlign ) return;
    _aIndicatorAlign = indicatorAlignment;
    [self setNeedsLayout];
    PYSingletonUnLock
}

@dynamic indicatorNormalColor;
- (UIColor *)indicatorNormalColor { return _pctlIndicator.pageIndicatorTintColor; }
- (void)setIndicatorNormalColor:(UIColor *)indicatorNormalColor
{
    [_pctlIndicator setPageIndicatorTintColor:indicatorNormalColor];
}
@dynamic indicatorHighlightColor;
- (UIColor *)indicatorHighlightColor { return _pctlIndicator.currentPageIndicatorTintColor; }
- (void)setIndicatorHighlightColor:(UIColor *)indicatorHighlightColor
{
    [_pctlIndicator setCurrentPageIndicatorTintColor:indicatorHighlightColor];
}

@dynamic placeholdImage;
- (UIImage *)placeholdImage { return _currentContent.placeholdImage; }
- (void)setPlaceholdImage:(UIImage *)placeholdImage
{
    [_currentContent setPlaceholdImage:placeholdImage];
    [_nextContent setPlaceholdImage:placeholdImage];
}

@dynamic descriptionHeight;
- (CGFloat)descriptionHeight { return _currentContent.descriptionHeight; }
- (void)setDescriptionHeight:(CGFloat)descriptionHeight
{
    [_currentContent setDescriptionHeight:descriptionHeight];
    [_nextContent setDescriptionHeight:descriptionHeight];
}

@dynamic descriptionBackground;
- (UIColor *)descriptionBackground { return _currentContent.descriptionBackground; }
- (void)setDescriptionBackground:(UIColor *)descriptionBackground
{
    [_currentContent setDescriptionBackground:descriptionBackground];
    [_nextContent setDescriptionBackground:descriptionBackground];
}

@dynamic descriptionFont;
- (UIFont *)descriptionFont { return _currentContent.descriptionLabel.textFont; }
- (void)setDescriptionFont:(UIFont *)descriptionFont
{
    [_currentContent.descriptionLabel setTextFont:descriptionFont];
    [_nextContent.descriptionLabel setTextFont:descriptionFont];
}

@dynamic descriptionTextColor;
- (UIColor *)descriptionTextColor { return _currentContent.descriptionLabel.textColor; }
- (void)setDescriptionTextColor:(UIColor *)descriptionTextColor
{
    [_currentContent.descriptionLabel setTextColor:descriptionTextColor];
    [_nextContent.descriptionLabel setTextColor:descriptionTextColor];
}

@dynamic descriptionTextAlign;
- (NSTextAlignment)descriptionTextAlign { return _currentContent.descriptionLabel.textAlignment; }
- (void)setDescriptionTextAlign:(NSTextAlignment)descriptionTextAlign
{
    [_currentContent.descriptionLabel setTextAlignment:descriptionTextAlign];
    [_nextContent.descriptionLabel setTextAlignment:descriptionTextAlign];
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
    _scrollView = [UIScrollView object];
    [self addSubview:_scrollView];
    _bAllowAutoPlay = YES;
    _fInterval = 3.f;
    _aIndicatorAlign = PYCarouselViewIndicatorAlignmentRight;
    
    _pctlIndicator = [[UIPageControl alloc] init];
    [_pctlIndicator setPageIndicatorTintColor:[UIColor grayColor]];
    [_pctlIndicator setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
    [self addSubview:_pctlIndicator];
    
    _nextContent = [PYCarouselContentView object];
    [_scrollView addSubview:_nextContent];
    
    _currentContent = [PYCarouselContentView object];
    [_scrollView addSubview:_currentContent];
    
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [_scrollView setBounces:NO];
    [_scrollView setPagingEnabled:YES];
    _scrollView.delegate = self;
    
    // Gesture
    _tapGesture = [[UITapGestureRecognizer alloc]
                   initWithTarget:self action:@selector(actionTapScrollView:)];
    [_scrollView addGestureRecognizer:_tapGesture];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_scrollView setFrame:self.bounds];
    
    CGFloat _w = self.bounds.size.width;
    CGFloat _h = self.bounds.size.height;
    
    [_scrollView setContentSize:CGSizeMake(_w * 3, _h)];
    [_scrollView setContentOffset:CGPointMake(_w, 0) animated:NO];
    _currentContent.frame = CGRectMake(_w, 0, _w, _h);
    _nextContent.frame = CGRectMake(_w * 2, 0, _w, _h);
    
    [_pctlIndicator sizeToFit];
    CGSize _ptSize = [_pctlIndicator sizeForNumberOfPages:_pctlIndicator.numberOfPages];
    CGFloat _dh = _currentContent.descriptionHeight;
    CGFloat _ih = (_h - _dh) + (_dh - _ptSize.height) / 2;
    if ( _aIndicatorAlign == PYCarouselViewIndicatorAlignmentLeft ) {
        [_pctlIndicator setFrame:CGRectMake(10, _ih, _ptSize.width, _ptSize.height)];
    } else if ( _aIndicatorAlign == PYCarouselViewIndicatorAlignmentCenter ) {
        [_pctlIndicator setFrame:CGRectMake(_w / 2 - _ptSize.width / 2, _ih, _ptSize.width, _ptSize.height)];
    } else {
        [_pctlIndicator setFrame:CGRectMake(_w - _ptSize.width - 10, _ih, _ptSize.width, _ptSize.height)];
    }
}

// Load Carousel View without description
- (void)loadCarouselViewWithImages:(NSArray *)imageUrls
{
    _images = [NSArray arrayWithArray:imageUrls];
    _descTexts = nil;
    [_currentContent setShowDescription:NO];
    [_nextContent setShowDescription:NO];
    _currentIndex = 0;
    _nextIndex = 0;
    
    [_currentContent setImageUrl:[_images objectAtIndex:0]];
    [_pctlIndicator setNumberOfPages:[_images count]];
    [_pctlIndicator setCurrentPage:0];
    
    [self setNeedsLayout];
    if ( _bAllowAutoPlay ) {
        [self beginAutoPlayTimer];
    }
}
// Load Carousel View with image and description
- (void)loadCarouselViewWithImages:(NSArray *)imageUrls descriptions:(NSArray *)descriptions
{
    _images = [NSArray arrayWithArray:imageUrls];
    _descTexts = [NSArray arrayWithArray:descriptions];
    [_currentContent setShowDescription:YES];
    [_nextContent setShowDescription:YES];
    _currentIndex = 0;
    _nextIndex = 0;
    
    [_currentContent setImageUrl:[_images objectAtIndex:0]];
    [_currentContent setDescriptionText:[_descTexts objectAtIndex:0]];
    [_pctlIndicator setNumberOfPages:[_images count]];
    [_pctlIndicator setCurrentPage:0];
    
    [self setNeedsLayout];
    if ( _bAllowAutoPlay ) {
        [self beginAutoPlayTimer];
    }
}

- (void)_updateCurrentPage
{
    CGFloat _w = _scrollView.frame.size.width;
    CGFloat _h = _scrollView.frame.size.height;
    
    if ( _w == _scrollView.contentOffset.x ) return;
    
    _currentIndex = _nextIndex;
    [_currentContent setImageUrl:[_images objectAtIndex:_currentIndex]];
    if ( [_currentContent showDescription] ) {
        [_currentContent setDescriptionText:[_descTexts objectAtIndex:_currentIndex]];
    }
    [_currentContent setFrame:CGRectMake(_w, 0, _w, _h)];
    [_scrollView setContentOffset:CGPointMake(_w, 0) animated:NO];
    [_pctlIndicator setCurrentPage:_currentIndex];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat _ox = scrollView.contentOffset.x;
    CGFloat _w = scrollView.frame.size.width;
    CGFloat _h = scrollView.frame.size.height;
    
    // In Middle
    if ( PYFLOATEQUAL(_ox, _w) ) return;
    if ( _ox > _w ) {
        _nextContent.frame = CGRectMake(_w * 2, 0, _w, _h);
        _nextIndex = _currentIndex + 1;
        if ( _nextIndex == _images.count ) _nextIndex = 0;
    }
    if ( _ox < _w ) {
        _nextContent.frame = CGRectMake(0, 0, _w, _h);
        _nextIndex = _currentIndex - 1;
        if ( _nextIndex < 0 ) _nextIndex = _images.count - 1;
    }
    
    [_nextContent setImageUrl:[_images objectAtIndex:_nextIndex]];
    if ( [_nextContent showDescription] ) {
        [_nextContent setDescriptionText:[_descTexts objectAtIndex:_nextIndex]];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self _updateCurrentPage];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self _updateCurrentPage];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self endAutoPlayTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ( _bAllowAutoPlay ) {
        [self beginAutoPlayTimer];
    }
}

- (void)actionTapScrollView:(id)sender
{
    if ( self.onClick ) self.onClick(_currentIndex);
}

- (void)nextPage
{
    CGFloat _w = _scrollView.frame.size.width;
    [_scrollView setContentOffset:CGPointMake(_w * 2, 0) animated:YES];
}

- (void)beginAutoPlayTimer
{
    PYSingletonLock
    if ( _tAutoPlayTimer != nil ) return;
    __weak typeof(self) _wself = self;
    _tAutoPlayTimer = [NSTimer timerWithTimeInterval:_fInterval repeats:YES block:^(NSTimer * _Nonnull timer) {
        [_wself nextPage];
    }];
    [[NSRunLoop mainRunLoop] addTimer:_tAutoPlayTimer forMode:NSRunLoopCommonModes];
    PYSingletonUnLock
}

- (void)endAutoPlayTimer
{
    PYSingletonLock
    if ( _tAutoPlayTimer == nil ) return;
    [_tAutoPlayTimer invalidate];
    _tAutoPlayTimer = nil;
    PYSingletonUnLock
}

@end

// @littlepush
// littlepush@gmail.com
// PYLab
