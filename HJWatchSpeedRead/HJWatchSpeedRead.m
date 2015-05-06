//
//  HJWatchSpeedRead.m
//  Sample
//
//  Created by Helmut on 06.05.15.
//  Copyright (c) 2015 Helmut. All rights reserved.
//

#import "HJWatchSpeedRead.h"
static const char * VSShowNewWordQueue = "VSShowNewWordQueue";


@interface HJWatchSpeedRead()

@property (nonatomic, strong) NSArray *words;
@property (nonatomic) dispatch_queue_t dispatchQueue;

@end

@implementation HJWatchSpeedRead

- (void)startWithoutAnimation {
    self.isStarted = YES;
    [self startShowingWords];
}

- (NSUInteger)totalWordCount {
    return self.words.count;
}

- (void)displayWordWithIndex:(NSInteger)wordIndex {
    if (wordIndex >= self.totalWordCount) {
        NSLog(@"oh shit");
    }
    NSAssert(0 <= wordIndex && wordIndex < self.totalWordCount, @"wordIndex must be between 0 and totalWordCount-1");
    
    NSString *word = self.words[wordIndex];
    if (!word || [word isEqualToString:@""]) {
        return;
    } else {
        //[self.spritzView setWord:word pivotCharacterIndex:[[self class] pivotCharacterIndexForWord:word]];
//        CALLBACK
//        NSLog(@"SET WORD: %@ with pv-char: %d", word, [[self class] pivotCharacterIndexForWord:word]);
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(HJWatchSpeedReadController:showWord:)]) {
            
            NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:word];
           // [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(ceil([word length]/2),1)];
            
            
            
       
            
            [self.delegate HJWatchSpeedReadController:self showWord:string];
        }
        
    }
}


+ (int)pivotCharacterIndexForWord:(NSString*)word {
    int wordLength = (int)[word length];
    switch (wordLength) {
        case 0:
            return 0;
        case 1:
            return 0; // first
        case 2:
        case 3:
        case 4:
        case 5:
            return 1; // second
        case 6:
        case 7:
        case 8:
        case 9:
            return 2; // third
        case 10:
        case 11:
        case 12:
        case 13:
            return 3; // fourth
        default:
            return 4; // fifth
    };
}


- (void)stop {
    self.isStarted = NO;
}

+ (float)relativeTimeForWord:(NSString*)word {
    NSRange strongRange = [word rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@".:?!"]];
    NSRange weakRange = [word rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@",-("]];
    if (strongRange.location != NSNotFound) return 3;
    if (weakRange.location != NSNotFound) return 2;
    if (word.length >= 8) return 2;
    return 1;
}


- (void)startShowingWords {
    dispatch_async(self.dispatchQueue, ^{
        for (; self.currentWordIndex<self.words.count; self.currentWordIndex++) {
            if (self.isStarted == NO) {
                break;
            }
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self displayWordWithIndex:self.currentWordIndex];
                /*
                
                 */
            });
            if (self.currentWordIndex < self.words.count - 1) {
                float timeMod = [[self class] relativeTimeForWord:self.words[self.currentWordIndex]];
                NSTimeInterval interval = 60.0 / (float)self.wordsPerMinute * timeMod;
                usleep(1000000 * interval);
//                sleep(5);
            }
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.isStarted = NO;
            /*
             if (self.delegate && [self.delegate respondsToSelector:@selector(spritzViewControllerDidFinishShowingWords:)]) {
                [self.delegate spritzViewControllerDidFinishShowingWords:self];
            }
             */
            NSLog(@"FINISHED");
        });
    });
}


- (void)start {
//    NSAssert(self.spritzView != nil, @"Must set `spritzView` property before calling start");
    
    if (self.currentWordIndex >= self.words.count - 1) {
        self.currentWordIndex = 0;
        self.isStarted = NO;
    }
    
    if (self.isStarted == NO) {
        self.isStarted = YES;
        [self displayWordWithIndex:self.currentWordIndex];
        [self startShowingWords];
        
    }
}



- (instancetype)initWithBodyText:(NSString *)bodyText {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _words = [[self class] wordsForString:bodyText];
    _currentWordIndex = 0;
    _wordsPerMinute = 300;
    _isStarted = NO;
    _dispatchQueue = dispatch_queue_create(VSShowNewWordQueue, 0);
    
    NSLog(@"DISPLAYING WORDS: %@", _words);
    return self;
}

+ (NSArray*)wordsForString:(NSString*)text {
    NSMutableArray *separated = [[text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" \n"]] mutableCopy];
    for (int i = 0; i < [separated count]; i++)
    {
        if ([separated[i] length] > 13)
        {
            int separateAt = floorf([separated[i] length]/2.0);
            NSInteger dashLocation = [separated[i] rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"-"]].location;
            if (dashLocation != NSNotFound) separateAt = (int)dashLocation;
            NSString *firstString = [[separated[i] substringToIndex:separateAt] stringByAppendingString:@"-"];
            NSString *secondString = [separated[i] substringFromIndex:separateAt+(separateAt==dashLocation?1:0)];
            [separated removeObjectAtIndex:i];
            [separated insertObject:firstString atIndex:i];
            [separated insertObject:secondString atIndex:i+1];
        }
    }
    return separated;
}


@end