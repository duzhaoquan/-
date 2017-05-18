//
//  TextViewController.h
//  生日快乐
//
//  Created by jp123 on 2017/4/25.
//  Copyright © 2017年 jp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *appKeyLabel;
@property(weak, nonatomic) IBOutlet UILabel *netWorkStateLabel;
@property(weak, nonatomic) IBOutlet UILabel *deviceTokenValueLabel;
@property(weak, nonatomic) IBOutlet UILabel *UDIDValueLabel;
@property(weak, nonatomic) IBOutlet UILabel *messageCountLabel;
@property(weak, nonatomic) IBOutlet UITextView *messageContentView;
@property(weak, nonatomic) IBOutlet UILabel *registrationValueLabel;

@property(weak, nonatomic) IBOutlet UILabel *notificationCountLabel;
- (void)addNotificationCount;
- (IBAction)cleanMessage:(id)sender;


@end
