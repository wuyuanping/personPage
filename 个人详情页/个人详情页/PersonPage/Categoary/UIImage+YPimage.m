//
//  UIImage+YPimage.m
//  个人详情页
//
//  Created by 吴园平 on 06/10/2016.
//  Copyright © 2016 吴园平. All rights reserved.
//

#import "UIImage+YPimage.h"

@implementation UIImage (YPimage)

+ (UIImage *)imageWithColor:(UIColor *)color{

    //描述矩形
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    //开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    
    //获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //1.使用color颜色填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    //2.渲染上下文
    CGContextFillRect(context, rect);
    
    //从上下文中获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    //结束位图上下文
    UIGraphicsEndImageContext();
    
    return image;

}



@end
