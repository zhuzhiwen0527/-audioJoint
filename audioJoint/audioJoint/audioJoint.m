//
//  audioJoint.m
//  audioJoint
//
//  Created by zzw on 16/10/7.
//  Copyright © 2016年 zzw. All rights reserved.
//

#import "audioJoint.h"
#import <AVFoundation/AVFoundation.h>
#define KFILESIZE (1 * 1024 * 1024)
@implementation audioJoint




// 支持音频:m4a  视频:mp4

+ (void)exportPath:(NSString *)exportPath

     withFilePathA:(NSString *)filePathA

        FilePathB:(NSString*)filePathB

     withStartTime:(int64_t)startTime

       withEndTime:(int64_t)endTime

         withBlock:(void(^)(BOOL))block

{
    
    NSString * filePath = filePathA;
    
    if (![self pieceFileA:filePathA withFileB:filePathB]) {
        
        NSLog(@"失败");
        return;
    }
    
    NSString *presetName;
    
    NSString *outputFileType;
    

    
    if ([filePath.lastPathComponent containsString:@"mp4"]) {
        
        
        
        presetName = AVAssetExportPreset1280x720;
        
        outputFileType = AVFileTypeMPEG4;
        
        
        
    }else if ([filePath.lastPathComponent containsString:@"mp3"]){
        
        
        
        presetName = AVAssetExportPresetAppleM4A;
        
        outputFileType = AVFileTypeAppleM4A;
        
        
        
    }else{
        
   
        
        block(NO);   return;
        
    }
    
    
    
    // 1.拿到预处理音频文件
    
    NSURL *songURL = [NSURL fileURLWithPath:filePath];
    
    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:songURL options:nil];
    
    
    
    // 2.创建新的音频文件
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:exportPath]) {
        
        [[NSFileManager defaultManager] removeItemAtPath:exportPath error:nil];
        
    }
    
    
    
    NSError *assetError;
    
    NSURL *exportURL = [NSURL fileURLWithPath:exportPath];
    
    AVAssetWriter *assetWriter = [AVAssetWriter assetWriterWithURL:exportURL
                                  
                                                          fileType:AVFileTypeCoreAudioFormat
                                  
                                                             error:&assetError];
    
    if (assetError) {
        
        NSLog (@"创建文件失败 error: %@", assetError);
        
        block(NO);
        
    }
    
    
    
    
    
    // 3.创建音频输出会话
    
    //
    
    AVAssetExportSession *exportSession = [AVAssetExportSession exportSessionWithAsset:songAsset
                                           
                                                                            presetName:presetName];
    
    
    
    CMTime _startTime = CMTimeMake(startTime, 1);
    
    CMTime _stopTime = CMTimeMake(endTime, 1);
    
    CMTimeRange exportTimeRange = CMTimeRangeFromTimeToTime(_startTime, _stopTime);
    
    
    
    // 4.设置音频输出会话并执行
    
    exportSession.outputURL = [NSURL fileURLWithPath:exportPath]; // output path
    
    exportSession.outputFileType = outputFileType;            // output file type AVFileTypeAppleM4A
    
    exportSession.timeRange = exportTimeRange;                    // trim time range
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        
        
        
        if (AVAssetExportSessionStatusCompleted == exportSession.status) {
            
            
            
            NSLog(@"AVAssetExportSessionStatusCompleted");
            
  
            
            block(YES);
            
            
            
        } else if (AVAssetExportSessionStatusFailed == exportSession.status) {
            
            
            
            NSLog(@"AVAssetExportSessionStatusFailed");
            
            block(NO);
            
            
            
        } else {
            
            
            
            NSLog(@"Export Session Status: %ld", (long)exportSession.status);
            
            block(NO);
            
        }
        
    }];
    
    
    
}

+ (BOOL)pieceFileA:(NSString *)filePathA

         withFileB:(NSString *)filePathB

{
    
    // 更新的方式读取文件A
    
    NSFileHandle *handleA = [NSFileHandle fileHandleForUpdatingAtPath:filePathA];
    
    [handleA seekToEndOfFile];
    
    
    
    NSDictionary *fileBDic = [[NSFileManager defaultManager] attributesOfItemAtPath:filePathB error:nil];
    
    long long fileSizeB    = fileBDic.fileSize;
    
    
    
    // 大于xM分片拼接xM
    
    if (fileSizeB > KFILESIZE) {
        
        
        
        // 分片
        
        long long pieces = fileSizeB /KFILESIZE;   // 整片
        
        long long let    = fileSizeB %KFILESIZE;   // 剩余片
        
        
        
        long long sizes = pieces;
        
        // 有余数
        
        if (let > 0) {
            
            // 加多一片
            
            sizes += 1;
            
        }
        
        
        NSFileHandle *handleB = [NSFileHandle fileHandleForReadingAtPath:filePathB];
        
        for (int i =0; i < sizes; i++) {
            
            
            
            [handleB seekToFileOffset:i * KFILESIZE];
            
            NSData *tmp = [handleB readDataOfLength:KFILESIZE];
            
            [handleA writeData:tmp];
            
        }
        
        
        
        [handleB synchronizeFile];
        
        
        
        // 大于xM分片读xM(最后一片可能小于xM)
        
    }else{
        
        
        
        [handleA writeData:[NSData dataWithContentsOfFile:filePathB]];
        
        
        
    }
    
    
    
    [handleA synchronizeFile];
    
    
    
    // 将B文件删除
    
    [[NSFileManager defaultManager] removeItemAtPath:filePathB error:nil];
    
    
    
    return YES;
    
}

@end
