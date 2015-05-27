//
//  ViewController.m
//  TrashCanTest
//
//  Created by TSUNG-LUN LIAO on 2015/5/27.
//  Copyright (c) 2015年 TSUNG-LUN LIAO. All rights reserved.
//

#import "ViewController.h"

#import "TrashCanView.h"

#import "Cell.h"
#import "UICollectionView+Draggable.h"
#import "DraggableCollectionViewFlowLayout.h"

#import "JLMusicPlayer.h"

@interface ViewController ()<UICollectionViewDataSource_Draggable,UICollectionViewDelegate>

{
    NSMutableArray  *sections;
    TrashCanView    *trashCanView;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    sections = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 7; i ++) {
        [sections addObject:[NSString stringWithFormat:@"iPhone %d",i+1]];
    }
    
    self.collectionView.draggable   = YES;

    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self addTrashcanView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Set SubView

//TrashCanView
- (void)addTrashcanView{
    
    trashCanView = [[TrashCanView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.width/3)];
    
    [self.view addSubview:trashCanView];
    
}

- (void)trashCanViewAnimationShow:(BOOL)show{
    
    if (show) {
        [UIView animateWithDuration:0.3 animations:^{
            //
            trashCanView.frame = CGRectMake(0, self.view.frame.size.height-trashCanView.frame.size.height, trashCanView.frame.size.width, trashCanView.frame.size.height);
            
        } completion:^(BOOL finished) {
            //
        }];
        
    }else{
        
        [UIView animateWithDuration:0.3 animations:^{
            //
            trashCanView.frame = CGRectMake(0, self.view.frame.size.height, trashCanView.frame.size.width, trashCanView.frame.size.height);
            
        } completion:^(BOOL finished) {
            //
        }];
    }
}



#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Adjust cell size for orientation
    
    return CGSizeMake(self.view.frame.size.width*0.3, self.view.frame.size.width*0.3+21);
}

#pragma mark - UICollectionViewDataSource_Draggable

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return sections.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.theView.layer.cornerRadius = 15;
    cell.theLabel.text = sections[indexPath.row];
    
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (BOOL)collectionView:(UICollectionView *)collectionView moveItemAtPosition:(CGPoint)point{
    
    NSLog(@"collectView Move to Buttom : \n X = %f Y = %f",point.x ,point.y);
    
    //If get to buttom , Open trash can
    //Return if Item Move To TrashCan Or not
    double cell_width = self.view.frame.size.width/3;
    
    static BOOL isOpen = NO;
    
    BOOL  canMoveToTrash = NO;
    
    if (point.x > cell_width && point.x < cell_width*2 &&
        point.y > self.view.frame.size.height - cell_width) {
        
        NSLog(@"Trash Can Open");
        
        canMoveToTrash = YES;
        
        [trashCanView openTrashCan:YES];
        
        if (!isOpen) {
            
            [JLMusicPlayer playVibrate];
            isOpen = YES;

        }
        
    }else{
        
        NSLog(@"Trash Can Close");
        
        canMoveToTrash = NO;
        
        [trashCanView openTrashCan:NO];
        isOpen = NO;
        
    }
    
    return canMoveToTrash;
}


- (BOOL)collectionView:(LSCollectionViewHelper *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
        //Check is the Item can Move Or Not
        //...
    
    
        //Show trash can View
        //...
        [self trashCanViewAnimationShow:YES];
    
        return YES;
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    
    //Check is the Item can Move to New Position Or Not
    //...
    
    return YES;
}


- (void)collectionView:(LSCollectionViewHelper *)collectionView moveItemAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    
    NSMutableArray *data1 = sections;
    NSMutableArray *data2 = sections;
    
    id index = [data1 objectAtIndex:fromIndexPath.row];
    
    [data1 removeObjectAtIndex:fromIndexPath.item];
    [data2 insertObject:index atIndex:toIndexPath.item];
    
    NSLog(@"Position change");
    
    [self trashCanViewAnimationShow:NO];


}


- (void)collectionView:(UICollectionView *)collectionView didMoveItemToTrashAtIndexPath:(NSIndexPath *)indexPath{
    
    //Handle Item that moved to trashCan
    
    UIAlertController *alertController =
    [UIAlertController alertControllerWithTitle:@"Alert" message:@"Sure To Delete ?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction =
    [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        //more to do
        
        [sections removeObjectAtIndex:indexPath.row];
        
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
        [self.collectionView reloadData];

        
    }];
    UIAlertAction *doneAction =
    [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //more to do
        
        
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:doneAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
    [trashCanView openTrashCan:NO];
    
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSLog(@"Selector row %ld \n %@",(long)indexPath.row,sections[indexPath.row]);
    
    
}


@end
