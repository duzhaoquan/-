//
//  KCAnnotation.h
//  生日快乐
//
//  Created by jp123 on 2016/11/21.
//  Copyright © 2016年 jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface KCAnnotation : NSObject<MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
#pragma mark 自定义一个图片属性在创建大头针视图时使用
@property (nonatomic,strong) UIImage *image;
@end
