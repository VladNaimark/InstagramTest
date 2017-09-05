//
//  MediaGridVC.m
//  MediaData
//
//  Created by Vlad Naimark on 9/1/17.
//  Copyright © 2017 Vlad Naimark. All rights reserved.
//

#import "MediaGridVC.h"
#import "InstaAPI.h"
#import "MediaListCell.h"
#import "MediaVC.h"
#import "MediaList.h"
#import "Media.h"

static const int MEDIA_PER_REQUEST = 7;
static const int DEFAULT_CELL_SIZE = 150;
static const int MIN_CELLS_PER_ROW = 3;

@interface MediaGridVC () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextField *userNameField;

@property (nonatomic, strong) MediaList *mediaList;
@property (nonatomic, assign) BOOL requestingData;
@property (nonatomic, assign) BOOL hasSetInitialCellSize;

@end

@implementation MediaGridVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self requestData];
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:LOCALIZE(@"Logout button title", @"Login")
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(logout:)];
    self.navigationItem.leftBarButtonItem=newBackButton;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (!self.hasSetInitialCellSize)
    {
        [self updateCellSizeForWidth:self.collectionView.frame.size.width];
        self.hasSetInitialCellSize = YES;
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [self updateCellSizeForWidth:size.width];
}

- (void)logout:(id)sender
{
    [[InstaAPI sharedInstance] logout];
    [self performSegueWithIdentifier:@"toLoginSegue" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toMedia"])
    {
        ((MediaVC*)segue.destinationViewController).media = self.mediaList.media[self.collectionView.indexPathsForSelectedItems.firstObject.item];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.mediaList.media.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MediaListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MediaListCell class]) forIndexPath:indexPath];
    cell.media = self.mediaList.media[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"toMedia" sender:self];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.requestingData || !self.mediaList.nextPageUrl.length)
    {
        return;
    }
    
    if (indexPath.item > self.mediaList.media.count - MEDIA_PER_REQUEST / 2)
    {
        [self requestData];
    }
}

#pragma mark - private

- (void)requestData
{
    __weak typeof(self) wSelf = self;
    self.requestingData = YES;
    [[InstaAPI sharedInstance] getMedia:self.mediaList count:MEDIA_PER_REQUEST completion:^(MediaList *mediaList, NSError *error)
    {
        typeof(self) self = wSelf;
        self.requestingData = NO;
        if (error)
        {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:LOCALIZE(@"Error", @"General")
                                                                           message:error.localizedDescription
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:LOCALIZE(@"OK", @"General")
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        
        if (mediaList)
        {
            self.mediaList = mediaList;
            [self.collectionView reloadData];
        }
    }];
}

- (void)updateCellSizeForWidth:(CGFloat)width
{
    CGFloat cellWidth;
    if (width / DEFAULT_CELL_SIZE > MIN_CELLS_PER_ROW)
    {
        cellWidth = DEFAULT_CELL_SIZE + ((int)width % DEFAULT_CELL_SIZE) / ceil(width / DEFAULT_CELL_SIZE);
    }
    else
    {
        cellWidth = floor(width / MIN_CELLS_PER_ROW);
    }
    UICollectionViewFlowLayout* layout = ((UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout);
    layout.itemSize = CGSizeMake(cellWidth, cellWidth);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
}

@end
