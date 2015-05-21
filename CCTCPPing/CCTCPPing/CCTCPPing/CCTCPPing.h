//
//  CCTCPPing.h
//  CCTCPPing
//
//  Created by gaea on 15/5/15.
//  Copyright (c) 2015年 cctao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCTCPPing : NSObject
@property (nonatomic,assign)struct timeval sendTimeout;//发送超时设置
@property (nonatomic,assign)struct timeval revcTimeout;//接收超时设置
@property (nonatomic,assign)struct timeval connectTimeout;//连接超时设置

+ (instancetype)shareTCPPing;

/**
 *  获取发送遵守HTTP协议的msg
 *
 *  @param hostName 接收数据的主机
 *  @param port     接收数据的端口号
 *
 *  @return 遵守http协议的数据
 */
- (NSString *)httpMsg:(NSString *)hostName port:(int)port;

/**
 *  发送数据
 *
 *  @param sendMsg 要发送的数据
 */
- (void)sendMsg:(NSString *)sendMsg;

/**
 *  读取数据
 *
 *  @return 服务器返回信息
 */
- (NSString *)receiveData;

/**
 *  获取延迟时间
 *
 *  @param sendMsg 想发送的数据（遵守http协议的数据）
 *
 *  @return 延迟时间
 */

- (NSTimeInterval)sendAndRecv:(NSString *)sendMsg;

/**
 *  连接某个主机
 *
 *  @param hostName 服务器地址
 *  @param port     端口号
 *
 *  @return 连接是否成功
 */
- (BOOL)connect:(NSString *)hostName port:(int)port;

/**
 *  关闭连接
 *
 *  @param closeType 0 代表禁止下次的数据读取；
                     1 代表禁止下次的数据写入；
                     2 代表禁止下次的数据读取和写入
 */
- (void )closeConnect:(int)closeType;
/**
 获取当前时间，精确到毫秒
 */
/**
 *  获取当前时间，精确到毫秒
 *
 *  @return 当前时间（精确到毫秒）
 */
- (NSTimeInterval)timeNowGet;



@end
