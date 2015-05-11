//
//  ViewController.h
//  360模块
//
//  Created by evan on 15/5/11.
//  Copyright (c) 2015年 SaiDiCaprio. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewController : UIViewController{
    CGPoint startTouch;
    NSDictionary *imageNameWithIndex;
    NSArray *imageTypes;
    NSString *currentImageType, *currentIndex;
    int TypeIndex;
    BOOL isAnimating,isMoving;
}

@property (weak, nonatomic) IBOutlet UIImageView *ImageView;

@end

