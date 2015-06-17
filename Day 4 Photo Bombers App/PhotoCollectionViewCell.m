 //
//  PhotoCollectionViewCell.m
//  Day 4 Photo Bombers App
//
//  Created by Student on 6/17/15.
//  Copyright (c) 2015 Arkalyk. All rights reserved.
//

#import "PhotoCollectionViewCell.h"
#import "PhotoController.h"

@implementation PhotoCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self){
        self.imageView = [UIImageView new];
        [self.contentView addSubview:self.imageView];
    }
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = self.contentView.bounds;
}

-(void)setPhoto:(NSDictionary *)photo
{
    _photo = photo;
    
    [PhotoController imageForPhoto:self.photo size:@"thumbnail" completion:^(UIImage *image) {
        self.imageView.image = image;
    }];
    
}



@end
