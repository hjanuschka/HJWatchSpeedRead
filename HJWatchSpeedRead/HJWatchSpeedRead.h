//
//  HJWatchSpeedRead.h
//  Sample
//
//  Created by Helmut on 06.05.15.
//  Copyright (c) 2015 Helmut. All rights reserved.
//
#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@class HJWatchSpeedRead;
@protocol HJWatchSpeedReadDelegate <NSObject>

@optional

- (void)HJWatchSpeedReadController:(HJWatchSpeedRead * )HJWatchSpeedReadController didShowWordIndex:(NSUInteger)wordIndex;
- (void)HJWatchSpeedReadController:(HJWatchSpeedRead * )HJWatchSpeedReadController showWord:(NSAttributedString *)word;

- (void)HJWatchSpeedReadControllerDidStartShowingWords:(HJWatchSpeedRead * )HJWatchSpeedReadController;

- (void)HJWatchSpeedReadControllerDidFinishShowingWords:(HJWatchSpeedRead * )HJWatchSpeedReadController;

@end


@class HJWatchSpeedRead;
@interface HJWatchSpeedRead : NSObject

@property (nonatomic) BOOL isStarted;
@property (nonatomic) NSUInteger wordsPerMinute;
@property (nonatomic) NSUInteger currentWordIndex;

@property (nonatomic, strong) WKInterfaceLabel * wordLabel;
@property (nonatomic, weak) id<HJWatchSpeedReadDelegate> delegate;

@property (nonatomic, readonly) NSUInteger totalWordCount;

- (instancetype)initWithBodyText:(NSString *)bodyText;

- (void)start;
- (void)startWithoutAnimation;
- (void)stop;

- (void)displayWordWithIndex:(NSInteger)wordIndex;

@end
