//
//  ViewController.m
//  BaiduMap
//
//  Created by 尹文涛 on 16/3/29.
//  Copyright © 2016年 小木科技. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate>
{
    BMKMapView* _mapView ;
    BMKLocationService *_locService;// 定位
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-49-64)];
    _mapView.delegate = self;
    //切换为普通地图
    [_mapView setMapType:BMKMapTypeStandard];
    _mapView.showMapScaleBar = YES;
    
    [self.view addSubview:_mapView];
    
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    
    
    // 添加一个PointAnnotation
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = 39.915;
    coor.longitude = 116.404;
    annotation.coordinate = coor;
    annotation.title = @"这里是北京";
    [_mapView addAnnotation:annotation];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

#pragma -mark 地图定位
//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    //普通态
    //以下_mapView为BMKMapView对象
    _mapView.showsUserLocation = YES;//显示定位图层
    [_mapView updateLocationData:userLocation];
}


// Override
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
//    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
    
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"test"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        newAnnotationView.tag = 100;
        
        // 自定义泡泡
        UIView *customeview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 80)];
        customeview.backgroundColor = [UIColor redColor];
        UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
        button1.backgroundColor = [UIColor blueColor];
        [customeview addSubview:button1];
        [button1 addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        
        newAnnotationView.paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:customeview];
        
        return newAnnotationView;
//    }
    
//    return nil;
}

- (void)buttonClick{
    NSLog(@"点击了泡泡的按钮");
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    NSLog(@"点击了");
}
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view{
    NSLog(@"点击了气泡%d",view.tag);
}


@end
