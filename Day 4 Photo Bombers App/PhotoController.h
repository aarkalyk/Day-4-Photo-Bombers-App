//
//  PhotoController.h
//  Day 4 Photo Bombers App
//
//  Created by Student on 6/17/15.
//  Copyright (c) 2015 Arkalyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PhotoController : NSObject

+(void) imageForPhoto : (NSDictionary *) photo size : (NSString *) size completion: (void(^)(UIImage *image)) completion;

@end
