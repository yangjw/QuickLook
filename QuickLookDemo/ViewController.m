//
//  ViewController.m
//  QuickLookDemo
//
//  Created by yangjw  on 13-8-12.
//  Copyright (c) 2013年 yangjw . All rights reserved.
//

#import "ViewController.h"
#import "QuickLookVC.h"

@interface ViewController ()
{
	IBOutlet UITableView *readTable;
}

@property(nonatomic,assign)NSMutableArray *dirArray;
@property (nonatomic, strong) UIDocumentInteractionController *docInteractionController;
@end

@implementation ViewController


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

- (void)viewDidLoad
{
    [super viewDidLoad];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	//在这里获取应用程序Documents文件夹里的文件及文件夹列表
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDir = [documentPaths objectAtIndex:0];
	NSError *error = nil;
	NSArray *fileList = [[NSArray alloc] init];
	//fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
	fileList = [fileManager contentsOfDirectoryAtPath:documentDir error:&error];
	
	//    以下这段代码则可以列出给定一个文件夹里的所有子文件夹名
	//	NSLog(@"------------------------%@",fileList);
	self.dirArray = [[NSMutableArray alloc] init];
	for (NSString *file in fileList)
	{
		[self.dirArray addObject:file];
	}
	//	NSLog(@"Every Thing in the dir:%@",fileList);
	//	NSLog(@"All folders:%@",dirArray);
	
	
	
	[readTable reloadData];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)longPressGesture
{
    if (longPressGesture.state == UIGestureRecognizerStateBegan)
    {
        NSIndexPath *cellIndexPath = [readTable indexPathForRowAtPoint:[longPressGesture locationInView:readTable]];
		
		NSURL *fileURL;
		if (cellIndexPath.section == 0)
        {
            // for section 0, we preview the docs built into our app
            fileURL = [self.dirArray objectAtIndex:cellIndexPath.row];
		}
        else
        {
            // for secton 1, we preview the docs found in the Documents folder
            fileURL = [self.dirArray objectAtIndex:cellIndexPath.row];
		}
        self.docInteractionController.URL = fileURL;
		
		[self.docInteractionController presentOptionsMenuFromRect:longPressGesture.view.frame
                                                           inView:longPressGesture.view
                                                         animated:YES];
    }
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellName = @"CellName";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellName];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellName];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	NSURL *fileURL= nil;
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDir = [documentPaths objectAtIndex:0];
	NSString *path = [documentDir stringByAppendingPathComponent:[self.dirArray objectAtIndex:indexPath.row]];
	fileURL = [NSURL fileURLWithPath:path];
	
	[self setupDocumentControllerWithURL:fileURL];
	cell.textLabel.text = [self.dirArray objectAtIndex:indexPath.row];
	NSInteger iconCount = [self.docInteractionController.icons count];
    if (iconCount > 0)
    {
        cell.imageView.image = [self.docInteractionController.icons objectAtIndex:iconCount - 1];
    }
    
    NSString *fileURLString = [self.docInteractionController.URL path];
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:fileURLString error:nil];
    NSInteger fileSize = [[fileAttributes objectForKey:NSFileSize] intValue];
    NSString *fileSizeStr = [NSByteCountFormatter stringFromByteCount:fileSize
                                                           countStyle:NSByteCountFormatterCountStyleFile];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", fileSizeStr, self.docInteractionController.UTI];
	UILongPressGestureRecognizer *longPressGesture =
	[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [cell.imageView addGestureRecognizer:longPressGesture];
    cell.imageView.userInteractionEnabled = YES;    // this is by default NO, so we need to turn it on

	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 58;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.dirArray count];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
//	QLPreviewController *previewController = [[QLPreviewController alloc] init];
//    previewController.dataSource = self;
//    previewController.delegate = self;
	
//	UINavigationController	*navigationController = [[[UINavigationController alloc]initWithRootViewController:previewController] autorelease];
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(closeQuickLookAction:)];
//    navigationController.navigationItem.leftBarButtonItem = backButton;
	
    // start previewing the document at the current section index
//    previewController.currentPreviewItemIndex = indexPath.row;
	
//	[self.view addSubview:previewController.view];
	
//    [[self navigationController] pushViewController:previewController animated:YES];
//	[self presentViewController:previewController animated:YES completion:nil];
	
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDir = [documentPaths objectAtIndex:0];
	NSString *path = [documentDir stringByAppendingPathComponent:[self.dirArray objectAtIndex:indexPath.row]];
	QuickLookVC *qu = [[QuickLookVC alloc] initWithNibName:@"QuickLookVC" bundle:nil];
	qu.path = path;
	self.navigationController.navigationBarHidden = YES;
	[self.navigationController pushViewController:qu animated:YES];
}





#pragma mark - UIDocumentInteractionControllerDelegate

- (NSString *)applicationDocumentsDirectory
{
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)interactionController
{
    return self;
}


#pragma mark - QLPreviewControllerDataSource

// Returns the number of items that the preview controller should preview
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)previewController
{
//    NSInteger numToPreview = 0;
//    
//	numToPreview = [self.dirArray count];
//    
//    return numToPreview;
	return 1;
}

- (void)previewControllerDidDismiss:(QLPreviewController *)controller
{
    // if the preview dismissed (done button touched), use this method to post-process previews
}

// returns the item that the preview controller should preview
- (id)previewController:(QLPreviewController *)previewController previewItemAtIndex:(NSInteger)idx
{
	[previewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"click.png"] forBarMetrics:UIBarMetricsDefault];
//	previewController.navigationItem.hidesBackButton  = YES;
	previewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(callModalList)];
	//
//	UIBarButtonItem *callModalViewButton = [[UIBarButtonItem alloc]
//											initWithTitle:@"经文"
//											style:UIBarButtonItemStyleBordered
//											target:self
//											action:@selector(callModalList)];
//	previewController.navigationController.navigationItem.leftBarButtonItem = callModalViewButton;
//	[callModalViewButton release]; //由于本地视图会retain它，所以我们可以release了
	
    NSURL *fileURL = nil;
    NSIndexPath *selectedIndexPath = [readTable indexPathForSelectedRow];
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDir = [documentPaths objectAtIndex:0];
	NSString *path = [documentDir stringByAppendingPathComponent:[self.dirArray objectAtIndex:selectedIndexPath.row]];
	fileURL = [NSURL fileURLWithPath:path];
    return fileURL;
}

- (void)callModalList
{
	NSLog(@"---------------");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
	
}

- (void)dealloc
{
	[readTable release];
	[super dealloc];
}
- (void)viewDidUnload
{
	[readTable release];
	readTable = nil;
	[super viewDidUnload];
}
@end
