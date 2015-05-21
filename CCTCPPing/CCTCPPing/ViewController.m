//
//  ViewController.m
//  CCTCPPing
//
//  Created by gaea on 15/5/15.
//  Copyright (c) 2015年 cctao. All rights reserved.
//

#import "ViewController.h"
#import "CCTCPPing.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *hostTextFile;
@property (weak, nonatomic) IBOutlet UITextField *portTextFile;
@property (weak, nonatomic) IBOutlet UITextField *timesTextFile;
@property (weak, nonatomic) IBOutlet UITextView *resultTextView;

@property (strong, nonatomic) CCTCPPing *tcpPing;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)pingResult:(id)sender {
    NSString *host = [self.hostTextFile text];
    int port = [[self.portTextFile text] intValue];
    int times = [[self.timesTextFile text] intValue];
    
    self.tcpPing = [CCTCPPing shareTCPPing];
    
    NSArray *ipArray = [NSArray arrayWithObjects:host,nil];
    NSArray *portArray = [NSArray arrayWithObjects:@(port), nil];
    
    self.resultTextView.text = [self netStatusWithIpAddress:ipArray port:portArray times:times];
    
}

#pragma mark - 获取网络状态
/**
 *  获取检测延时列表
 *
 *  @param ipArray 检测网络延迟的主机列表
 *  @param times   每个主机列表检测的次数
 *  @param times   每个主机列表检测的次数
 *
 *  @return  获取检测延时列表
 */
- (NSString *)netStatusWithIpAddress:(NSArray *)ipArray port:(NSArray *)portArray times:(int)times{
    if (ipArray.count == 0)return @"ERROE";
    if (times == 0) times = 1;
    NSMutableString *netStatusStr = [[NSMutableString alloc]init];
    // 1. 连接到服务器
    for (int j = 0; j<ipArray.count; j++) {
        NSString *host = ipArray[j];
        int port = [portArray[j] intValue];
        [netStatusStr appendString:[NSString stringWithFormat:@"%@:",host]];
        if ([self.tcpPing connect:host port:port]) {
            NSString *request = [self.tcpPing httpMsg:host port:port];
            for (int i = 0; i < times; i++) {
                int durationTime = [self.tcpPing sendAndRecv:request];
                if (i == times - 1) {
                    [netStatusStr appendString:[NSString stringWithFormat:@"%d;",durationTime]];
                }else{
                    [netStatusStr appendString:[NSString stringWithFormat:@"%d,",durationTime]];
                }
            }
            
        } else {
            for (int i = 0; i < times; i++) {
                
                if (i == times -1) {
                    [netStatusStr appendString:@"-1;"];
                }else{
                    [netStatusStr appendString:@"-1,"];
                }
            }
            
            NSLog(@"连接失败");
        }
        [self.tcpPing closeConnect:2];
    }
    
    return [netStatusStr substringWithRange:NSMakeRange(0, [netStatusStr length] - 1)];;
}
@end
