//
//  JMSlideshowController.m
//  CoreLib
//
//  Created by CoreCode on 19.05.14
/*	Copyright (c) 2015 CoreCode
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "JMSlideshowController.h"


@interface JMSlideshowController ()

@property (unsafe_unretained, nonatomic) UIImageView *imageView;
@property (unsafe_unretained, nonatomic) UIPageControl *pageControl;
@property (assign, nonatomic) int currentImage;

@end



@implementation JMSlideshowController

- (void)viewDidLoad
{
	UIImageView *iv = [[UIImageView alloc] initWithFrame:self.view.frame];
	iv.contentMode = UIViewContentModeScaleAspectFit;
	self.imageView = iv;
	[self.view addSubview:self.imageView];


	UIPageControl *pc = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 30, self.view.frame.size.width, 30)];
	self.pageControl = pc;
	[self.view addSubview:self.pageControl];



	UISwipeGestureRecognizer *swipeleft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
	swipeleft.direction = UISwipeGestureRecognizerDirectionLeft;
	[self.view addGestureRecognizer:swipeleft];

	UISwipeGestureRecognizer *swiperight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
	swiperight.direction = UISwipeGestureRecognizerDirectionRight;
	[self.view addGestureRecognizer:swiperight];

#if ! __has_feature(objc_arc)
	[iv release];
	[swiperight release];
	[swipeleft release];
	[pc release];
#endif

    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
	self.title = self.navigationTitle;
	

	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
	self.imageView.frame = self.view.frame;
	self.pageControl.frame = CGRectMake(0, self.view.frame.size.height - 30, self.view.frame.size.width, 30);

	[self setup];


	[super viewDidAppear:animated];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	self.imageView.frame = self.view.frame;
	self.pageControl.frame = CGRectMake(0, self.view.frame.size.height - 30, self.view.frame.size.width, 30);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(void)swipeleft:(UISwipeGestureRecognizer *)gestureRecognizer
{
	self.currentImage = (int)MIN(self.currentImage+1, (int)self.images.count -1);
	[self setup];
}

-(void)swiperight:(UISwipeGestureRecognizer *)gestureRecognizer
{
	self.currentImage= MAX(self.currentImage-1,0);
	[self setup];
}

- (void)setup
{
	id im = self.images[self.currentImage];

	if ([im isKindOfClass:[UIImage class]])
		self.imageView.image = im;
	else if ([im isKindOfClass:[NSString class]])
	{
		if ([im hasPrefix:@"http"])
		{
			self.imageView.image = nil;
			UILabel *label = [[UILabel alloc] initWithFrame:self.view.frame];
			label.text = @"Loading…";
			label.textColor = [UIColor lightGrayColor];
			label.textAlignment = NSTextAlignmentCenter;
			[self.imageView addSubview:label];
			dispatch_async_back(^
			{
				NSData *data = ((NSString *)im).download;

				dispatch_async_main(^
				{
					[label removeFromSuperview];
					if (data)
#if ! __has_feature(objc_arc)
						self.imageView.image = [[[UIImage alloc] initWithData:data] autorelease];
#else
					self.imageView.image = [[UIImage alloc] initWithData:data];
#endif
				});
			});
		}
		else if ([im hasPrefix:@"/"])
#if ! __has_feature(objc_arc)
			self.imageView.image = [[[UIImage alloc] initWithContentsOfFile:im] autorelease];
#else
			self.imageView.image = [[UIImage alloc] initWithContentsOfFile:im];
#endif
		else
			self.imageView.image = [UIImage imageNamed:im];
	}
	else if ([im isKindOfClass:[NSURL class]])
	{
		NSURL *im2 =  im;

		if ([im2 isFileURL])
#if ! __has_feature(objc_arc)
			self.imageView.image = [[[UIImage alloc] initWithContentsOfFile:[im2 path]] autorelease];
#else
			self.imageView.image = [[UIImage alloc] initWithContentsOfFile:[im2 path]];
#endif
		else
		{
			self.imageView.image = nil;
			UILabel *label = [[UILabel alloc] initWithFrame:self.view.frame];
			label.text = @"Loading…";
			label.textColor = [UIColor lightGrayColor];
			label.textAlignment = NSTextAlignmentCenter;
			[self.imageView addSubview:label];

			dispatch_async_back(^
			{
				NSData *data = ((NSString *)im).download;

				dispatch_async_main(^
				{
					[label removeFromSuperview];
					if (data)
#if ! __has_feature(objc_arc)
						self.imageView.image = [[[UIImage alloc] initWithData:data] autorelease];
#else
					self.imageView.image = [[UIImage alloc] initWithData:data];
#endif
				});
			});

		}
	}

	self.pageControl.numberOfPages = self.images.count;
	self.pageControl.currentPage = self.currentImage;
}
@end