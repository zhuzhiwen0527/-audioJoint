//
//  ViewController.m
//  audioJoint
//
//  Created by zzw on 16/10/7.
//  Copyright © 2016年 zzw. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "audioJoint.h"
@interface ViewController ()
@property (nonatomic,copy) AVAudioPlayer * player;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


}
- (IBAction)click:(id)sender {
    
    
    NSString * pathA = [[NSBundle mainBundle] pathForResource:@"小苹果" ofType:@"mp3"];
    NSString * pathB = [[NSBundle mainBundle] pathForResource:@"12 走在冷风中" ofType:@"mp3"];
    NSString * path =  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject] stringByAppendingPathComponent:@"audiojonint.m4a"];
    
  
    [audioJoint exportPath:path withFilePathA:pathA FilePathB:pathB withStartTime:100 withEndTime:300 withBlock:^(BOOL is) {
        if (is) {
            
            NSLog(@"%@",path);
            
          _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
            [_player play];
        }else{
        
            NSLog(@"失败");
        }
    
    }];
        
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
