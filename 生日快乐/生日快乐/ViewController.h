//
//  ViewController.h
//  生日快乐
//
//  Created by jp123 on 2016/11/9.
//  Copyright © 2016年 jp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <corelocation/corelocation.h>
@interface ViewController : UIViewController{
    NSMutableArray *_messageContents;
    int _messageCount;
    int _notificationCount;
}

/** 位置管理器 --> 主要用于定位授权*/
@property (nonatomic, strong) CLLocationManager *mgr;


@property (weak, nonatomic) IBOutlet UILabel *appKeyLabel;
@property(weak, nonatomic) IBOutlet UILabel *netWorkStateLabel;
@property(weak, nonatomic) IBOutlet UILabel *deviceTokenValueLabel;
@property(weak, nonatomic) IBOutlet UILabel *UDIDValueLabel;
@property(weak, nonatomic) IBOutlet UILabel *messageCountLabel;
@property(weak, nonatomic) IBOutlet UITextView *messageContentView;
@property(weak, nonatomic) IBOutlet UILabel *registrationValueLabel;
@property(weak, nonatomic) IBOutlet UIButton *cleanMessageButton;
@property(weak, nonatomic) IBOutlet UILabel *notificationCountLabel;
- (void)addNotificationCount;
- (IBAction)cleanMessage:(id)sender;



@end

