//
//  TutorialViewController.m
//  Brush
//
//  Created by Jeff Merola on 10/20/12.
//  Copyright (c) 2012 SDD_Team. All rights reserved.
//

// Controller for the tutorial page.

#import "TutorialViewController.h"

@interface TutorialViewController ()
// Private properties and methods:
@property (nonatomic, strong) NSArray *pageImages;
@property (nonatomic, strong) NSMutableArray *pageViews;

- (void)loadVisiblePages;
- (void)loadPage:(NSInteger)page;
- (void)purgePage:(NSInteger)page;
@end

@implementation TutorialViewController

@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;

@synthesize pageImages = _pageImages;
@synthesize pageViews = _pageViews;

- (void)test
{
    NSString *data = @"alphy";
    NSString *loc = [data substringWithRange:NSMakeRange(1, 1)];
    NSLog(@"%@",loc);
}

// Pops the newest View Controller (TutorialViewController) from the Navigation Stack
- (IBAction)returnToMainMenu:(UIButton *)sender
{
    [self test];
    [self.navigationController popViewControllerAnimated:YES];
}

// Loads the tutorial pages that are visible
- (void)loadVisiblePages
{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    
    self.pageControl.currentPage = page;
    
    NSInteger firstPage = page - 1;
    NSInteger lastPage = page + 1;
    
    
    for (NSInteger i = 0; i < firstPage; i++) {
        [self purgePage:i];
    }
    
    for (NSInteger i = firstPage; i <= lastPage; i++) {
        [self loadPage:i];
    }
    
    for (NSInteger i = lastPage + 1; i < self.pageImages.count; i++) {
        [self purgePage:i];
    }
}

// Loads an individual page
- (void)loadPage:(NSInteger)page
{
    if (page < 0 || page >= self.pageImages.count) {
        NSLog(@"trying to load non-existant page #%u", page);
        return;
    }
    
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull *)pageView == [NSNull null]) {
        CGRect frame = self.scrollView.bounds;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.0f;
        
        UIImageView *newPageView = [[UIImageView alloc] initWithImage:[self.pageImages objectAtIndex:page]];
        newPageView.contentMode = UIViewContentModeScaleAspectFit;
        newPageView.frame = frame;
        [self.scrollView addSubview:newPageView];
        
        [self.pageViews replaceObjectAtIndex:page withObject:newPageView];
    }
}

// Removes an individual page from memory
- (void)purgePage:(NSInteger)page
{
    if (page < 0 || page >= self.pageImages.count) {
        NSLog(@"trying to purge non-existant page #%u", page);
        return;
    }
    
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull *)pageView != [NSNull null]) {
        [pageView removeFromSuperview];
        [self.pageViews replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}

// When the tutorials screen is loaded, pull in the images
//  for the UIScrollView to display and set initial properties
- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.pageImages = [NSArray arrayWithObjects:
                       [UIImage imageNamed:@"tutorial1.png"],
                       [UIImage imageNamed:@"tutorial2.png"],
                       [UIImage imageNamed:@"tutorial3.png"],
                       [UIImage imageNamed:@"tutorial4.png"],
                       [UIImage imageNamed:@"tutorial5.png"],
                       [UIImage imageNamed:@"Sprite.png"],
                       nil];
    
    NSInteger pageCount = self.pageImages.count;
    
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = pageCount;
    
    self.pageViews = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < pageCount; ++i) {
        [self.pageViews addObject:[NSNull null]];
    }
}

// When the view is about to appear, set the UIScrollView's
//  contentSize property.  Cannot be done in ViewDidLoad
//   because the view's outlets are not connected in that
//    method.
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGSize pagesScrollViewSize = self.scrollView.frame.size;
    self.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * self.pageImages.count, pagesScrollViewSize.height);
    
    [self loadVisiblePages];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.scrollView = nil;
    self.pageControl = nil;
    self.pageImages = nil;
    self.pageViews = nil;
}

// When the user scrolls the view, new pages need to be loaded.
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self loadVisiblePages];
}
@end
