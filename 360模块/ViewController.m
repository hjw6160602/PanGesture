//
//  ViewController.m
//  360模块
//
//  Created by evan on 15/5/11.
//  Copyright (c) 2015年 SaiDiCaprio. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

#pragma mark -  ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
}

#pragma mark -  初始化数据
- (void)initData{
    imageTypes = [NSArray arrayWithObjects:@"qianzi",@"jiazi01",@"jiazi02", nil];
    TypeIndex = 0;
    NSString *typeName = [imageTypes objectAtIndex:TypeIndex];
    
    //初始化背景图片为第一张
    _ImageView.image = [self RenderImageWithName:typeName Index:1];
    //初始化图片字典
    [self ResetCurrentImageWithName:@"qianzi" Index:1];
    //是否在播放动画设置为NO
    isAnimating = NO;
    //拖动手势
    UIPanGestureRecognizer *panGesture=[[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(handlePan:)];
    //点击手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                action:@selector(handleTap:)];
    //添加手势
    [self.view addGestureRecognizer:panGesture];
    //[self.view addGestureRecognizer:tapGesture];
}

#pragma mark - 手势响应控制
- (void)handlePan:(UIGestureRecognizer*)gestureRecognizer{
    CGPoint currentPosition = [gestureRecognizer locationInView:self.view];
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan){
        startTouch = currentPosition;
        isMoving = YES;
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged){
        //手势在四个方向上改变大小的取值
        int width1 = currentPosition.x - startTouch.x;
        int height1 = currentPosition.y - startTouch.y;
        int width2 = -width1;
        int height2 = -height1;
        //根据手势变化对图片状态做出不同的改变
        if (width1 >0)  [self ChangeImageStatus:0 LeftOrRight:1];
        else if (width2 > 0) [self ChangeImageStatus:0 LeftOrRight:-1];
        
        if (height1>50)  [self ChangeImageStatus:1 LeftOrRight:0];
        else if (height2>50) [self ChangeImageStatus:-1 LeftOrRight:0];
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded){
        isMoving = NO;
    }
}

#pragma mark 单击手势响应
- (void)handleTap:(UIGestureRecognizer*)gestureRecognizer{
    //如果并不是正在播放
    if(!isAnimating){
        [self runAnimationWithCount:108 Name:@"qianzi"];
    }
    //如果动画正在播放
    else{
        //insert the code ......
    }
}

#pragma mark 跑图片动画
- (void)runAnimationWithCount:(int)count Name:(NSString *)name{
    NSMutableArray *images = [NSMutableArray array];
    
    //将需要播放的序列帧图片加载进入images数组
    for (int i=2;i<=count;i++)
        [images addObject:[self RenderImageWithName:name Index:i]];
    
    _ImageView.animationImages = images;
    _ImageView.animationDuration = images.count * 0.04;
    _ImageView.animationRepeatCount = 0;
    [_ImageView startAnimating];
}

#pragma mark 渲染图片
- (UIImage *)RenderImageWithName:(NSString *)name Index:(int)index{
    NSString *fileName = [NSString stringWithFormat:@"%@_%03d.png",name,index];
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:fileName ofType:nil];
    UIImage *Image = [UIImage imageWithContentsOfFile:path];
    //[self ResetCurrentImageWithName:name Index:index];
    return Image;
}

#pragma mark 重置当前图片状态
- (void)ResetCurrentImageWithName:(NSString *)name Index:(int)index{
    currentImageType = name;
    currentIndex = [NSString stringWithFormat:@"%d",index];
    imageNameWithIndex =  [NSDictionary dictionaryWithObjectsAndKeys:currentImageType,@"currentImageType",currentIndex,@"currentIndex",nil];
}
#pragma mark 手势变化对图片状态做出的改变
- (void)ChangeImageStatus:(int)Slider LeftOrRight:(int)leftOrRight{
    NSString *name = [imageNameWithIndex valueForKey:@"currentImageType"];
    int index = [[imageNameWithIndex valueForKey:@"currentIndex"]intValue]+leftOrRight;
    if (index >108) index = 1;
    else if (index <1 ) index = 108;
    //根据当前的文件类型名称 对下一次变化的文件名进行向后推移
    
    if (Slider == 1) {
        if ([name  isEqual: @"qianzi"]) TypeIndex = 1;
        else if ([name  isEqual: @"jiazi01"]) TypeIndex = 2;
        else if ([name  isEqual: @"jiazi02"]) TypeIndex = 0;
    }
    else if(Slider == -1){
        if ([name  isEqual: @"qianzi"]) TypeIndex = 2;
        else if ([name  isEqual: @"jiazi01"]) TypeIndex = 0;
        else if ([name  isEqual: @"jiazi02"]) TypeIndex = 1;
    }
    
    NSString *newType = [imageTypes objectAtIndex:TypeIndex];
    _ImageView.image = [self RenderImageWithName:newType Index:index];
    [self ResetCurrentImageWithName:newType Index:index];
}


@end
