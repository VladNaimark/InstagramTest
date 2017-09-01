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

static const int MEDIA_PER_REQUEST = 7;

@interface MediaGridVC () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextField *userNameField;

@property (nonatomic, strong) MediaList *mediaList;
@property (nonatomic, assign) BOOL requestingData;

@end

@implementation MediaGridVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self requestData];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat minSize = MIN(screenSize.width, screenSize.height);
    float itemsPerRow = ceil(minSize / 150.0);
    UICollectionViewFlowLayout* layout = ((UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout);
    layout.itemSize = CGSizeMake(ceil(minSize / itemsPerRow), ceil(minSize / itemsPerRow));
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"🚪 Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout:)];
    self.navigationItem.leftBarButtonItem=newBackButton;
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
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                           message:error.localizedDescription
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
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

@end
