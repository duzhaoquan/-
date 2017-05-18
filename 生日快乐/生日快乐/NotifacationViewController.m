//
//  NotifacationViewController.m
//  生日快乐
//
//  Created by jp123 on 2016/11/14.
//  Copyright © 2016年 jp. All rights reserved.
//

#import "NotifacationViewController.h"

@interface NotifacationViewController ()
@property (weak, nonatomic) IBOutlet UITextView *MyTextView;

@end

@implementation NotifacationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *dic = _noti.userInfo[@"aps"];
    NSString *allContent = [NSString
                            stringWithFormat:@"%@收到通知:\n\nextra:%@",
                            [NSDateFormatter
                             localizedStringFromDate:[NSDate date]
                             dateStyle:NSDateFormatterNoStyle
                             timeStyle:NSDateFormatterMediumStyle],
                            [self logDic:dic]];
    _MyTextView.text = allContent;
    
    
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


- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
