//
//  TrashCanView.m
//  iNeDot_sample_01
//
//  Created by TSUNG-LUN LIAO on 2015/5/22.
//  Copyright (c) 2015年 GIGABYTE. All rights reserved.
//

#import "TrashCanView.h"
#import "GLBucket.h"

@interface TrashCanView ()

{
    BOOL trashCanOpend;
}

@property (nonatomic, strong) GLBucket *trashCan;

@end

@implementation TrashCanView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    self.backgroundColor = [UIColor clearColor];
    
    self.trashCan = [[GLBucket alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.bounds) - 20) / 2, CGRectGetHeight(self.bounds) - 105, 30, 30) inLayer:self.layer];
    
    self.trashCan.bucketStyle = BucketStyle2OpenFromRight;
    
    trashCanOpend = NO;
    
    return self;
}

- (void)openTrashCan:(BOOL)open{
    
    if (open && !trashCanOpend) {
        
        [self.trashCan openBucket];
        
        trashCanOpend = YES;
        
    }else if(!open && trashCanOpend){
        
        [self.trashCan closeBucket];
        
        trashCanOpend = NO;
    }
    
}

@end
