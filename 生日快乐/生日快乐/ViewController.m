//
//  ViewController.m
//  生日快乐
//
//  Created by jp123 on 2016/11/9.
//  Copyright © 2016年 jp. All rights reserved.
//

#import "ViewController.h"
#import "YanhuaViewController.h"
#import "JPUSHService.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define AppKey @"867eef8612223dd6a0d5fbf0"
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#import "NotifacationViewController.h"
#import "AppCache.h"
#import "KCMainViewControlle.h"

@interface ViewController ()<CLLocationManagerDelegate>{
    UILabel *_locationLabel;
    
}

@end

@implementation ViewController


- (IBAction)buttonAction:(id)sender {
    
    YanhuaViewController *yanhuaViewController = [[YanhuaViewController alloc]init];
    [self presentViewController:yanhuaViewController animated:YES completion:nil];
    
    
}
- (IBAction)locationButtonAction:(id)sender {
    _locationLabel.hidden = !_locationLabel.hidden;
}
- (IBAction)pushButtonAction:(id)sender {
    
    _messageContentView.hidden = !_messageContentView.hidden ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[AppCache saveUserInfoWithdic:@{@"name":@"furong"}];
    
    [self setlocation];
    _messageCount = 0;
    _notificationCount = 0;
    _messageContents = [[NSMutableArray alloc] initWithCapacity:6];
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidSetup:)
                          name:kJPFNetworkDidSetupNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidClose:)
                          name:kJPFNetworkDidCloseNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidRegister:)
                          name:kJPFNetworkDidRegisterNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidLogin:)
                          name:kJPFNetworkDidLoginNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidReceiveMessage:)
                          name:kJPFNetworkDidReceiveMessageNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(serviceError:)
                          name:kJPFServiceErrorNotification
                        object:nil];

    [defaultCenter addObserver:self selector:@selector(notificationAction:) name:@"myNotificaton" object:nil];
    
    _UDIDValueLabel.textColor = [UIColor colorWithRed:0.0 / 255
                                                green:122.0 / 255
                                                 blue:255.0 / 255
                                                alpha:1];
    _registrationValueLabel.text = [JPUSHService registrationID];
    _registrationValueLabel.textColor = [UIColor colorWithRed:0.0 / 255
                                                        green:122.0 / 255
                                                         blue:255.0 / 255
                                                        alpha:1];
    // show appKey
    NSString *appKey = [self getAppKey];
    if (appKey) {
        _appKeyLabel.text = appKey;
        _appKeyLabel.textColor = [UIColor colorWithRed:0.0 / 255
                                                 green:122.0 / 255
                                                  blue:255.0 / 255
                                                 alpha:1];
    }
    
    _locationLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapn = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:) ];
    [_locationLabel addGestureRecognizer:tapn];

}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    KCMainViewControlle *mapVC = [[KCMainViewControlle alloc]init];
    [self presentViewController:mapVC animated:YES completion:nil];
}
//获取appKey
- (NSString *)getAppKey {
    return [AppKey lowercaseString];
}

-(void)notificationAction:(NSNotification*)noti{
    
    
    NSDictionary *dic = noti.userInfo[@"aps"];
    NSString *allContent = [NSString
                            stringWithFormat:@"%@收到通知:\n%@\nextra:%@",
                            [NSDateFormatter
                             localizedStringFromDate:[NSDate date]
                             dateStyle:NSDateFormatterNoStyle
                             timeStyle:NSDateFormatterMediumStyle],
                            [_messageContents componentsJoinedByString:nil],
                            [self logDic:dic]];
    
    _messageContentView.text = allContent;
    _notificationCount++;
    [self reloadNotificationCountLabel];
    
    
    NotifacationViewController *notiVC = [[NotifacationViewController alloc]init];
    notiVC.noti = noti;
    [self presentViewController:notiVC animated:NO completion:nil];
    
}
#pragma mark 设置定位
- (void)setlocation{
    //获取经纬度
    //实现定位
    //1. 创建位置管理器
    self.mgr = [CLLocationManager new];
    
    //2. 请求授权 --> iOS8开始才需要写
    //除了写方法, 还要配置一个plist键值
    if ([UIDevice currentDevice].systemVersion.doubleValue >= 8.0) {
        [self.mgr requestWhenInUseAuthorization];
    }
    
    //3. 设置代理 --> 获取数据
    self.mgr.delegate = self;
    
    //4. 开始定位
    [self.mgr startUpdatingLocation];
    
    //1. 距离筛选器 --> 当位置发生一定的改变时, 再调用代理方法, 以此节省电量
    //当发生10米以上的位移之后才会调用代理方法
    self.mgr.distanceFilter = 10;
    
    //2. 定位精准度
    //降低精准度, 可以减少手机和卫星之间的数据计算. 就会节省电量
    //设置精准度
    self.mgr.desiredAccuracy = kCLLocationAccuracyBest;
    
    _locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 300, kScreenWidth - 40, 100)];
    
    
    _locationLabel.hidden = YES;
    _locationLabel.numberOfLines = 0;
    _locationLabel.font = [UIFont systemFontOfSize:17];
    _locationLabel.backgroundColor = [UIColor orangeColor];
    
    [self.view addSubview:_locationLabel];
}
#pragma mark 当更新位置信息之后, 会调用此方法 --> 此方法频繁调用
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = locations.lastObject;
    
    
    //东经正数，西经为负数  北纬为正数，南纬为负数
    //NSLog(@"纬度: %.10f, 经度: %.10f", location.coordinate.latitude, location.coordinate.longitude);
    //[self addressWithLocation:location];
    //double latitude = location.coordinate.longitude;
    //39.829261192949375  116.27489510587014

    if (location.horizontalAccuracy > 0) {//水平位置的是否精确
        //NSLog(@"location = %@",location);
        //[manager stopUpdatingLocation];
        //        ///经度
        //        double latitude = location.coordinate.latitude;
        //        ///纬度
        //        double longtitude = location.coordinate.longitude;
        //        [[NSUserDefaults standardUserDefaults] setObject:@(latitude) forKey:@"latitude"];
        //        [[NSUserDefaults standardUserDefaults] setObject:@(longtitude) forKey:@"longitude"];
        
        // 获取当前所在的城市名
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        
        //根据经纬度反向地理编译出地址信息
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *array, NSError *error)
         {
             if (array.count > 0)
             {
                 CLPlacemark *placemark = [array objectAtIndex:0];
                 
                 //NSLog(@"placemark = %@,placemark.name = %@",placemark,placemark.name);
                 //获取位置信息
                 NSString *local = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",placemark.administrativeArea,placemark.locality,placemark.subLocality,placemark.thoroughfare,placemark.name];
                 NSLog(@"local = %@",local);
                 //                 NSLog(@"%@%@%@%@%@",placemark.administrativeArea,placemark.locality,placemark.subLocality,placemark.thoroughfare,placemark.name);
                 
                 
                 //                 [kUserDefaults setObject:local forKey:@"USERLOCAL"];
                 
                 _locationLabel.text = [NSString stringWithFormat: @"位置信息:%@ \n精度:%.10lf,维度:%.10lf",local,location.coordinate.longitude,location.coordinate.latitude];
             }
             else if (error == nil && [array count] == 0)
             {
                 NSLog(@"No results were returned.");
             }
             else if (error != nil)
             {
                 NSLog(@"An error occurred = %@", error);
             }
         }];
        
        //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    }
    
    
}


- (void)dealloc {
    [self unObserveAllNotifications];
}

- (void)unObserveAllNotifications {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidSetupNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidCloseNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidRegisterNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidLoginNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidReceiveMessageNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFServiceErrorNotification
                           object:nil];
}
- (void)networkDidSetup:(NSNotification *)notification {
    _netWorkStateLabel.text = @"已连接";
    NSLog(@"已连接");
    _netWorkStateLabel.textColor = [UIColor colorWithRed:0.0 / 255
                                                   green:122.0 / 255
                                                    blue:255.0 / 255
                                                   alpha:1];
}

- (void)networkDidClose:(NSNotification *)notification {
    _netWorkStateLabel.text = @"未连接。。。";
    NSLog(@"未连接");
    _netWorkStateLabel.textColor = [UIColor redColor];
}

- (void)networkDidRegister:(NSNotification *)notification {
    NSLog(@"%@", [notification userInfo]);
    _netWorkStateLabel.text = @"已注册";
    _netWorkStateLabel.textColor = [UIColor colorWithRed:0.0 / 255
                                                   green:122.0 / 255
                                                    blue:255.0 / 255
                                                   alpha:1];
    _registrationValueLabel.text =
    [[notification userInfo] valueForKey:@"RegistrationID"];
    _registrationValueLabel.textColor = [UIColor colorWithRed:0.0 / 255
                                                        green:122.0 / 255
                                                         blue:255.0 / 255
                                                        alpha:1];
    NSLog(@"已注册");
}

- (void)networkDidLogin:(NSNotification *)notification {
    _netWorkStateLabel.text = @"已登录";
    _netWorkStateLabel.textColor = [UIColor colorWithRed:0.0 / 255
                                                   green:122.0 / 255
                                                    blue:255.0 / 255
                                                   alpha:1];
    NSLog(@"已登录");
    
    [JPUSHService setTags:[NSSet setWithObjects: @"100",@"200", nil] alias:@"芙蓉去哪了" callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    
    if ([JPUSHService registrationID]) {
        _registrationValueLabel.text = [JPUSHService registrationID];
        NSLog(@"get RegistrationID");
    }
}

- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    NSString *callbackString =
    [NSString stringWithFormat:@"%d, \ntags: %@, \nalias: %@\n", iResCode,
     [self logSet:tags], alias];
    
    NSLog(@"TagsAlias回调:%@", callbackString);
}

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logSet:(NSSet *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSString *title = [userInfo valueForKey:@"title"];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDictionary *extra = [userInfo valueForKey:@"extras"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    NSString *currentContent = [NSString
                                stringWithFormat:
                                @"收到自定义消息:%@\ntitle:%@\ncontent:%@\nextra:%@\n",
                                [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                               dateStyle:NSDateFormatterNoStyle
                                                               timeStyle:NSDateFormatterMediumStyle],
                                title, content, [self logDic:extra]];
    NSLog(@"%@", currentContent);
    
    [_messageContents insertObject:currentContent atIndex:0];
    
    NSString *allContent = [NSString
                            stringWithFormat:@"%@收到消息:\n%@\nextra:%@",
                            [NSDateFormatter
                             localizedStringFromDate:[NSDate date]
                             dateStyle:NSDateFormatterNoStyle
                             timeStyle:NSDateFormatterMediumStyle],
                            [_messageContents componentsJoinedByString:nil],
                            [self logDic:extra]];
    
    _messageContentView.text = allContent;
    _messageCount++;
    [self reloadMessageCountLabel];
}

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

- (void)serviceError:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSString *error = [userInfo valueForKey:@"error"];
    NSLog(@"%@", error);
}

- (void)addNotificationCount {
    _notificationCount++;
    [self reloadNotificationCountLabel];
}

- (void)addMessageCount {
    _messageCount++;
    [self reloadMessageCountLabel];
}

- (void)reloadMessageContentView {
    _messageContentView.text = @"";
}

- (void)reloadMessageCountLabel {
    _messageCountLabel.text = [NSString stringWithFormat:@"%d", _messageCount];
}

- (void)reloadNotificationCountLabel {
    _notificationCountLabel.text =
    [NSString stringWithFormat:@"%d", _notificationCount];
}

- (IBAction)cleanMessage:(id)sender {
    _messageCount = 0;
    _notificationCount = 0;
    [self reloadMessageCountLabel];
    [_messageContents removeAllObjects];
    [self reloadMessageContentView];
    self.notificationCountLabel.text = @"0";
}

@end
