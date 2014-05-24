//
//  SLShareViewController.m
//  soulight
//
//  Created by Ming Z. on 14-5-20.
//  Copyright (c) 2014年 i0xbean. All rights reserved.
//

#import "SLShareViewController.h"
#import "SLShareCell.h"
#import "SLShareReusableView.h"


@interface SLShareViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic)   UICollectionView *          collectionView;

@end

@implementation SLShareViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _collectionView = ({
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.headerReferenceSize = CGSizeMake(100, 20);
        layout.itemSize = CGSizeMake(50, 50);

        UICollectionView *v =
            [[UICollectionView alloc] initWithFrame:CGRectMake(144, 20, self.view.width-144-16, self.view.height-20-16)
                               collectionViewLayout:layout];
        v.backgroundColor = [UIColor clearColor];
        v.clipsToBounds = NO;
        [v registerClass:[SLShareCell class] forCellWithReuseIdentifier:kCellIdShare];
        [v registerClass:[SLShareReusableView class]
forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
     withReuseIdentifier:kCellIdShareReusable];
        v.dataSource = self;
        v.delegate = self;
        v;
    });
    
    [self.view addSubview:_collectionView];
    
    
    UIButton *editBtn = ({
        UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(34, 504, 48, 48)];
        [b setImage:[UIImage imageNamed:@"eye"] forState:UIControlStateNormal];
        b.showsTouchWhenHighlighted = YES;
        b.layer.cornerRadius = 48/2;
        b.layer.borderWidth = 1;
        b;
    });
    
    
    [self.view addSubview:editBtn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    [_collectionView debugBackgroundColor];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SLShareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdShare forIndexPath:indexPath];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    SLShareReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCellIdShareReusable forIndexPath:indexPath];
    return view;
}

#pragma mark - UICollectionViewDelegate



@end
