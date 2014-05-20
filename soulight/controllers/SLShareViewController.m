//
//  SLShareViewController.m
//  soulight
//
//  Created by Ming Z. on 14-5-20.
//  Copyright (c) 2014年 i0xbean. All rights reserved.
//

#import "SLShareViewController.h"
#import "SLShareCell.h"

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
        UICollectionView *v = [[UICollectionView alloc] initWithFrame:CGRectMake(144, 20, self.view.width-144-16, self.view.height-20-16)
                                                 collectionViewLayout:layout];
        [v registerClass:[SLShareCell class] forCellWithReuseIdentifier:kCellIdShare];
        v.backgroundColor = [UIColor redColor];
        v;
    });
    
    [self.view addSubview:_collectionView];
    
    
    UIButton *editBtn = ({
        UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(34, 504, 48, 48)];
        [b setImage:[UIImage imageNamed:@"visible"] forState:UIControlStateNormal];
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

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SLShareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdShare forIndexPath:indexPath];
    
    return cell;
}


@end
