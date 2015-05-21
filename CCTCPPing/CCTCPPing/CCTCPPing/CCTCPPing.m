//
//  CCTCPPing.m
//  CCTCPPing
//
//  Created by gaea on 15/5/15.
//  Copyright (c) 2015年 cctao. All rights reserved.
//

#import "CCTCPPing.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
@interface CCTCPPing()
@property (nonatomic, assign) int clientSocket;
@end
@implementation CCTCPPing

+ (instancetype)shareTCPPing{
    return [[self alloc]init];
}

#pragma mark - 发送和接收
- (NSTimeInterval)sendAndRecv:(NSString *)sendMsg {
    NSTimeInterval beginTime = [self timeNowGet];
    send(self.clientSocket, sendMsg.UTF8String, strlen(sendMsg.UTF8String), 0);
    uint8_t buffer[1024];
    ssize_t recvLen = 0;
    recvLen = recv(self.clientSocket, &buffer, sizeof(buffer), 0);
    NSTimeInterval endTime = [self timeNowGet];
    if (recvLen < 0) {
        NSLog(@"错误");
        return -1;
    }
    return endTime - beginTime;
}

#pragma mark - 获取发送遵守HTTP协议的msg
- (NSString *)httpMsg:(NSString *)hostName port:(int)port{
    
  return [NSString stringWithFormat:@"GET / HTTP/1.1\nHost: %@:%d\n\n",hostName,port];
   
}

#pragma mark - 发送数据
- (void)sendMsg:(NSString *)sendMsg{
   send(self.clientSocket, sendMsg.UTF8String, strlen(sendMsg.UTF8String), 0);
}

#pragma mark - 接受数据
- (NSString *)receiveData{
    uint8_t buffer[1024];
    ssize_t recvLen = 0;
    recvLen = recv(self.clientSocket, &buffer, sizeof(buffer), 0);
       if (recvLen < 0) {
        NSLog(@"错误");
        return nil;
    }
    NSData *data = [NSData dataWithBytes:buffer length:recvLen];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

#pragma mark - 连接到服务器
- (BOOL)connect:(NSString *)hostName port:(int)port {
    self.clientSocket = socket(AF_INET, SOCK_STREAM, 0);
    
    struct sockaddr_in serverAddr;
    serverAddr.sin_family = AF_INET;
    serverAddr.sin_addr.s_addr = inet_addr(hostName.UTF8String);
    serverAddr.sin_port = htons(port);
    
   
    if (self.connectTimeout.tv_sec != 0 && self.connectTimeout.tv_usec != 0 )
    {
     struct timeval timeout = self.connectTimeout;
     setsockopt(self.clientSocket,SOL_SOCKET,SO_SNDTIMEO,(char *)&timeout,sizeof(struct timeval));
    }
    BOOL bDontLinger = FALSE;
    setsockopt(self.clientSocket,SOL_SOCKET, SO_LINGER, (const char*)&bDontLinger,sizeof(BOOL));
    
    if (connect(self.clientSocket, (const struct sockaddr *)&serverAddr, sizeof(serverAddr)) == 0)
    {
        
        if (self.sendTimeout.tv_sec != 0 && self.sendTimeout.tv_usec != 0 )
        {
            struct timeval timeout = self.sendTimeout;
            setsockopt(self.clientSocket,SOL_SOCKET,SO_SNDTIMEO,(char *)&timeout,sizeof(struct timeval));
        }
        if (self.revcTimeout.tv_sec != 0 && self.revcTimeout.tv_usec != 0 )
        {
            struct timeval timeout = self.revcTimeout;
            setsockopt(self.clientSocket,SOL_SOCKET,SO_RCVTIMEO,(char *)&timeout,sizeof(struct timeval));

        }
        
               return YES;
    }
    NSLog(@"连接超时");
    return NO;
    
}
 
- (void )closeConnect:(int)closeType{
    shutdown(self.clientSocket,closeType);
}

- (NSTimeInterval)timeNowGet{
    return [[NSDate date] timeIntervalSince1970]*1000;
}


@end
