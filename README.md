# CCTCPPing
TCP ping 测量网路延时
******
使用说明：
* CCTCPPingFile文件夹拖入项目中
* 导入CCTCPPing.h头文件 

* 建立sock连接
  - (BOOL)connect:(NSString *)hostName port:(int)port;
  
* 发送数据（遵守HTTP协议的msg）
  - (void)sendMsg:(NSString *)sendMsg;
  
* 接收数据
- (NSString *)receiveData;

* 关闭连接
 - (void )closeConnect:(int)closeType;





