//
//  audioJoint.h
//  audioJoint
//
//  Created by zzw on 16/10/7.
//  Copyright © 2016年 zzw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface audioJoint : NSObject
// 支持音频:m4a  视频:mp4

+ (void)exportPath:(NSString *)exportPath//合成后保存路径

     withFilePathA:(NSString *)filePathA//文件a路径

         FilePathB:(NSString*)filePathB//文件b路径

     withStartTime:(int64_t)startTime//开始起始时间

       withEndTime:(int64_t)endTime//结束时间

         withBlock:(void(^)(BOOL))block;//合成后的回调
@end
