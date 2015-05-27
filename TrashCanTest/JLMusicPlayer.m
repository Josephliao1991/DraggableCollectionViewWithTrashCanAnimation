//
//  JLMusicPlayer.m
//  VibrationTest
//
//  Created by TSUNG-LUN LIAO on 2015/5/25.
//  Copyright (c) 2015年 TSUNG-LUN LIAO. All rights reserved.
//
//- See more at:
//http://furnacedigital.blogspot.tw/2010/12/core-audio.html#sthash.fv7JklJj.dpuf


#import "JLMusicPlayer.h"

@implementation JLMusicPlayer

+ (void)playVibrate{
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
}

@end
