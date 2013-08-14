//
//  QuickLookVC.m
//  QuickLookDemo
//
//  Created by yangjw  on 13-8-14.
//  Copyright (c) 2013年 yangjw . All rights reserved.
//

#import "QuickLookVC.h"

#import <QuickLook/QuickLook.h>

@interface QuickLookVC ()<UIDocumentInteractionControllerDelegate,QLPreviewControllerDataSource,QLPreviewControllerDelegate>
{
	QLPreviewController *previewController;
}
- (IBAction)back:(id)sender;
@property (nonatomic, strong) UIDocumentInteractionController *docInteractionController;
@end

@implementation QuickLookVC
@synthesize path = _path;

- (void)setupDocumentControllerWithURL:(NSURL *)url
{
    if (self.docInteractionController == nil)
    {
        self.docInteractionController = [UIDocumentInteractionController interactionControllerWithURL:url];
        self.docInteractionController.delegate = self;
    }
    else
    {
        self.docInteractionController.URL = url;
    }
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    }
    return self;
}

#pragma mark - QLPreviewControllerDataSource

// Returns the number of items that the preview controller should preview
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)previewController
{

	return 1;
}

- (void)previewControllerDidDismiss:(QLPreviewController *)controller
{
    // if the preview dismissed (done button touched), use this method to post-process previews
}

// returns the item that the preview controller should preview
- (id)previewController:(QLPreviewController *)previewController previewItemAtIndex:(NSInteger)idx
{
	NSURL *fileURL = nil;
	fileURL = [NSURL fileURLWithPath:self.path];
    return fileURL;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	previewController = [[QLPreviewController alloc] init];
    previewController.dataSource = self;
    previewController.delegate = self;
	previewController.view.frame = CGRectMake(0,48, 320, 500);
	[self.view addSubview:previewController.view];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (action == @selector(cut:)){
        return NO;
    }
    else if(action == @selector(copy:)){
        return YES;
    }
    else if(action == @selector(paste:)){
        return NO;
    }
    else if(action == @selector(select:)){
        return NO;
    }
    else if(action == @selector(selectAll:)){
        return NO;
    }
    else
    {
        return [super canPerformAction:action withSender:sender];
    }
	return NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}
@end
